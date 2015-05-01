/*---------------------------------------------------------------
File name   :  tb_uart.v

Title       :  Uart top module 

Project     :  Module UART

Developers  :  

Created     :  November 2010

Description :  uart top verilog file 

Notes       :  
---------------------------------------------------------------

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
 
---------------------------------------------------------------*/

`timescale 1ns/10ps


// ========================================================
// Example for an hdl top file for a DUT Slave. 
// It contains the following steps :
//
//   1.Environments constants (Data and Address width)
//
//   2.SHARED signals definitions
//
//   3.DUT signals (slave) definitions
//
//   4.UVC AGENTS signals definitions
//
//   5.DUT Instantiation
//
//   6.MUXES Instantiations
//
//   7.Initialization (Reset, clock)
//
// =========================================================



module tb_uart;
   
  
  // ====================================
  // ====================================
  // SHARED signals
  // ====================================
  // ====================================
  reg clock;
  reg hresetn;
  reg [6:0] apb_addr;
  reg apb_rwd;
  reg [31:0] apb_wdata;
  reg apb_enable;

  reg apb_slverr;
  wire [31:0] apb_rdata;
  wire [3:0] wb_sel;
  wire apb_ready;
  
  reg apb_sel;

  reg rxd;
  wire txd;

  wire ri_n;
  reg cts_n;
  wire dsr_n;
  wire rts_n;
  wire dtr_n;
  wire dcd_n;
  assign wb_sel = (apb_addr[1:0] == 0) ? 4'b0001 : (apb_addr[1:0] == 1 ? 4'b0010 : (apb_addr[1:0] == 2 ? 4'b0100 : 4'b1000)); 
   
  // clock
  reg specman_hclk;

  
  //RTL Instantiation
  uart_top  uart_dut (

    // Clock
    .wb_clk_i(specman_hclk), 
	
    // Wishbone signals
    .wb_rst_i(~hresetn),
    .wb_adr_i(apb_addr[4:0]),
    .wb_dat_i(apb_wdata),
    .wb_dat_o(apb_rdata),
    .wb_we_i(apb_rwd),
    .wb_stb_i(apb_sel),
    .wb_cyc_i(apb_sel),
    .wb_ack_o(apb_ready),
    .wb_sel_i(wb_sel),
    .int_o(), // interrupt request

    // UART signals
    // serial input/output
    .stx_pad_o(txd),
    .srx_pad_i(rxd),

    // modem signals
    .rts_pad_o(rts_n),
    .cts_pad_i(cts_n),
    .dtr_pad_o(dtr_n),
    .dsr_pad_i(dsr_n),
    .ri_pad_i(ri_n),
    .dcd_pad_i(dcd_n)
  );

  initial begin

    // Simulation Clock Initialization
    specman_hclk = 0;
    
    // Reset Initialization
    hresetn = 0;
    apb_sel = 1'b0;
    apb_enable = 1'b1;
    apb_wdata = 0;
    #80 hresetn = 1;
    #400 hresetn = 0;
    #400 hresetn = 1;
  end  

 // Clock Generator
 always #40 specman_hclk = ~specman_hclk;

endmodule
