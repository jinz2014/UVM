/*-----------------------------------------------------------------
File name     : uart_frame_check.e
Title         : UART Frame Struct
Project       :
Created       : Wed Feb 18 10:46:07 2004
Description   : For the monitor and check we need more informaton 
                to analysis the frame recieved
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

extend uart_frame_s {

  // with check we get info about the frame
  !frame_status : list of uart_status_t;

  parity_ok() : bool is {
    if with_parity {
      if me is a with_parity uart_frame_s (pa) {
        case parity_type {
          SPACE     : { result = (pa.parity == 0); };
          [ODD,EVEN]: { result = (pa.parity == calc_parity(payload,parity_type)); };
      	}; // case
      };
    } else {
      message(HIGH, "\nThe config set to no parity frames ");
    };
  };

  stopbit_ok() : bool is {
    for each (st) in stop_bit {
      if st != 1 {
        return FALSE;
      };
    };
    result = TRUE;
  }; // stopbit_ok()

   
  pack_frame() : list of bit is {
    result = pack(packing.low, me);
  }; // pack_frame()

  get_payload() : uint is {
    unpack(packing.low,payload,result);
  }; // unpack_payload

  unpack_check_frame(bitstream : list of bit, check_protocol : bool) is {

    // Assume that this frame is going to be legal until we discover

    if check_protocol {

      check that start_bit == 0
        else dut_error("Frame start bit is not 0");

      if  with_parity {
        check that parity_ok()
      	  else dut_error("Frame has bad parity");
      };

      check that stopbit_ok()
        else dut_error("Frame stop bit is not correct");
    };

    // If the start bit is illegal, then reflect this in the status field
    if start_bit != 0 {
      frame_status.add(BAD_START);
      has_startbit_err = TRUE; 
    };

    // If the parity is bad then reflect this in the status field.
    if with_parity and not parity_ok() {
      frame_status.add(BAD_PARITY);
      has_parity_err = TRUE;
    };

    // If the stop bit is illegal, then reflect this in the status field
    if not stopbit_ok() {
      frame_status.add(BAD_STOP);
      has_stopbit_err = TRUE;
    };

    if frame_status.size() == 0 {
      frame_status.add(NO_ERROR);
      legal_frame = TRUE;
    } else { 
      legal_frame = FALSE;
    };

  }; // unpack_check_frame()..

}; 


'>
