/*-----------------------------------------------------------------
File name     : uart_e_config.e
Title         : uart configuration
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

// Importing the uart top file
import uart/e/uart_top;

verilog time  1ns/10ps;

extend sys {
  uart_sve : uart_sve_u is instance;
  setup() is also {
    set_config(simulation,enable_ports_unification,TRUE);
  };
};

// UART environment name
extend uart_env_name_t: [DUT, VE];

// uart env derived from uvm_env
unit uart_sve_u like uvm_env {
  
  // Specify the DUT hierarchy to be used for signal accesses
  keep hdl_path() == "tb_uart";
  keep agent()  == "verilog";
  
  // A synchronizer for the UART eVC 
  uart_sync: uart_sync is instance ;
  keep soft uart_sync.sig_uart_HCLK   == "specman_hclk";
  keep soft uart_sync.sig_uart_HRESET == "hresetn";
  keep soft uart_sync.sig_uart_BUAD_CLK == "specman_hclk";
   
   
  // The UART instance standing-on for a DUT
  dut : DUT uart_env_u is instance;
  keep soft dut.p_sync == value(uart_sync); 
  keep soft dut.has_tx == TRUE;
  keep soft dut.has_rx == TRUE;
  keep soft dut.as_a(has_rx uart_env_u).rx_agent.active_passive == ACTIVE;
  keep soft dut.config.check_protocol == FALSE;
  keep soft dut.config.stop_condition == EXTERNAL_EVENT;
  
  // The UART interface eVC serving as the verification environment
  uart_tb : VE uart_env_u is instance;
  keep soft uart_tb.p_sync     == value(uart_sync); 
  keep soft uart_tb.has_tx == TRUE;
  keep soft uart_tb.has_rx == TRUE;
  keep soft uart_tb.as_a(has_rx uart_env_u).rx_agent.active_passive == ACTIVE;
   
};

extend uart_env_u {
  short_name() : string is only {
    return( evc_name.as_a(string) );
  }; // short_name() : ...
}; // extend uart...


extend uart_env_config {
  keep soft parity_type == NONE;
  keep soft stopbit_type == TWO;
  keep soft databit_type == FIVE;
}; // extend uart...

'>


// Signal Hook up's

<'

//   DUT stand-in eVC instance
extend DUT uart_rx_signal_map_u {
  keep soft SEC_CDMA_RX_DATA == "txd";
  keep soft SEC_CDMA_RFRB =="cts_n";
}; // extend DUT cdn_...

extend DUT uart_tx_signal_map_u {
  keep soft SEC_CDMA_TX_DATA == "rxd";
  keep soft SEC_CDMA_CTSB == "rts_n";
}; // extend DUT cdn_...


// VE eVC instance 
extend VE uart_rx_signal_map_u {
  keep soft SEC_CDMA_RX_DATA == "rxd";
  keep soft SEC_CDMA_RFRB =="rts_n";
}; // extend DUT cdn_...

extend VE uart_tx_signal_map_u {
  keep soft SEC_CDMA_TX_DATA == "txd";
  keep soft SEC_CDMA_CTSB == "cts_n";
}; // extend DUT cdn_...

'>
