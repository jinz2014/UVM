`include "uvm_macros.svh"
import uvm_pkg::*;

`include "base_item.sv"
`include "word_aligned_item.sv"
`include "base_sequence.sv"
`include "base_driver.sv"
`include "base_monitor.sv"
`include "base_agent.sv"
`include "base_env.sv"
`include "base_scoreboard.sv"
`include "base_tb.sv"
`include "base_test.sv"
`include "word_aligned_test.sv"
`include "word_aligned_error_test.sv"
`include "word_aligned_medium_test.sv"
`include "dut_if.sv"
`include "dut.sv"

module top;

// interface 
dut_if  pif();

// DUT 
dut_dummy dut (pif);

// all non-testbench code
initial begin
  pif.clk = 0;
  forever begin
    #5 pif.clk = ~pif.clk;
  end
end
    
initial begin
  uvm_config_db #(virtual dut_if)::set(null, "*", "vif", pif);
  run_test();
end


endmodule
