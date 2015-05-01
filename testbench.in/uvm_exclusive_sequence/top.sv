////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s             UVM Tutorial             s////
////s           gopi@testbenh.in           s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////

`include "uvm_macros.svh"
 import uvm_pkg::*;

`include "sequence_item.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"
`include "env.sv"

module top;
  env e;

  initial begin
    `uvm_info("top","In top initial block",UVM_MEDIUM);
    e = new("env", null);
    run_test();
  end
endmodule
