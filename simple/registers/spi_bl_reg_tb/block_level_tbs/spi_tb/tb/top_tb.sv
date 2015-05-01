//------------------------------------------------------------
//   Copyright 2010 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------

module top_tb;

`include "timescale.v"

import uvm_pkg::*;
import spi_test_lib_pkg::*;

// PCLK and PRESETn
//
logic PCLK;
logic PRESETn;

//
// Instantiate the interfaces:
//
apb_if APB(PCLK, PRESETn);   // APB interface
spi_if SPI();  // SPI Interface
intr_if INTR();   // Interrupt

// DUT
spi_top DUT(
    // APB Interface:
    .PCLK(PCLK),
    .PRESETN(PRESETn),
    .PSEL(APB.PSEL[0]),
    .PADDR(APB.PADDR[4:0]),
    .PWDATA(APB.PWDATA),
    .PRDATA(APB.PRDATA),
    .PENABLE(APB.PENABLE),
    .PREADY(APB.PREADY),
    .PSLVERR(),
    .PWRITE(APB.PWRITE),
    // Interrupt output
    .IRQ(INTR.IRQ),
    // SPI signals
    .ss_pad_o(SPI.cs),
    .sclk_pad_o(SPI.clk),
    .mosi_pad_o(SPI.mosi),
    .miso_pad_i(SPI.miso)
);


// UVM initial block:
// Put virtual interfaces into the resource db & run_test()
initial begin
  uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top", "APB_vif", APB);
  uvm_config_db #(virtual spi_if)::set(null, "uvm_test_top", "SPI_vif", SPI);
  uvm_config_db #(virtual intr_if)::set(null, "uvm_test_top", "INTR_vif", INTR);
  run_test();
end

//
// Clock and reset initial block:
//
initial begin
  PCLK = 0;
  PRESETn = 0;
  repeat(8) begin
    #10ns PCLK = ~PCLK;
  end
  PRESETn = 1;
  forever begin
    #10ns PCLK = ~PCLK;
  end
end

endmodule: top_tb