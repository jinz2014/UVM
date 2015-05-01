/*-------------------------------------------------------------------------
File name   : apb_subsystem_cover.e
Title       : Coverage File for APB subsystem
Project     :
Created     : November 2010
Description : Top level coverage file

Notes       : 
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

// Coverage unit for APB subsystem
unit apb_subsystem_cover_u {

  //----------------
  // Tx FIFO level
  //----------------

  tx_fifo_level_p: in simple_port of uint(bits:7) is instance;
  keep bind(tx_fifo_level_p, external);
  keep soft tx_fifo_level_p.hdl_path() == "i_apb_subsystem.i_oc_uart0.regs.transmitter.fifo_tx.count";

  event cov_tx_fifo_level_e is change(tx_fifo_level_p$) @sim;

  cover cov_tx_fifo_level_e using per_unit_instance is {
    -- assign the DUT level to the item "tx_fifo_level"
    item tx_fifo_level : uint(bits:7) = tx_fifo_level_p$ using 
      ranges = {
        range([0],       "Empty");
        range([1..7],   "1 to 7");
        range([8..15],  "8 to 15");
        range([16],      "FIFO full");
      };
  };


  //----------------
  // Rx FIFO level
  ----------------
  rx_fifo_level_p: in simple_port of uint(bits:7) is instance;
  keep bind(rx_fifo_level_p, external);
  keep soft rx_fifo_level_p.hdl_path() == "i_apb_subsystem.i_oc_uart0.regs.receiver.fifo_rx.count";

  event cov_rx_fifo_level_e is change(rx_fifo_level_p$) @sim;

  cover cov_rx_fifo_level_e using per_unit_instance  is {
    -- assign the DUT level to the item "rx_fifo_level"
    item rx_fifo_level : uint(bits:7) = rx_fifo_level_p$ using 
      ranges = {
        range([0],       "Empty");
        range([1..7],   "1 to 7");
        range([8..15],  "8 to 15");
        range([16],      "FIFO full");
      };
  };


  //----------------------------------------------------------------
  // Top level interrupt signal 
  //----------------------------------------------------------------

  uart_int_p: in simple_port of bit is instance;
  keep bind(uart_int_p, external);
  keep soft uart_int_p.hdl_path() == "i_apb_subsystem.i_oc_uart0.int_o";

  event cov_uart_int_e is change(uart_int_p$) @sim;
  cover cov_uart_int_e using per_unit_instance  is {
    item uart_int: bit = uart_int_p$;
  };
}; //end unit apb_subsystem_cover..


extend uart_monitor_u {
  cover mon_frame_done is also {
    //item evc_name using per_instance;
  };
};

// Enable the Coverage
extend sys {
  setup() is also {
    set_config(cover, mode, on);
  };
};

'>

