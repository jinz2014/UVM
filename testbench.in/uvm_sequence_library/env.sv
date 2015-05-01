class env extends uvm_env;
  int i;

  instruction_sequencer sequencer;
  instruction_driver driver;
  sequence_lib seq_lib;

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
    seq_lib = new("sequence_library");
    seq_lib.selection_mode = UVM_SEQ_LIB_RANDC;
    seq_lib.min_random_count = 4; // 
    seq_lib.max_random_count = 4;
    seq_lib.randomize();
    sequencer = new("sequencer", null); 
    driver = new("driver", null); 
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    //set_config_string("sequencer","default_sequence",  "uvm_exhaustive_sequence");
    //set_config_string("sequencer","default_sequence",  "uvm_random_sequence");
    //set_config_string("sequencer","default_sequence",  "uvm_simple_sequence");

    // NOT working ??
    //uvm_config_db #(uvm_sequence_lib_mode)::set(this, "sequencer.main_phase", "selection_mode",  UVM_SEQ_LIB_RANDC);
    //uvm_config_db #(uvm_object_wrapper)::set(this, sequencer.main_phase", "default_sequence", sequence_lib::get_type());
    //uvm_config_db #(uvm_sequence_base)::set(this, "sequencer.main_phase", "default_sequence",  seq_lib);
    
    /*
    uvm_config_db #(uvm_object_wrapper)::set(this, 
    "sequencer.run_phase", "default_sequence",
    //uvm_simple_sequence::type_id::get_type()); //sequence_lib::type_id::get_type());
    operation_addition::type_id::get());
    */
  endfunction

  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

  function void end_of_elaboration_phase (uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    //`uvm_info("elab", $sformatf("%d", sequencer.main_phase.max_random_count), UVM_LOW)
    sequencer.print();
  endfunction

  task run_phase(uvm_phase phase);
    int i;

    phase.raise_objection(this);

    for (i = 0; i < 3; i++)
      seq_lib.start(sequencer, null);

    phase.drop_objection(this);

    /* alternatively ?
    seq_lib.starting_phase = phase;
    seq_lib.start(sequencer, null);
    */

  endtask

endclass


