---------------------------------------------------------------
File name   : gpio_agent.e
Created     : Tue Jun 17 13:52:03 2008
Description : This file implements the Interface agent
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

package gpio;

// GPIO Interface Agent derived from uvm_agent
unit gpio_agent like uvm_agent {
   
  // This field determines whether an agent is active or passive.
  keep soft active_passive == ACTIVE;
    
  // Reference to the env signal map
  !p_smp         : gpio_smp;
    
  // This instance of the agent monitor
  monitor : gpio_monitor is instance;
    
  // This event gets emitted when reset is asserted.
  event clk is @p_smp.clk;
    
  connect_pointers() is also {
    monitor.p_smp = p_smp;
  };
    
  // When a Interface agent is ACTIVE, it also drives transfers.
  // (PASSIVE Interface only monitors the activity).
  when ACTIVE gpio_agent {
        
    // This is the sequence driver for an active Interface agent.
    sequencer: gpio_sequencer_u is instance;
        
    // BFM for an active Interface agent
    bfm : gpio_bfm is instance;
        
    connect_pointers() is also {
      bfm.p_sequencer = sequencer;
      bfm.p_smp = p_smp;
    };
        
    -- Emit the sequencer clock
    on clk {
      emit sequencer.clock;
    };

  };
    
  // This field is set if reset has been asserted during a test. It is used
  // to ensure that the objection to TEST_DONE that is raised at the start
  // of such a reset is dropped when reset is de-asserted.
  !reset_during_test : bool;

  run() is also {
    reset_during_test = FALSE;
  };

  // This event gets emitted when reset is asserted.
  event reset_start is @p_smp.reset_start;
  
  // This event gets emitted when reset is de-asserted.
  event reset_end is @p_smp.reset_end;
  
  on reset_start {
    reset_start();
  };
  
  on reset_end {
    reset_end();
  };
  
  // When reset is asserted, raise an objection to TEST_DONE so that the
  // test continues even once all sequence drivers have been quit. The
  // 'reset_during_test' flag is also set so that we know when reset
  // is de-asserted that the objection needs to be dropped.
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
