////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s             UVM Tutorial             s////
////s           gopi@testbenh.in           s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////

class instruction_sequencer extends uvm_sequencer #(instruction);

  //`uvm_sequencer_utils(instruction_sequencer)
  `uvm_component_utils(instruction_sequencer)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction 


endclass 

