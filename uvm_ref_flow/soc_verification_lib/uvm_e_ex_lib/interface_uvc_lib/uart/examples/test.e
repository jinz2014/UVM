/*-----------------------------------------------------------------
File name     : test.e
Title         : uart test
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

import uart_e_config;


// DUT traffic
extend DUT MAIN uart_sequence {

  !simple_seq: SIMPLE uart_sequence;

  body() @driver.clock is only {
    while (TRUE) {
      do simple_seq;
    }; // while (TRUE)
  }; // body() @driver....
   
}; // extend DUT MAIN...


// Verification environment traffic
extend VE MAIN uart_sequence {

  !short_legal_seq: LEGAL_SHORT_IDLE uart_sequence;

  body() @driver.clock is only {
    message(NONE, "Test: Doing a LEGAL_SHORT_IDLE sequence...");
    do short_legal_seq keeping {
      it.num_of_frms in [2..5];
    };

    message(NONE, "Test: Stopping the test...");
    
    wait [1];  // allows RX monitors to flush last frame
    stop_run();
  }; // body() @driver....
   
}; // extend VE MAIN ...



'>

