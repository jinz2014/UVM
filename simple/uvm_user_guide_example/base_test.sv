class base_test extends uvm_test;

`uvm_component_utils(base_test)

base_tb base_tb0;

// The test's constructor
function new (string name = "base_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Update this component's properties and create the base_tb component.
virtual function void build_phase(uvm_phase phase); // Create the testbench.
  super.build_phase(phase);
  base_tb0 = base_tb::type_id::create("base_tb0", this);
endfunction

endclass

