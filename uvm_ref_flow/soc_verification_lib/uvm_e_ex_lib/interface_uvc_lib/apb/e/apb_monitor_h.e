---------------------------------------------------------------
File name   :  apb_monitor_h.e
Title       :  Bus and agent monitors declaration.
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:55 2008
Description :  This file declares the bus monitor and agent monitor units.

Notes       :  In our implementation we use both bus monitor and agent monitor.
            :  Collecting and constructing of the data-item from the bus
            :  is done once by the bus monitor and then the data-item
            :  is transferred to the specific agent monitor.
---------------------------------------------------------------
Copyright 1999-2010 Cadence Design Systems, Inc.
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

---------------------------------------------------------------

<'

package apb;

// The monitor transaction struct extends the base 
// transaction struct.
struct apb_monitor_transaction like apb_trans_s {
    
  // The monitor calculate the transaction and transaction response
  // delays into those fields
  !response_delay    : uint;

  // Names of the item initiator master and responding slave
  !master_name  : apb_agent_name_t;
  !slave_name   : apb_agent_name_t;
  
  // -----------------------------------------------------------------------
  // Return a string describing the transaction.
  // -----------------------------------------------------------------------
  transaction_str() : string is only {
    result = append(master_name,"=>",slave_name,": Addr:",hex(addr)," ",direction," Data:",hex(data));};
};

// Bus monitor unit. It monitors all activity on the bus and collects 
// information on each item that occurs.
extend apb_bus_monitor   {
   
  // Logical name of the env that contains this bus monitor. This field 
  // is automatically constrained by the UVC. It should not be constrained 
  // by the user.
  env_name : apb_env_name_t;
  
  // Back-pointer to the env that contains this monitor
  p_env : apb_env;
  
  // Signal map reference
  p_smp      : apb_smp;
  
  // Reference to the master that initiated the current transaction
  package !current_master : apb_agent;
  
  // Reference to the slave that responded to the current transaction
  package !current_slave : apb_agent;
   
  // This field determines the name of the bus monitor log file 
  // (default: apb.elog). If this field is 
  // empty, the bus monitor will not write a log file.
  log_filename : string;
  keep soft log_filename == "apb";
  
  // If this field is TRUE, the bus monitor performs protocol checking.
  // This field is normally controlled by the main field of the same
  // name in the env.
  has_checks : bool;
  
  // If this field is TRUE, the UVC provides functional coverage for the
  // bus monitor. This field is normally controlled by the main field
  // of the same name in the env.
  has_coverage : bool;
  keep soft has_coverage;
  
  // Those fields are used to calculate the transaction and
  // transaction response delays
  !transaction_delay_start : uint;
  !response_delay_start    : uint;
  
  // Current monitored transaction.
  !transaction : apb_monitor_transaction;
  
  // This field counts the total number of transactions monitored
  // during the test. The user should not alter or constrain this field.
  !num_transactions : uint;
    
  // The following are useful events provided by the bus monitor. Note that
  // these events are only declared here. The actual implementation of these
  // events is in the file apb_bus_monitor.e
  
  // This event is the rising edge of the START signal.
  event start_rise;
      
  // This event is the falling edge of the START signal.
  event start_fall;
  
  // This event is emitted by the monitor 
  // at the beginning of a transaction
  event transaction_start;
  
  // This event is emitted by the monitor 
  // at the completion of a request transaction
  event transaction_end;
        
  // This TLM port is the scoreboard hook for the monitor. This
  // TLM port will be called at the completion of each transaction
  // on the bus. 
  // Note that the scoreboard hook is bound to empty so that no error
  // is issued if the hook is not in use.
  transaction_complete : out interface_port of tlm_analysis of apb_trans_s is instance;
  keep bind (transaction_complete, empty);
    
  // Bus Monitor color to be used in messages
  bus_mon_vt_style: vt_style;
  keep soft bus_mon_vt_style == GRAY;
  
  // Bus Monitor name to be used in messages
  bus_mon_massage_name : string;
  keep soft bus_mon_massage_name == "BUS_MON";
  
  // The short_name() method should return the name of this UVC instance.
  short_name(): string is {
    result = bus_mon_massage_name;
  };
  
  // This method controls what color the short name is shown in.
  short_name_style(): vt_style is {
    result = bus_mon_vt_style;
  };
};

'>

<'

// =============================================================================
// Agent monitor unit. The agent monitor (used in masters and slaves) 
// filters the information collected by the bus monitor to select
// the transactions handled by a specific agent.
// =============================================================================
extend apb_agent_monitor {
   
  // Logical name of the agent that contains this monitor. This field 
  // is automatically constrained by the UVC. It should not be
  // constrained by the user.
  agent_name : apb_agent_name_t;
   
  // Logical name of the env that contains this monitor. This field
  // is automatically constrained by the UVC. It should not be
  // constrained by the user.
  env_name:   apb_env_name_t;
  
  // Backpointer to the env
  p_env : apb_env;
  
  // Backpointer to the bus monitor
  p_bus_monitor : apb_bus_monitor;
  
  // Backpointer to the agent that contains this monitor
  p_agent : apb_agent;
  
  // If this field is TRUE, the agent monitor performs protocol checking.
  // This field is normally controlled by the main field of the same
  // name in the agent that instantiates this monitor.
  has_checks : bool;
  
  // If this field is TRUE, the UVC provides functional coverage for the
  // agent monitors. This field is normally controlled by the main field
  // of the same name in the agent that instantiates this monitor. 
  has_coverage : bool;
  
  // Current monitored transaction.
  !transaction : apb_monitor_transaction;
  
  // This field counts the total number of transactions monitored
  // during the test. The user should not alter or constrain this field.
  !num_transactions : uint;
  
  // This event is emitted with transaction complete
  // It can be used in conjunction with the transaction field
  // to provide an alternative scoreboard hook.
  event transaction_end;

  // This TLM port is the scoreboard hook for the monitor. This
  // TLM port will be called at the completion of each transaction
  // on the bus. 
  // Note that the scoreboard hook is bound to empty so that no error
  // is issued if the hook is not in use.
  transaction_complete : out interface_port of tlm_analysis of apb_monitor_transaction is instance;
  keep bind (transaction_complete, empty);
  
  // This method can be extended to initiate the agent monitor unit.
  // It is called each time run() is called.   
  init_values() is empty;  
    
  // Agent Monitor color to be used in messages
  agent_mon_vt_style: vt_style;
  keep soft agent_mon_vt_style == GRAY;
  
  // Agent Monitor name to be used in messages
  agent_mon_massage_name : string;
  keep soft agent_mon_massage_name == "AGENT_MON";
  
  // This method returns the name of this UVC instance.
  short_name(): string is {
    result = append(agent_mon_massage_name,"_",agent_name);
  };
  
  // This method controls the color of the short name.
  short_name_style(): vt_style is {
    result = agent_mon_vt_style;
  }; 
};

//==============================================================================
// A monitor that watches a specific master's behavior
//==============================================================================
unit apb_master_monitor like apb_agent_monitor {};

//==============================================================================
// A monitor that watches a specific slave's behavior
//==============================================================================
unit apb_slave_monitor like apb_agent_monitor {};

'>
