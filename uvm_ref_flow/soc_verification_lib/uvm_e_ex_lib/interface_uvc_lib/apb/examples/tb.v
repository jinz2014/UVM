/*-----------------------------------------------------------------
File name     : tb.v
Developers    : 
Created       : Tue Jul 27 13:52:04 2008
Description   : Testbench top file in Verilog
Notes         :
-------------------------------------------------------------------
Copyright 1999-2010 Cadence Design Systems, Inc.
All Rights Reserved Worldwide

Licensed under the Apache License, Version 2.0 (the
"License"); you may not use this file except in
compliance with the License.  You may obtain a copy of
the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in
writing, software distributed under the License is
distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See
the License for the specific language governing
permissions and limitations under the License.
-------------------------------------------------------------------*/

module tb ();

  wire [31:0] paddr; 
  wire penable; 
  wire [31:0] pwdata; 
  wire [31:0] prdata; 
  wire pwrite; 
  wire psel; 

  wire  pready; 
  reg  clk; 
  reg  presetn; 

initial

  begin

    // Simulation Clock Initialization
    clk = 0;

    // Reset Initialization
    presetn = 1;
    #100 presetn = 0;
    #500 presetn = 1;

  end  

always #50 clk = ~clk;


endmodule
