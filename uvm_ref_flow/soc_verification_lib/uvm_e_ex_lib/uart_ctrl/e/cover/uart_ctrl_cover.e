/*-------------------------------------------------------------------------
File name   : uart_ctrl_cover.e
Title       : Coverage model Sequence library
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the coverage model for uart DUT
            : 

Notes       : Coverage model for uart dut
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

unit uart_ctrl_env_cover_u {

  //--------------
  // Tx FIFO level
  //--------------
  tx_fifo_level_p: in simple_port of uint(bits:5) is instance;
  keep bind(tx_fifo_level_p, external);
  keep soft tx_fifo_level_p.hdl_path() == "regs.transmitter.tf_count";

  event cov_tx_fifo_level_e is change(tx_fifo_level_p$) @sim;

  cover cov_tx_fifo_level_e using per_unit_instance is {
    item tx_fifo_level : uint(bits:7) = tx_fifo_level_p$ using 
    ranges = {
      range([0],       "Empty");
      range([1..31],   "1 to 31");
      range([32],      "FIFO full");
    };
  };


  //--------------
  // Rx FIFO level
  //--------------
  rx_fifo_level_p: in simple_port of uint(bits:5) is instance;
  keep bind(rx_fifo_level_p, external);
  keep soft rx_fifo_level_p.hdl_path() == "regs.receiver.rf_count";

  event cov_rx_fifo_level_e is change(rx_fifo_level_p$) @sim;

  cover cov_rx_fifo_level_e  using per_unit_instance is {
    item rx_fifo_level : uint(bits:7) = rx_fifo_level_p$ using 
    ranges = {
      range([0],       "Empty");
      range([1..31],   "1 to 31");
      range([32],      "FIFO full");
    };
  };


  //--------------------------------------------------------------
  // Interrupt Channel Status Reg : coverage of interrupt register
  //--------------------------------------------------------------
  int_register_p: in simple_port of uint(bits:4) is instance;
  keep bind(int_register_p, external);
  keep soft int_register_p.hdl_path() == "regs.iir";

  event cov_int_register_e is change(int_register_p$) @sim;

  cover cov_int_register_e  using per_unit_instance is {
    item intr_type : uint(bits : 3)  = int_register_p$[3:1]; 
  };

  //--------------------------------------------------------------
  // Interrupt Mask Reg : coverage of interrupt mask register
  //--------------------------------------------------------------
  int_mask_register_p: in simple_port of uint(bits:4) is instance;
  keep bind(int_mask_register_p, external);
  keep soft int_mask_register_p.hdl_path() == "regs.ier";

  event cov_int_mask_register_e is change(int_mask_register_p$) @sim;

  cover cov_int_mask_register_e  using per_unit_instance is {
    item rx_data_avai   : bit = int_mask_register_p$[0:0]; 
    item tx_fifo_empty  : bit = int_mask_register_p$[1:1]; 
    item rx_line_status : bit = int_mask_register_p$[2:2]; 
    item modem_status   : bit = int_mask_register_p$[3:3]; 
  };

  event cov_int_change_e is @cov_int_register_e or @cov_int_mask_register_e;

  on cov_int_change_e {
    message(LOW, "Int change seen");
  };

  //--------------------------------------------------------------
  // Top level interrupt signal 
  //--------------------------------------------------------------
  uart_int_p: in simple_port of bit is instance;
  keep bind(uart_int_p, external);
  keep soft uart_int_p.hdl_path() == "int_o";

  event cov_uart_int_e is change(uart_int_p$) @sim;

  cover cov_uart_int_e  using per_unit_instance is {
    item uart_int: bit = uart_int_p$;
  };
};


extend sys {
  setup() is also {
    // Enable Collecting coverage
    set_config(cover, mode, on);
  };
};

'>

