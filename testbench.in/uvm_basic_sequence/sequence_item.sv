////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s             UVM Tutorial             s////
////s           gopi@testbenh.in           s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////

class instruction extends uvm_sequence_item;
  typedef enum {PUSH_A,PUSH_B,ADD,SUB,MUL,DIV,POP_C} inst_t; 
  rand inst_t inst;

  `uvm_object_utils_begin(instruction)
    `uvm_field_enum(inst_t,inst, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (string name = "instruction");
    super.new(name);
  endfunction 

endclass 


