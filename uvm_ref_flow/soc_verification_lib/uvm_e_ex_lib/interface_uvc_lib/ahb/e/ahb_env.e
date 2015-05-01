---------------------------------------------------------------
File name   : ahb_env.e
Developers  : vishwana
Created     : Tue Mar 30 14:29:27 2010
Description : This file implements the UVC env 
Notes       :  
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

package ahb;

-- ==========================================================================
-- Environment unit implementation.
-- AHB Env unit derived from uvm_env
-- ==========================================================================
unit ahb_env like uvm_env {
       
  -- This field holds the logical name of this environment. This field must be
  -- constrained by the user in the config file.
  name         : ahb_env_name_t;

  has_master : bool;
  keep soft has_master == FALSE;

  has_slave  : bool;             
  keep soft has_slave  == FALSE;
   
  -- Used for selecting mode SIGNAL,ACCEL,TLM   
  abstraction_level : uvm_abstraction_level_t;    
  keep soft abstraction_level == UVM_SIGNAL; 

  -- By default, protocol checking and coverage collection are enabled.
  -- The following fields can be used to disable them: 
  has_checks   : bool;
  keep soft has_checks == TRUE;

  has_coverage : bool;
  keep soft has_coverage == TRUE;

  system_smp   : ahb_system_smp is instance;
  keep system_smp.env_name == name;
  keep system_smp.abstraction_level == read_only(abstraction_level) ;
    
  -- MASTER instance. By default, the master is constrained to be active,
  -- but you can override that in the config file.
  when has_master ahb_env {

    // MASTER Signal map
    master_smp   : ahb_master_smp is instance;
    keep master_smp.env_name == name;

    // MASTER Agent instance
    master : ahb_master_agent is instance;
    keep soft master.active_passive == ACTIVE;
    keep master.abstraction_level == read_only(abstraction_level) ;
    keep master.monitor.has_checks == has_checks;
    keep master.monitor.has_coverage == has_coverage;
    keep master.monitor.agent_kind == MASTER;
    
    -- This method is called after post_generate() to create unit
    -- references between sibling units.
    connect_pointers() is also {
      master.p_smp = master_smp;
      master.p_sys_smp = system_smp;
    };
  }; 

  -- SLAVE instance. By default, the slave is constrained to be active,
  -- but you can override that in the config file.
  when has_slave ahb_env {

    // SLAVE Signal map
    slave_smp   : ahb_slave_smp is instance;
    keep slave_smp.env_name == name;

    // SLAVE Agent instance
    slave  : ahb_slave_agent is instance;
    keep soft slave.active_passive == ACTIVE;
    keep slave.abstraction_level == read_only(abstraction_level) ;
    keep slave.monitor.has_checks == has_checks;
    keep slave.monitor.has_coverage == has_coverage;
    keep slave.monitor.agent_kind == SLAVE;
  
    -- This method is called after post_generate() to create unit
    -- references between sibling units.
    connect_pointers() is also {
      slave.p_smp = slave_smp;
      slave.p_sys_smp = system_smp;
    };
  }; 

  -- Report the final status at the end of the test.
  finalize() is also {
    message(LOW, "Test done:");
    show_status();
  }; 
  
  -- Print a banner for each UVC instance at the start of the test.
  show_banner() is also {
    out("Copyright  (c)2010");
    out("Env : ", name);
  };
}; 

'>
