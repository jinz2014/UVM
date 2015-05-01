class agent extends uvm_agent;

  `uvm_component_utils(agent)

  B_driver driver0;
  B_driver driver1;

  // component constructor
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // override the packet type for driver0 and below
    packet::type_id::set_inst_override(my_packet::get_type(), "driver0.*");

    // create using the factory; actual driver types may be different
    driver0 = B_driver::type_id::create("driver0",this);
    driver1 = B_driver::type_id::create("driver1",this);
  endfunction

endclass : agent
