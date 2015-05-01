---------------------------------------------------------------
File name   :  ahb_system_smp.e
Title       :  System Signal Map unit
Project     :  ahb UVC
Developers  :  efrat
Created     :  Sun Jan 31 16:20:27 2010
Description :  This file implements the system signal map of the UVC.
Notes       :  The system smp is a unit that contains external ports
            :  for HW signals that are common to the whole design, and related
            :  events.
            :  Typically, this includes clock and reset signals and events.
            :  The bus monitor unit and all agent units have references to
            :  those events, this makes the units independent.
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
-- Synchronizer unit for the environment. Contains the clock and other
-- synchronizing events. Enables agents instantiation independent of env
-- AHB System Signal Map unit is like inherited from uvm_signal_map
-- =========================================================================
unit ahb_system_smp like uvm_signal_map {
    
  -- This field is the logical name of the env associated with this
  -- synchronizer. This field is automatically constrained by the UVC. Do
  -- constrain it manually.
  env_name   : ahb_env_name_t;
  
  abstraction_level : uvm_abstraction_level_t;
  keep soft abstraction_level == UVM_SIGNAL;
  
  -- Global Signals
  clk   : inout simple_port of bit is instance;
  keep bind(clk,empty);
  
  reset      : inout simple_port of bit is instance;
  keep bind(reset,empty);
  
  -- This field is used to keep track of the current reset state.
  -- By default, reset is assumed to be asserted at the start of the test.
  -- The user should not normally need to constrain this field.
  !reset_asserted : bool;
  
  -- Current cycle number 
  current_cycle   : uint;
  keep current_cycle == 0;

  -- This field is used to constraint the UVCs reset polarity
  is_active_high : bool;
  keep soft is_active_high == FALSE;

  -- This field keeps track if the reset already happened, used for clock
  post_reset : bool;
  keep post_reset == FALSE;
  
  -- This event gets emitted each time the reset signal changes state. Note
  -- that, depending on how reset is generated, it is possible that this
  -- event will be emitted at time zero.
  event reset_change is change(reset$) @sim;
  
  -- This event gets emitted when reset is asserted.
  event reset_start;
  
  -- This event gets emitted when reset is de-asserted.
  event reset_end;
  
  on reset_change {
    if reset$ == is_active_high.as_a(bit) {
      reset_asserted = TRUE;
      emit reset_start;
    } else {
      reset_asserted = FALSE;
      post_reset = TRUE;
      emit reset_end;
    };
  };
  
  -- This event is the rising edge of the clock, unqualified by reset.
  event unqualified_clk is rise(clk$) @sim;
  
  -- This event is the rising edge of the clock, qualified by reset.
  event clk;
  on unqualified_clk {
    current_cycle += 1;
    if (post_reset) {
      emit clk;
    };
  };
  
  post_generate() is also {
    reset_asserted = is_active_high.as_a(bit) == reset$;
  };
   
};

'>
