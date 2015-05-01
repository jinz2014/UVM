////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s             UVM Tutorial             s////
////s           gopi@testbenh.in           s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////

`include "uvm.svh"
 import uvm_pkg::*;

`include "sequence_item.sv"
`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"

module test;


  instruction_sequencer sequencer;
  instruction_driver driver;

  initial begin
    set_config_string("sequencer", "default_sequence", "uvm_exhaustive_sequence");
    sequencer = new("sequencer", null); 
    sequencer.build();
    driver = new("driver", null); 
    driver.build();

    driver.seq_item_port.connect(sequencer.seq_item_export);
    sequencer.print();
    fork 
      begin
        run_test();
        sequencer.start_default_sequence();
      end
      #3000 global_stop_request();
    join
  end

endmodule

