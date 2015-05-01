/*-------------------------------------------------------------------------
File name   : apb_agent_h.e
Title       : APB agent implementation
Project     : APB UVC
Developers  : 
Created     : 
Description : This file contains the agent for master and slave for APB bus

Notes       : This files has unit extension for apb master and slave agent.
              when active the agent has instance of bfm and sequence driver
---------------------------------------------------------------------------
Copyright 1999-2011 Cadence Design Systems, Inc.
All Rights Reserved Worldwide

Licensed under the Apache License, Version 2.0 (the
"License"); you may not use this file except in
compliance with the License.  You may obtain a copy of
the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in
writing, software distributed under the License is
distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See
the License for the specific language governing
permissions and limitations under the License.
-------------------------------------------------------------------------*/

<'

package apb;

// Extend the APB Agent
extend apb_agent {
       
  // Environment Name
  env_name : apb_env_name_t;

  // ----------------------------------------------------------
  // This field is the logical name of the agent. This field is
  // automatically constrained by the UVC. Do not constrain it
  // manually.
  // ----------------------------------------------------------
  name     : apb_agent_name_t;
  
  // Backpointer to the UVC env that contains this agent
  p_env    : apb_env;
  
  // This field provides a screen logger for each UVC instance. By default,
  // its verbosity is set to NONE (disabled).
  logger        : message_logger is instance;
  keep soft logger.verbosity == NONE;
  
  // Agents are either active or passive. active agents are agents that drive
  // DUT signals. passive agents never do that, either because they just 
  // monitor an interface within the DUT or because, according to the protocol,
  // no signals need to be driven.
  // This field determines whether an agent is active or passive.
  keep soft active_passive == ACTIVE;
    
  // When this field is true, the UVC agent does protocol checking. This field 
  // can be constrained by the env has_checks flag, but normally it is 
  // determined automatically by the active or passive status of the agent.
  has_checks : bool;
    
  // When this field is true, the UVC agent provides functional coverage
  // for the agent monitors. This field can be constrained by the env 
  // has_coverage field, but normally it is determined automatically by the
  // active or passive status of the agent.
  has_coverage : bool;
    
  // By default, has_checks and has_coverage are false for active agents.
  keep active_passive == ACTIVE  => soft has_checks   == FALSE;
  keep active_passive == ACTIVE  => soft has_coverage == FALSE;
  keep active_passive == PASSIVE => soft has_checks   == TRUE;
  keep active_passive == PASSIVE => soft has_coverage == TRUE;
    
  // Agent color to be used in messages
  agents_vt_style: vt_style;
    
  // Agent name to be used in messages
  agent_message_name : string;
  keep soft agent_message_name == name.as_a(string);
    
  // This method returns the name of the agent instance.
  short_name(): string is only {
    result = agent_message_name;
  }; 
    
  // This method determines the message color.
  short_name_style(): vt_style is {
    return agents_vt_style;
  };
     
};

'>
<'


// The master agents are proactive agents. Proactive agents initiate 
// transactions.The following code customizes master agents.
extend apb_master {
    
  // Reference to the env signal map
  p_smp  : apb_smp;

  // Reference to the bus monitor for this env
  p_bus_monitor : apb_bus_monitor;
     
  // This event is the rising edge of the clock, qualified by reset.
  event clk is rise(p_smp.sig_pclk$)@sim;
 
  // Constrain the MASTER messages color
  keep agents_vt_style == CYAN;
  
  !slave_number : int;

  // This instance of the agent monitor handles agent-specific
  // bus activity.
  agent_monitor : apb_master_monitor is instance;
  keep agent_monitor.agent_name    == name;
  keep agent_monitor.p_agent       == me;
  keep agent_monitor.p_bus_monitor == p_bus_monitor;
  keep agent_monitor.p_env         == p_env;
  keep agent_monitor.env_name      == env_name;
  keep agent_monitor.has_checks    == has_checks;
  keep agent_monitor.has_coverage  == has_coverage;
    
  when ACTIVE apb_master {
       
    // This is the sequence driver for an active master agent.
    driver: apb_master_driver_u is instance;
    keep driver.p_master      == me;
    keep driver.p_bus_monitor == p_bus_monitor; 
    keep driver.p_env         == p_env; 
    keep driver.env_name      == env_name;
    keep driver.master_name   == name;
        
    // BFM for an active master agent
    bfm : apb_master_bfm is instance;
    keep bfm.p_env         == p_env;
    keep bfm.p_bus_monitor == p_bus_monitor;
    keep bfm.env_name      == env_name;
    keep bfm.p_smp         == p_smp;
    keep bfm.p_master      == me;
    keep bfm.p_driver      == driver;

  };

};

'>
<'

// The slave agents are reactive agents. Reactive agents only respond to 
// requests. The following code customizes slave agent.
extend apb_slave {

  // APB slave id 
  id : apb_slave_id_t;
    
  // reference to slave signal
  p_ssmp : apb_slave_signal_map_u;
  
  // Constrain the SLAVE messages color
  keep agents_vt_style == GREEN;
  
  // Reference to the bus monitor for this env
  p_bus_monitor : apb_bus_monitor;

  // This instance of the agent monitor handles agent-specific
  // bus activity.
  agent_monitor : apb_slave_monitor is instance;
  keep agent_monitor.agent_name    == read_only(name);
  keep agent_monitor.p_agent       == read_only(me);
  keep agent_monitor.p_bus_monitor == read_only(p_bus_monitor);
  keep agent_monitor.p_env         == read_only(p_env);
  keep agent_monitor.env_name      == read_only(env_name);
  keep agent_monitor.has_checks    == read_only(has_checks);
  keep agent_monitor.has_coverage  == read_only(has_coverage);
  
  when ACTIVE apb_slave {
     
    // This is the sequence driver for an active slave agent.
    driver: apb_slave_driver_u is instance;
    keep driver.p_slave       == read_only(me);
    keep driver.p_bus_monitor == read_only(p_bus_monitor); 
    keep driver.p_env         == read_only(p_env); 
    keep driver.env_name      == read_only(env_name);
    keep driver.slave_name    == read_only(name);
      
    // BFM for an active SLAVE agent
    bfm : apb_slave_bfm is instance;
    keep bfm.p_env         == read_only(p_env);
    keep bfm.p_bus_monitor == read_only(p_bus_monitor);
    keep bfm.env_name      == read_only(env_name);
    keep bfm.p_ssmp        == read_only(p_ssmp);
    keep bfm.p_slave       == read_only(me);
    keep bfm.p_driver      == read_only(driver);
    keep bfm.p_slave       == me;    

  };

  // This is a memory model used to generate read data according
  // to past write data.
  mem : vr_ad_mem;
  
  // If this field is TRUE then write data will be written into the memory
  // and read data will be taken from the memory. If this field
  // is FALSE, then read data must be supplied by the slave sequence.
  use_mem : bool;
  keep soft use_mem == TRUE;
  
  write(addr: apb_addr_t, data : apb_data_t) is {
    var i : list of byte = pack(packing.low, data);
    mem.update(addr.as_a(uint),i,{});
  };
  
  read(addr : apb_addr_t) : apb_data_t is {
    unpack(packing.low, mem.fetch(addr.as_a(uint),4), result);
  };
  
};


'>
