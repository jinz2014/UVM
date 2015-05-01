/*-------------------------------------------------------------------------
File name   : apb_subsystem_ahb_spi_uvm_scoreboard.e
Title       : Scoreboard for AHB-SPI interface in APB subsystem
Project     :
Created     : November 2010
Description : Data scoreboard for checking data in AHB-SPI interface
              
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

// AHB-UART Scoreboard unit derived from uvm_scoreboard
unit apb_subsystem_ahb_spi_uvm_scoreboard_u like uvm_scoreboard {

  // -----------------------------------------------------
  // Declaration of the scoreboard ports :
  // Declare add and match TLM analysis interface ports for
  // scoreboard communication with the VE
  // -----------------------------------------------------

  // ports related to AHB frame - to - SPI transfer
  scbd_port ahb_trans_add    : add ahb_env_monitor_transfer;
  scbd_port spi_frame_match  : match spi_item_s;

  // ports related to SPI transfer - to - AHB frame
  scbd_port spi_frame_add   : add spi_item_s;
  scbd_port ahb_trans_match  : match ahb_env_monitor_transfer;

  // Name printed in messages
  keep name == "UART_AHB_SPI_UVM_SCOREBOARD";

  // Base address
  base_addr : uint(bits : 32);
  keep soft base_addr == 0;

  // SPI TX-FIFO Base Address
  spi_tx_fifo_addr : uint;
  keep soft spi_tx_fifo_addr == base_addr + APB_SUB_SYSTEM_SPI_TXFIFO_ADDR;

  // SPI RX-FIFO Base Address
  spi_rx_fifo_addr : uint;
  keep soft spi_rx_fifo_addr == base_addr + APB_SUB_SYSTEM_SPI_RXFIFO_ADDR;

  // No Ordering rules between the ports
  keep global_ooo_depth == UNDEF;

  // Intended for in_order behaviour of the items
  keep match_port_ooo_depth == 1;

  keep ooo_exclude_matches_and_drops == TRUE;

  // This field sets the number of matched and dropped items that are
  // kept in the scoreboard(Default value is 10)
  keep history_limit == 100;

  // Number of Packet Checked
  checked_items : uint; 
  keep soft checked_items == 0;

  // ----------------------------------------------------------------------
  // This method should be called to add an AHB transfer to the scoreboard.
  // If the AHB Write is meant for SPI-TX FIFO , and transfer kind is a 
  // non IDLE transaction , then only add into the scoreboard
  // ----------------------------------------------------------------------
  ahb_trans_add_predict(item : ahb_env_monitor_transfer) is only {
    if ((item.kind != IDLE) && (item.address == spi_tx_fifo_addr) &&
      (item.direction == WRITE)) {
      item.data[31:8] = 0; // Need only data[7:0]
      add_to_scbd(item);        
      set_match_port(item,spi_frame_match);
      message(LOW,"Added the AHB frame into the Scoreboard ") {
        print item using hex;
      };
    };
  }; // ahb_trans_add_predict()..

  // Add the SPI Frame into the Scoreboard 
  spi_frame_add_predict(item : spi_item_s) is only {
    add_to_scbd(item);
    set_match_port(item, ahb_trans_match);
    message(LOW,"Added the SPI frame into the Scoreboard ") {
      print item using hex;            
    };                       
  };

  // SPI Frame Match method
  spi_frame_match_reconstruct(item : spi_item_s) is only {
    match_in_scbd(item);
    message(LOW,"Looking for SPI frame match into the Scoreboard ") {
      print item using hex;
    };
  };

  // This method should be called for an AHB match when an AHB Read is 
  // meant for SPI-RX FIFO
  ahb_trans_match_reconstruct( item : ahb_env_monitor_transfer) is only {
    if(item.direction == READ and item.kind != IDLE and 
      item.address == spi_rx_fifo_addr) then {
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

    if item is a spi_item_s then {
      if(item.as_a(spi_item_s).read_write_n_bl == FALSE) {
        data_list =  pack(NULL,item.as_a(spi_item_s).data_out);
      } else {
        data_list =  pack(NULL,item.as_a(spi_item_s).data_in);
      };
    };

    // Pad to length of 8 for CRC computation
    data_list.resize(8, TRUE, 0, TRUE);
    return data_list.crc_32(0,data_list.size()/8);

  }; // compute_key()..

  
  match_found(add_item: any_struct,add_port: any_port,match_item: any_struct,match_port:any_port) is also {
    checked_items = checked_items + 1;
  };

  check() is also {
    message(LOW,"AHB_SPI_SCBD : NO OF PACKETS CHECKED  = ",checked_items);
  }; -- check()

}; // unit apb_subsystem_ahb_spi_uvm_scoreboard_u..

'>
