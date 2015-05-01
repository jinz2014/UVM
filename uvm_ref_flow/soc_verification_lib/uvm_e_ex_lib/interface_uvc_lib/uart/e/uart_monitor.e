/*-----------------------------------------------------------------
File name     : uart_monitor.e
Title         : UART Monitor
Project       :
Created       : Wed Feb 18 10:46:08 2004
Description   : extend of the general method 
Notes         : // Vardit 26 Feb 04 - debug the monitor fsm - change the RECIVING  
                // check agenst  bit_size() -1 then add the data and check info
                // Vardit 6  JUN 04 - customer debug and add break phase signal     
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

// extend the monitor unit 
extend  uart_monitor_u  {

  // data bit collected from the data sig	
  data_b : bit;
  keep soft data_b == 1;

  // the number of time a 0 value should collect to be sertain the value is not 1
  threshold : uint(bits:4);
  keep soft threshold == 13;

  // data phase between idles
  valid_data_phase : bool;
  keep soft valid_data_phase == FALSE;

  // init cycles
  init_cycles : uint;
  keep soft init_cycles in [ 5..15 ];

  // data is rx or tx
  data_is_rx : bool;
      
  break_phase:bool; // cust correction
  
  // Reset the internal variables
  reset_vars() is {
    valid_data_phase = FALSE;
    mon_state = IDLE;
    current_frame = NULL;
    break_phase = TRUE; // cust correction
  }; 

  // TLM Port for sending the collected data
  frame_ended : out interface_port of tlm_analysis of uart_frame_s is instance;
  keep bind(frame_ended, empty); 


  // State machine to follow the protocol activity  
  monitor_fsm() @mon_clk is {
    var bit_stream : list of bit;
    mon_state = IDLE;
    while TRUE {
      case mon_state {
        IDLE {
          if data_b == 0 then {
            bit_stream.clear();
            bit_stream.add(data_b);
       	    emit mon_frame_started;
            mon_state = RECEIVING;
            break_phase = FALSE; // cust correct
       	  } else {  
       	    break_phase = TRUE;  // cust correct
       	  };
        };
  
        RECEIVING {
          if bit_stream.size() == bit_size() -1 then {
            bit_stream.add(data_b); 
            check_receive_data(bit_stream);
            emit mon_receive_done;
            valid_data_phase = FALSE;
            mon_state = IDLE;
          } else {
            bit_stream.add(data_b);
            mon_state = RECEIVING;
          };
        };
      }; // case
      wait cycle;
    }; // while TRUE..
  }; // monitor_fsm()..
   
  // Determine size of frame
  bit_size() : uint is {

    result = 1; -- for start bit
    if config.parity_type != NONE then {
      result += 1;
    };

    case config.databit_type {
      FIVE  { result += 5; };
      SIX   { result += 6; };
      SEVEN { result += 7; };
      EIGHT { result += 8; };
    }; // case..

    if config.stopbit_type == TWO then {
      result += 2;
    } else {
      result += 1;
    };
  }; // bit_size()..

  // Convert bits from DUT signals into a transaction
  check_receive_data(bs:list of bit) is {

    var msg : string;
    current_frame  = new with  {
      it.parity_type  = config.parity_type;
      it.stopbit_type = config.stopbit_type;
      it.databit_type = config.databit_type;
      it.legal_frame  = TRUE;
    };
    unpack(packing.low,bs,current_frame);
    current_frame.unpack_check_frame(bs,do_check);
    if current_frame.frame_status.size() == 0 then {
      msg = " without error";
    } else {
      msg = "with error:";
      for each in current_frame.frame_status {
        msg = appendf("%s %s",msg,it.as_a(string));
      };
    };
    emit mon_frame_ended;
    message(MEDIUM,"Received data : ",hex(current_frame.get_payload())," ",msg,"\n");
    message(FULL,"Received frame : ",current_frame,"\n");
  }; // check_receive_data()..

}; // extend  uart_monitor_u..

'>

