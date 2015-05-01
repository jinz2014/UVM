/*-------------------------------------------------------------------------
File name   : uart_ctrl_scoreboard.e
Title       : Uart-APB Scoreboard 
Project     : Module UART
Developers  : 
Created     :
Description : Defining UART-APB scoreboard, based on the UVM Scoreboard.
            :
            : Four ports, for checking both directions:
            :
            :  - Comparing UART frames sent to the DUT, to APB transfers 
            :    transmited by the DUT.
            :  - Comparing APB transfers sent to the DUT, to UART frames 
            :    transmited by the DUT.
Notes       : 
            :
-------------------------------------------------------------------------*/
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
// ----------------------------------------------------------------------

<'

package uart_ctrl_pkg;

// UART Module Level Scorebaord Derived from uvm_scoreboard
unit uart_ctrl_scoreboard like uvm_scoreboard {
   
  // ----------------------------------------------------- 
  // Declaration of the scoreboard ports : 
  // Declare add and match TLM analysis interface ports for
  // scoreboard communication with the VE
  // ----------------------------------------------------- 

  // ports related to uart frame - to - apb transfer 
  scbd_port uart_frame_add  : add uart_frame_s;
  scbd_port apb_trans_match : match apb_trans_s;
  
  // ports related to apb transfer - to - uart frame
  scbd_port apb_trans_add    : add apb_trans_s;
  scbd_port uart_frame_match : match uart_frame_s;

  // Name printed in messages
  keep name == "UART_CTRL_UVM_SCOREBOARD";
      
  base_addr : uint(bits : 32);
  keep soft base_addr == 0;

  data_len : uint;
  keep soft data_len == 8;

  // No Ordering rules between the ports
  keep global_ooo_depth == UNDEF;

  // Intended for in_order behaviour of the items
  keep match_port_ooo_depth == 1;

  keep ooo_exclude_matches_and_drops == TRUE;

  // This field sets the number of matched and dropped items that are
  // kept in the scoreboard(Default value is 10)
  keep history_limit == 100;

  st : bool;
  keep st == TRUE;

  checked_items : uint; 
  keep soft checked_items == 0;
 
  // Adding the UART frame into the scoreboard 
  uart_frame_add_predict(item : uart_frame_s) is only {
    add_to_scbd(item);
    set_match_port(item, apb_trans_match);
    message(LOW,"Adding the UART Frame into the scoreboard ") {
      print item using hex;
    };
  };
 
  // Adding the APB-Frame into the scoreboard if APB Write transfer is meant
  // for UART-TX FIFO
  apb_trans_add_predict(item : apb_trans_s) is only {

    if((item.addr == base_addr + UART_TX_FIFO + 3) && (item.data[31:31] == 1)) {
      st = FALSE;
    } else if((item.addr == base_addr + UART_TX_FIFO + 3) && (item.data[31:31] == 0)){
      st = TRUE;
    };

    if(item.addr == base_addr + UART_TX_FIFO and
      item.direction == WRITE) {
        if(st) {
          add_to_scbd(item);
          set_match_port(item, uart_frame_match);
          message(LOW,"Adding the APB Frame into the scoreboard ") {
            print item using hex;
          };
	};
      };
    }; // apb_trans_add_predict()
    
    
    // Find a match only for APB READ transfers meant for UART_RX_FIFO
    apb_trans_match_reconstruct( item : apb_trans_s) is only {
      if(item.addr == base_addr + UART_RX_FIFO and
        item.direction == READ) {
        match_in_scbd(item);
        message(LOW,"Looking for APB Frame match into the scoreboard ") {
          print item using hex;
        };
      };
    };
   
    // Find a match for UART Frame
    uart_frame_match_reconstruct( item : uart_frame_s) is first {;
      message(LOW,"Looking for UART Frame match into the scoreboard ") {
        print item using hex;
      };
    };  

    // ------------------------------------------------------------------------------ 
    // This hook method returns a key for a given item. 
    // Default operation is crc_32 over the physical fields of the received struct. 
    // This method should be extended in cases where some of the fields need to be added
    // or omitted. We need to compare only the data fields
    // ------------------------------------------------------------------------------ 
    compute_key(item : any_struct ): uint is only {
        
      var data_list: list of bit;
              
      if item is a apb_trans_s then {
        data_list = pack(NULL, item.as_a(apb_trans_s).data);
      };

      if item is a uart_frame_s then {
        data_list =  pack(NULL, item.as_a(uart_frame_s).payload);
      };

      // compared list - size of data_len, rest of the bits are don't-care
      data_list.resize(data_len, TRUE, 0, TRUE);

      // pad to length of 8, so can compute crc
      data_list.resize(8, TRUE, 0, TRUE);

      return data_list.crc_32(0, 1);
    }; // compute_key()


    match_found(add_item: any_struct,add_port: any_port,match_item: any_struct,match_port:any_port) is also {
      checked_items = checked_items + 1;
    };

    check() is also {
      message(LOW,"UART_CTRL_SCBD : NO OF PACKETS CHECKED  = ",checked_items);
    }; -- check()

}; // unit uart_ctrl_scoreboard  

'>
