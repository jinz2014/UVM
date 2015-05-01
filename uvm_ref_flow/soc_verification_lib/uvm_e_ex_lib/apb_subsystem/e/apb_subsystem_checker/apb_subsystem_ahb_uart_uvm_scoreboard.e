/*-------------------------------------------------------------------------
File name   : apb_subsystem_ahb_uart_uvm_scoreboard.e
Title       : Scoreboard for AHB-UART interface in APB subsystem
Project     :
Created     : November 2010
Description : Data scoreboard for checking data in AHB-UART interface
              
	      DUV transmits traffic when Tx FIFO is populated via AHB
	      writes by Master

	      Consideration:

	       - parity yes/no
	       - number of stop bits
	       - data length 6,7,8   - need to mask unused bits in compare
              
Notes       : The scoreboard is implemented using uvm scoreboard package
-------------------------------------------------------------------------*/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

<'

package apb_subsystem_pkg;

// AHB-UART Interface Scoreboard unit derived from uvm_scoreboard
unit apb_subsystem_ahb_uart_uvm_scoreboard_u like uvm_scoreboard {

  // -----------------------------------------------------
  // Declaration of the scoreboard ports :
  // Declare add and match TLM analysis interface ports for
  // scoreboard communication with the VE
  // -----------------------------------------------------

  // ports related to ahb frame - to - uart transfer
  scbd_port ahb_trans_add    : add ahb_env_monitor_transfer;
  scbd_port uart_frame_match : match uart_frame_s;

  // ports related to uart transfer - to - ahb frame
  scbd_port uart_frame_add   : add uart_frame_s;
  scbd_port ahb_trans_match  : match ahb_env_monitor_transfer;

  // Name printed in messages
  keep name == "UART_AHB_UART_UVM_SCOREBOARD";

  // Base Address
  base_addr : uint(bits : 32);
  keep soft base_addr == 0;

  // UART TX-FIFO Register Address
  uart_tx_fifo_addr : uint;
  keep soft uart_tx_fifo_addr == base_addr + UART_FIFO_REG;

  // UART RX-FIFO Register Address
  uart_rx_fifo_addr : uint;
  keep soft uart_rx_fifo_addr == base_addr + UART_FIFO_REG;

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

  // Number of Packet Checked
  checked_items : uint; 
  keep soft checked_items == 0;

  // ----------------------------------------------------------------------
  // This method should be called to add an AHB transfer to the scoreboard.
  // If the AHB Write is meant for UART-TX FIFO , and transfer kind is a 
  // non IDLE transaction , then only add into the scoreboard
  // ----------------------------------------------------------------------
  ahb_trans_add_predict(item : ahb_env_monitor_transfer) is only {

    if((item.kind != IDLE) && (item.address == uart_tx_fifo_addr + 3) && 
      (item.data[31:31] == 1)) {
      st = FALSE;
    } else if((item.kind != IDLE) && (item.address == uart_tx_fifo_addr + 3) && 
      (item.data[31:31] == 0)) {
      st = TRUE;
    };

    if ((item.kind != IDLE) && (item.address == uart_tx_fifo_addr) && st) {
      item.data[31:8] = 0; // Need only data[7:0]
      add_to_scbd(item);        
      set_match_port(item,uart_frame_match);
      message(LOW,"Added the AHB frame into the Scoreboard ") {
        print item using hex;
      };
    };

  }; // ahb_trans_add_predict()..

  // Add the UART Frame into the Scoreboard 
  uart_frame_add_predict(item : uart_frame_s) is only {
    add_to_scbd(item);
    set_match_port(item, ahb_trans_match);
    message(LOW,"Added the UART frame into the Scoreboard ") {
      print item using hex;
    };
  };

  // UART Frame Match method
  uart_frame_match_reconstruct( item : uart_frame_s) is only {
    match_in_scbd(item);
    message(LOW,"Looking for UART frame match into the Scoreboard ") {
      print item using hex;
    };
  };

  // This method should be called for an AHB match when an AHB Read is 
  // meant for UART-RX FIFO
  ahb_trans_match_reconstruct( item : ahb_env_monitor_transfer) is only {
    if(item.direction == READ and item.kind != IDLE and 
      item.address == uart_rx_fifo_addr) then {
      match_in_scbd(item);
      message(LOW,"Looking for AHB frame match into the Scoreboard ") {
        print item using hex;
      };
    };
  };

  // ---------------------------------------------------------------------------------
  // This hook method returns a key for a given item. 
  // Default operation is crc_32 over the physical fields of the received struct. 
  // This method should be extended in cases where some of the fields need to be added
  // or omitted. In our case , we need to compare only the data field
  // ---------------------------------------------------------------------------------
  compute_key(item : any_struct ): uint is only {

    var data_list: list of bit;

    if item is a ahb_env_monitor_transfer then {
      data_list = pack(NULL, item.as_a(ahb_env_monitor_transfer).data);
    };

    if item is a uart_frame_s then {
      data_list =  pack(NULL, item.as_a(uart_frame_s).payload);
    };

    // Pad to length of 8 for CRC computation
    data_list.resize(8, TRUE, 0, TRUE);
    return data_list.crc_32(0,data_list.size()/8);

  }; // compute_key()..

  match_found(add_item: any_struct,add_port: any_port,match_item: any_struct,match_port:any_port) is also {
    checked_items = checked_items + 1;
  };

  check() is also {
    message(LOW,"AHB_UART_SCBD : NO OF PACKETS CHECKED  = ",checked_items);
  }; -- check()

}; // unit apb_subsystem_ahb_uart_uvm_scoreboard_u..

'>
