// `uvm_field_enum(T,ARG,FLAG)
// T is an enumerated type, ARG is an instance of that type, and FLAG is a bitwise OR of 
// one or more flag settings as described in Field Macros above.

class base_agent extends uvm_agent;

  // 
  uvm_active_passive_enum is_active;

  // Constructor and UVM automation macros
  `uvm_component_utils_begin(base_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  uvm_sequencer #(base_item) sequencer;
  base_driver driver;
  base_monitor monitor;
  base_seq_do seq;

  function new (string name, uvm_component parent);
    super.new(name, parent);
    //seq = new("sequence");
  endfunction : new


  // Use build() phase to create agents's subcomponents.
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = base_monitor::type_id::create("monitor",this);
    //if (is_active == UVM_ACTIVE) begin
      // Build the sequencer and driver.
      sequencer = uvm_sequencer#(base_item)::type_id::create("sequencer",this);
      driver = base_driver::type_id::create("driver",this);
      seq = base_seq_do::type_id::create("sequence");
    //end
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    //if(is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    //end
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    //for (int i = 0; i < 2; i++) begin
      seq.start(sequencer, null);
    //end
    phase.drop_objection(this);
  endtask : run_phase

endclass : base_agent
