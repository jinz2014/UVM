// base word aligned item w/ random delay

class word_aligned_test extends uvm_test;

`uvm_component_utils(word_aligned_test)

base_tb base_tb0;

// The test's constructor
function new (string name = "word_aligned_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Update this component's properties and create the base_tb component.
virtual function void build_phase(uvm_phase phase); // Create the testbench.
  super.build_phase(phase);
  
  // base word aligned item
  set_type_override_by_type(base_item::get_type(), word_aligned_item::get_type());

  base_tb0 = base_tb::type_id::create("base_tb0", this);
endfunction

// 
task run_phase(uvm_phase phase);
  uvm_top.print_topology();
endtask

endclass


