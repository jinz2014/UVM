class env extends uvm_env;
  int i;

  instruction_sequencer sequencer;
  instruction_driver driver;
  fork_join_sequence p_seq ; 

  function new(string name, uvm_component parent);
    super.new(name, parent);
    p_seq = fork_join_sequence::type_id::create("fork_join_sequence");
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
    for (i = 0; i < 2; i++) begin
        p_seq.start(sequencer, null);
    end
    phase.drop_objection(this);
  endtask

endclass


