class env extends uvm_env;
  int i;

  instruction_sequencer sequencer;
  instruction_driver driver;
  sequence_lib seq_lib;
  demo_sequence_body seq_body; 

  //uvm_sequence_library_cfg cfg;
   //| cfg = new("seqlib_cfg", UVM_SEQ_LIB_RANDC, 1000, 2000);
   //|
   //| uvm_config_db #(uvm_sequence_library_cfg)::set(null,
   //|                                    "env.agent.sequencer.main_ph",
   //|                                    "default_sequence.config",
   //|                                    cfg);
   //|


  function new(string name, uvm_component parent);
    super.new(name, parent);
    sequencer = new("sequencer", null); 
    driver = new("driver", null); 
    seq_body = new("seq_body");
    seq_lib = new("sequence_library");
    seq_lib.selection_mode = UVM_SEQ_LIB_RANDC;
    seq_lib.min_random_count = 5;
    seq_lib.max_random_count = 5;
    seq_lib.randomize();
    uvm_config_db #(uvm_sequence_base)::set(this, "sequencer.main_phase", "default_sequence",  seq_lib);
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

      // pre/post body functions are not called in sequence library is started
      //seq_lib.start(sequencer, null);

      // pre/post body functions are called (the last argument is 1)
      seq_body.start(sequencer, null, -1, 1);
    
    phase.drop_objection(this);
  endtask

endclass


