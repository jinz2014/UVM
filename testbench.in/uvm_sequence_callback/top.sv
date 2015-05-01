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
`include "sequence_lib.sv"
`include "driver.sv"
`include "env.sv"

class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  env env;

  function new (string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    env = new("env", null);
  endfunction

endclass

module top;

  initial begin
    `uvm_info("top","In top initial block",UVM_MEDIUM);
    run_test("base_test");
  end
endmodule
