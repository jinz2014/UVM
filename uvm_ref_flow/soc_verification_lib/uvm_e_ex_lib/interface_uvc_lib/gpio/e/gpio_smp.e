-----------------------------------------------------------------
File name     : gpio_smp.e
Created       : Tue Jun 17 13:52:04 2008
Description   : This file declares the signal map of the UVC.
Notes         : The signal map is a unit that contains external ports
              : for each of the HW signals that each agent must access 
              : as it interacts with the DUT.
-------------------------------------------------------------------
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
-------------------------------------------------------------------
 
<'
package gpio;

// GPIO Signal Map unit derived from uvm_signal_map
unit gpio_smp like uvm_signal_map {
  
  // Environment name
  env_name : gpio_env_name_t;
  
  // -------------------------------------------------------------------------
  // Adjust the signal names, and add any necessary signals.
  // Note that if you change a signal name, you must change it in all of your
  // UVC files.
  // -------------------------------------------------------------------------
      
  -- Signals
  sig_clk : in simple_port of bit is instance;
  keep bind (sig_clk,external);

  sig_reset : in simple_port of bit is instance;
  keep bind (sig_reset,external);

  sig_data_in : in simple_port of gpio_data_t is instance;
  keep bind (sig_data_in,external);

  sig_data_out : inout simple_port of gpio_data_t is instance;
  keep bind (sig_data_out,external);

  sig_data_oe  : in simple_port of gpio_data_t is instance;
  keep bind (sig_data_oe,external);
    
  // This field is used to keep track of the current reset state
  // default reset is assumed to be asserted at the start of the test.
  // The user should not normally need to constrain this field.
  !reset_asserted : bool;
    
  // This event gets emitted each time the reset signal changes state. Note
  // that, depending on how reset is generated, it is possible that this
  // event will be emitted at time zero.
  event reset_change is change(sig_reset$) @sim;
    
  // This event gets emitted when reset is asserted.
  event reset_start;
    
  // This event gets emitted when reset is de-asserted.
  event reset_end;
    
  // This event is the rising edge of the clock, unqualified by reset.
  event unqualified_clk is rise(sig_clk$) @sim;
    
  // This event is the rising edge of the clock, qualified by reset.
  event clk;
    
  on reset_change {
    if sig_reset$ == 0 {
      reset_asserted = TRUE; 
      emit reset_start;
    } else {
      if reset_asserted {
        emit reset_end;
      };
      reset_asserted = FALSE;
    };
  };
       
  on unqualified_clk {
    if (not reset_asserted) {
      emit clk;
    };
  };
};


'>
