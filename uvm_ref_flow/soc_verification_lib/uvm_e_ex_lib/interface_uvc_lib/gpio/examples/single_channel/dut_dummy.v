/*-----------------------------------------------------------------
File name     : dut_dummy.v
Created       : Mar 28, 2007 
Description   : gpio env dummy dut verilog file
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

module dut_dummy;

   reg sig_reset;	
   reg sig_clock;
  
   wire [15:0] sig_data_in;
   wire [15:0] sig_data_out;
   wire [15:0] sig_data_oe;
   
   // Generate Clock
   always #50 sig_clock <= ~sig_clock;
   assign sig_data_in = 100;
   assign sig_data_oe = 50;
   initial begin
      sig_reset = 1;
      sig_clock = 0;
      #501;
      sig_reset = 1;
   end
   
   // get VCD
   initial
    begin
       $dumpvars;
    end
   
endmodule


