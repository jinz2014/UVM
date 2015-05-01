/*-----------------------------------------------------------------
File name     : uart_sequence_lib.e
Title         : UART Sequence Lib
Project       :
Created       : Wed Feb 18 10:46:08 2004
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

// BASIC UART Sequence
extend uart_sequence_kind : [BASIC];
extend BASIC uart_sequence {

  num_of_frame : uint;
  keep soft num_of_frame == 10;

  body() @driver.clock is only {
    for i from 0 to num_of_frame - 1 do {
      do frame; 
    };
  };
};

-- Send Packet with Incremental Payload
extend uart_sequence_kind : [FIX_DATA];
extend FIX_DATA uart_sequence {

  cur_data : list of bit;
  keep soft cur_data.size () == read_only(driver.config.databit_type.as_a(uint));

  num_of_frame : byte;
  keep soft num_of_frame in [5..10];

  body() @driver.clock is {

    for i from 0 to num_of_frame-1 {
      do frame keeping { 
        it.payload == cur_data;
      };
    };
  };
};


extend uart_sequence_kind : [NO_IDLE];
extend NO_IDLE uart_sequence {

  num_of_frms : byte;
  keep soft num_of_frms in [10..20];

  body() @driver.clock is {

    for i from 0 to num_of_frms-1 { 
      do frame keeping { 
        it.delay_to_next_frame == 0;
      }; 
    };
  };
};

extend uart_sequence_kind : [LEGAL_SHORT_IDLE];
extend LEGAL_SHORT_IDLE uart_sequence {

  num_of_frms : byte;
  keep soft num_of_frms in [10..20];

  !total_delay: uint;

  body() @driver.clock is {

    for i from 0 to num_of_frms-1 { 
      do frame keeping { 
        it.legal_frame == TRUE;
	it.delay_to_next_frame < 10; 
      }; 
    };
    total_delay += frame.delay_to_next_frame;
  };
};

extend MAIN uart_rx_sequence {
  keep soft count  == MAX_INT;
};
 
'>
