---------------------------------------------------------------
File name   : ahb_slave_agent.e
Developers  : vishwana
Created     : Tue Mar 30 14:29:27 2010
Description : This file implements the slave agent
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

--========================================================================
-- The slave agent derived from uvm_agent
--========================================================================
unit ahb_slave_agent like uvm_agent {
    
  -- ----------------------------------------------------------------------
  -- Use this section to add slave fields, events and methods.
  -- ----------------------------------------------------------------------
    
  -- Reference to the env signal map
  !p_smp         : ahb_smp;

  -- Reference to the system signal map
  !p_sys_smp     : ahb_system_smp;
  
  -- Used for selecting mode SIGNAL,ACCEL,TLM   
  abstraction_level : uvm_abstraction_level_t;    
  
  -- This instance of the agent monitor
  monitor        : SLAVE'agent_kind ahb_agent_monitor is instance;
  keep monitor.abstraction_level == read_only(abstraction_level) ;
   
  -- This event gets emitted when reset is asserted.
  event clk is @p_sys_smp.clk;
  
  connect_pointers() is also {
    monitor.p_smp = p_smp;
    monitor.p_sys_smp = p_sys_smp;
  };
  
  -- When a slave agent is ACTIVE, it also drives
  -- responses (PASSIVE slave only monitors
  -- the activity).  
  when ACTIVE ahb_slave_agent {
  
    -- This is the sequence driver for an active
    -- slave agent.
    driver: ahb_slave_driver_u is instance;
    
    -- BFM for an active slave agent
    bfm : ahb_slave_bfm is instance;
    keep bfm.abstraction_level == read_only(abstraction_level) ;
    
    connect_pointers() is also {
      bfm.p_driver = driver;
      bfm.p_smp = p_smp;
      bfm.p_sys_smp = p_sys_smp;
    }; 
   
    -- Emit the driver clock
    on clk {
      emit driver.clock;
    };
  };
};

'>
