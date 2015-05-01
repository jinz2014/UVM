//------------------------------------------------------------
//   Copyright 2010-2011 Mentor Graphics Corporation
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

import uvm_pkg::*;
import mem_ss_test_lib_pkg::*;

// Clock and Resetn:
logic HCLK;
logic HRESETn;

// AHB Interface
ahb_if AHB(HCLK, HRESETn);

// DUT - wrapped
mem_ss_wrapper DUT(.AHB(AHB));

//
// Put the AHB into the resource database and
// start up the UVM
//
initial begin
  uvm_config_db #(virtual ahb_if)::set(null, "uvm_test_top", "AHB_if", AHB);
  run_test();
end


//
// Clock and reset initial block:
//
initial begin
  HCLK = 0;
  HRESETn = 0;
  repeat(8) begin
    #10ns HCLK = ~HCLK;
  end
  HRESETn = 1;
  forever begin
    #10ns HCLK = ~HCLK;
  end
end

endmodule: top_tb