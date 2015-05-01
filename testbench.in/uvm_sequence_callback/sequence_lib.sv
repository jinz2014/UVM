class sequence_lib extends uvm_sequence_library #(instruction);
  `uvm_object_utils(sequence_lib)
  `uvm_sequence_library_utils(sequence_lib)

  //`uvm_add_to_seq_lib(operation_addition, sequence_lib);
  //`uvm_add_to_seq_lib(operation_subtraction, sequence_lib);
  `uvm_add_to_seq_lib(demo_sequence_body, sequence_lib);

  function new (string name="");
    super.new(name);
    init_sequence_library();
  endfunction
endclass
