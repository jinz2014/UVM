// A uvm_env based testbench 

class base_tb extends uvm_env;
// Provide implementations of virtual methods such as get_type_name().
`uvm_component_utils(base_tb)

// reusable environment
base_env bus0;

// Scoreboard to check the delay constraints 
base_scoreboard scoreboard0;

// new()
function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build()
virtual function void build_phase(uvm_phase phase);
 super.build_phase(phase); 
 //------------------------------------------------------
 // Maybe overriden in the user uvm test 
 //------------------------------------------------------

 // configure subcomponents before creating it
 uvm_config_db#(int)::set(this,"bus0", "num_masters", 1);
 //uvm_config_db#(int)::set(this,".bus0", "num_slaves", 1);

 //uvm_config_db#(int)::set(this,"bus0.masters[0]", "is_active", UVM_PASSIVE);
 uvm_config_db#(int)::set(this,"bus0.masters[0]", "is_active", UVM_ACTIVE);

 bus0 = base_env::type_id::create("bus0", this);

 scoreboard0 = base_scoreboard::type_id::create("scoreboard0", this);
endfunction : build_phase

virtual function void connect_phase(uvm_phase phase);
 // Connect master monitor to scoreboard.
 bus0.masters[0].monitor.item_collected_port.connect( scoreboard0.item_collected_export);
endfunction : connect_phase

virtual function void end_of_elaboration();
 // Set up slave address map for bus0 (basic default).
 //bus0.set_slave_address_map("slaves[0]", 0, 16'hffff);
endfunction : end_of_elaboration

endclass : base_tb


