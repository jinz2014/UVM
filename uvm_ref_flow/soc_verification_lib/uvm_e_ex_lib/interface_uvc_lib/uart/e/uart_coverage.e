/*-----------------------------------------------------------------
File name     : uart_coverage.e
Title         : UART Coverage
Project       :
Created       : Wed Feb 18 10:46:07 2004
Description   : 
Notes         : Per Instance Cover Group
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

// Coverage Groups included inside the UART monitor code
extend uart_monitor_u {

  // Cover group (Per Instance)
  cover mon_frame_done using per_unit_instance is {
         
    // Protocol options
    item parity_type:uart_frame_parity_t=current_frame.parity_type; 
    item stopbit_type:uart_frame_stopbit_t=current_frame.stopbit_type;
    item databit_type:uart_frame_databit_t=current_frame.databit_type;
    item with_parity:bool=current_frame.with_parity;

    // Inter-frame delay
    item delay_to_next_frame: uint(bits :8)=current_frame.delay_to_next_frame  using
      ranges = {range ([0 .. 255],"",16) },at_least = 10; 

    // Error-conditions
    item legal_frame:bool=current_frame.legal_frame;
    item has_startbit_err:bool=current_frame.has_startbit_err;
    item has_parity_err:bool=current_frame.has_parity_err using 
      when=(current_frame.with_parity == TRUE);

    item has_stopbit_err:bool=current_frame.has_stopbit_err; 

    // Data-content
    item payload_lsb: bit = current_frame.payload[0];
    item payload_msb: bit = current_frame.payload[current_frame.p_len-1];

    // Combinations of key attributes
    cross payload_msb, payload_lsb;
    cross databit_type, stopbit_type, parity_type;
    cross parity_type, has_parity_err;

  };
};

'>
