/*-----------------------------------------------------------------
File name     : uart_frame.e
Title         : UART Frame declaration
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

// UART Frame declaration
struct uart_frame_s like any_sequence_item {

  // These fields determine the composition of the frame based on
  // protocol options
  parity_type  : uart_frame_parity_t;  // Controls type of parity
  stopbit_type : uart_frame_stopbit_t; // Controls number of stop-bits
  databit_type : uart_frame_databit_t; // Controls number of data-bits

  with_parity:bool;  // Whether or not any parity data is sent 
  keep soft with_parity == TRUE;
  keep parity_type == NONE => with_parity == FALSE;
   
  // Size of data-payload 
  p_len: uint(bits:4);
  keep soft p_len == read_only(databit_type.as_a(uint));
   
  // How many stop-bits to send
  st_len: uint(bits:2); 
  keep soft st_len == read_only(stopbit_type.as_a(uint));

  delay_to_next_frame: uint(bits:8);  // Inter-frame delay

  // High-level "Knob Fields"

  // Control whether frame will be legal
  legal_frame : bool;

  // Inject a StartBit Error
  has_startbit_err : bool;
   	
  // Inject a Parity Error
  has_parity_err   : bool;
  keep not with_parity => has_parity_err == FALSE;

  // Inject a StopBit Error
  has_stopbit_err  : bool;
  keep has_stopbit_err == FALSE;
   
  // Constraints to allow test-writer to control error-injection
  keep read_only(legal_frame) => !has_startbit_err and !has_parity_err and !has_stopbit_err;
  keep has_startbit_err or has_parity_err  or has_stopbit_err => !read_only(legal_frame);
   

  // Now define the frame content based on high-level control fields

  // This field is the physical start bit of the frame and is always 0 in legal frames.
  %start_bit : bit;
  keep soft start_bit == 0;
  keep has_startbit_err => soft start_bit == 1;

  // Payload
  %payload[p_len] : list of bit;  // Variable-length data-payload
 
  when with_parity uart_frame_s {
    %parity       : bit;  // Conditional parity field
    keep soft parity == calc_parity(payload,parity_type);
    keep read_only(has_parity_err) => parity != calc_parity(payload,parity_type);
  }; 
   
  %stop_bit[st_len]: list of bit; // Variable-length stop-bits
  keep for each in stop_bit {
    not read_only(has_stopbit_err)  => it == 1;
    read_only(has_stopbit_err) and read_only(st_len) == 2 and stop_bit[0] == 1 => soft it == 0;
    read_only(has_stopbit_err) and read_only(st_len) == 2 and stop_bit[0] == 0 => soft it in [0,1];
  };

  // This method returns the correct parity of a payload.
  calc_parity(payload: list of bit ,parity_type :uart_frame_parity_t) : bit is {

    var parity : bit = 0;
    for each (p) in payload {
      parity ^= p;
    };

    case parity_type {
      EVEN  { result =  parity; };
      ODD   { result = ~parity; };
      SPACE { result = 0; };
    };
  }; 


  // adding logic to do_unpack to set the payload list size
  do_unpack(options:pack_options, l: list of bit, begin: int):int is first {
    p_len = databit_type.as_a(uint);
    payload.resize(p_len);
    
    st_len = stopbit_type.as_a(uint);
    stop_bit.resize(st_len);
  }; // do_unpack(optio...

}; // struct uart_frame_s..


'>
