  
  class env extends uvm_env;

    //Use the macro in a class to implement factory registration along with other
    //utilities (create, get_type_name). For only factory registration, use the
    // macro `uvm_component_registry(env,"env").
    `uvm_component_utils(env)
    
    agent agent0;
    agent agent1;

    function new (string name, uvm_component parent=null);
      uvm_component cmp;
      super.new(name, parent);
    endfunction
     
    virtual function void build_phase(uvm_phase phase);
      // three methods to set an instance override (assume no overrides made at the top level (i.e. top.sv)) 

      // - via component convenience method...
      set_inst_override_by_type("agent1.driver1", B_driver::get_type(), D1_driver::get_type());

      // - via the component's proxy (same approach as create)...
      // Oops, it doesn't work !
      //B_driver::type_id::set_inst_override(D2_driver::get_type(), "agent0.driver1");

      // - via a direct call to a factory method...
      factory.set_inst_override_by_type(B_driver::get_type(), D2_driver::get_type(), {get_full_name(),".agent0.driver0"});

      // create agents using the factory; actual agent types may be different
      agent0 = agent::type_id::create("agent0",this);
      agent1 = agent::type_id::create("agent1",this);
    endfunction

    // at end_of_elaboration, print topology and factory state to verify
    virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
      #100 global_stop_request();
    endtask
endclass
