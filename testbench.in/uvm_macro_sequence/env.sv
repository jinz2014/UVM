class env extends uvm_env;

  instruction_sequencer sequencer;
  instruction_driver driver;
  uvm_macro_sequence macro_seq; 

  function new(string name, uvm_component parent);
    super.new(name, parent);
    macro_seq = uvm_macro_sequence ::type_id::create("macro_sequence");
    sequencer = new("sequencer", null); 
    driver = new("driver", null); 
  endfunction

  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

  function void end_of_elaboration_phase (uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    sequencer.print();
  endfunction

  task run_phase(uvm_phase phase);
    int i;

    phase.raise_objection(this);
    for (i = 0; i < 1; i++) begin
      // 
        macro_seq.start(sequencer, null, -1, 1);
    end
    phase.drop_objection(this);
  endtask

endclass


