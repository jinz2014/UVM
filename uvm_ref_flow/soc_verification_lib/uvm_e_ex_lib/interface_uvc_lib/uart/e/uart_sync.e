/*-----------------------------------------------------------------
File name     : uart_sync.e
Title         : eRM package for UART verification, cDMA group
Project       :
Created       : Wed Feb 18 10:46:07 2004
Description   : 
Notes         : 
-------------------------------------------------------------------*/
//  Copyright 1999-2010 Cadence Design Systems, Inc.
//  All Rights Reserved Worldwide
//
//  Licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in
//  compliance with the License.  You may obtain a copy of
//  the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in
//  writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//  CONDITIONS OF ANY KIND, either express or implied.  See
//  the License for the specific language governing
//  permissions and limitations under the License.
//----------------------------------------------------------------------

<'

package uart;

unit uart_sync {

  // The name of the clock signal
  sig_uart_HCLK: string;
  
  // The name of the reset signal
  sig_uart_HRESET: string;
  
  // The name of the clock buad signal
  sig_uart_BUAD_CLK: string;

  // Port connections to the actual signals
  sig_hclk_port:     in simple_port of bit is instance;
  keep soft sig_hclk_port.hdl_path() == sig_uart_HCLK;
  keep bind(sig_hclk_port, external);

  sig_hreset_port:   in simple_port of bit is instance;
  keep soft sig_hreset_port.hdl_path() == sig_uart_HRESET;
  keep bind(sig_hreset_port, external);

  sig_baud_clk_port: in simple_port of bit is instance;
  keep soft sig_baud_clk_port.hdl_path() == sig_uart_BUAD_CLK;
  keep bind(sig_baud_clk_port, external);

  // The change clock (not considering the reset)
  event hclk_not_qualified is change(sig_hclk_port$) @sim;
  
  event hclk_r_not_qualified is true(sig_hclk_port$ == 1) @hclk_not_qualified;

  // the rise edges of the buad qulified clock for the tx bfm
  event  clk_buad_r is true( sig_baud_clk_port$ == 1) @hclk;
  
  // The qualified clock
  event hclk is true(sig_hreset_port$ == 1)@hclk_not_qualified;

  // The rising edges of the qualified clock
  event clk_r is true(sig_hclk_port$ == 1) @hclk;
     
  // (NC) Indicates whether this is the first clock after reset 
  first_clk_reset: bool;
  keep first_clk_reset;
  
  // Beginning of reset (fall of the HRESET signal)
  event reset_started is (fall(sig_hreset_port$))  
    or 
    true( ((sig_hreset_port$ == 0) and first_clk_reset)
  )@hclk_not_qualified;
  
  reset_occured: bool;
  keep not reset_occured;

  reset_completed: bool;
  keep not reset_completed;
   
  // Ending of the reset (rise of the HRESET signal)
  event reset_ended is (rise(sig_hreset_port$)) and true(reset_occured) @hclk_r_not_qualified;
   
  on reset_ended {
    reset_completed = TRUE;
  }; 

  on reset_started {
    first_clk_reset = FALSE;
    reset_occured = TRUE;
  };
   
  on reset_ended {
    reset_occured = FALSE;
  }; 

  // The length of a cycle
  package !cycle_length: uint;
  
  get_clock_cycle_length() @hclk_not_qualified is {
    var t: time = sys.time;
    wait [2] * cycle;
    cycle_length = sys.time - t;
  };
  
  
  init() is also {
    cycle_length = 0;
  };

  #ifdef DEBUG {
    event clk_r is only @sys.any;
      
    reset()@clk_r is {
      wait [30];
      emit reset_ended;
      message(NONE, "\n\ndebug mode reset ended ");
    };
  
    run() is also {
      start reset();
    };
  };
  
  run() is also {
    start get_clock_cycle_length();
  }; 

}; 

'>
