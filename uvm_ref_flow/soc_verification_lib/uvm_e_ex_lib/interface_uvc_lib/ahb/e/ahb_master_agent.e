---------------------------------------------------------------
File name   : ahb_master_agent.e
Developers  : vishwana
Created     : Tue Mar 30 14:29:27 2010
Description : This file implements the master agent
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

--=================================================================
-- The master agent derived from uvm_agent
--=================================================================
unit ahb_master_agent like uvm_agent {
   
  -- ----------------------------------------------------------------------
  -- Use this section to add master fields, events,
  -- and methods.
  -- **********************************************************************
    
  -- Reference to the env signal map
  !p_smp  : ahb_smp;

  -- Reference to system signal map
  !p_sys_smp         : ahb_system_smp;
   
  -- Used for selecting mode SIGNAL,ACCEL,TLM   
  abstraction_level : uvm_abstraction_level_t;    
    
  -- This instance of the agent monitor
  monitor : MASTER'agent_kind ahb_agent_monitor is instance;
  keep monitor.abstraction_level == read_only(abstraction_level) ;
    
  -- This event gets emitted when reset is asserted.
  event clk is @p_sys_smp.clk;
    
  connect_pointers() is also {
    monitor.p_smp = p_smp;
    monitor.p_sys_smp = p_sys_smp;
  };
    
  -- When a master agent is ACTIVE, it also drives transfers.
  -- (PASSIVE master only monitors the activity).
  when ACTIVE ahb_master_agent {
        
    -- This is the sequence driver for an
    -- active master agent.
    driver: ahb_master_seq_driver is instance;
    
    -- BFM for an active master agent
    bfm : ahb_master_bfm is instance;
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
    
  -- This field is set if reset has been asserted during a test. It is used
  -- to ensure that the objection to TEST_DONE that is raised at the start
  -- of such a reset is dropped when reset is de-asserted.
  !reset_during_test : bool;

  run() is also {
    reset_during_test = FALSE;
  };

  -- This event gets emitted when reset is asserted.
  event reset_start is @p_sys_smp.reset_start;
  
  -- This event gets emitted when reset is de-asserted.
  event reset_end is @p_sys_smp.reset_end;
  
  on reset_start {
    reset_start();
  };
  
  on reset_end {
    reset_end();
  };
    
  -- When reset is asserted, raise an objection to TEST_DONE so that the
  -- test continues even when all sequence drivers have quit. The
  -- 'reset_during_test' flag is also set so that we know that, when reset
  -- is de-asserted, the objection needs to be dropped.

  reset_start() is {
    reset_during_test = TRUE;
    raise_objection(TEST_DONE);
  };

  reset_end() is {
    if reset_during_test {
      reset_during_test = FALSE;
      drop_objection(TEST_DONE);
    };
  };
};

'>
