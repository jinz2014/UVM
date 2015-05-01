class seq_add extends uvm_sequence #(instruction);

  //`uvm_sequence_utils(operation_addition, instruction_sequencer)    
  `uvm_object_utils(seq_add)

  instruction req;
 
  function new(string name="operation_addition");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat (3)
    `uvm_do_with(req, {inst == ADD;})
  endtask
  
endclass 


class seq_mul extends uvm_sequence #(instruction);

  //`uvm_sequence_utils(operation_mulition, instruction_sequencer)    
  `uvm_object_utils(seq_mul)

  instruction req;
 
  function new(string name="operation_multiplication");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat (3)
    `uvm_do_with(req, {inst == MUL;})
  endtask
  
endclass 

class seq_sub extends uvm_sequence #(instruction);

  //`uvm_sequence_utils(operation_subition, instruction_sequencer)    
  `uvm_object_utils(seq_sub)

  instruction req;
 
  function new(string name="operation_subtraction");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat (3)
    `uvm_do_with(req, {inst == SUB;})
  endtask
  
endclass 


class fork_join_sequence extends uvm_sequence #(instruction);
  `uvm_object_utils(fork_join_sequence) 

  function new(string name="fork_join_sequence");
    super.new(name);
  endfunction

  seq_add add;
  seq_sub sub;
  seq_mul mul;
  
  // run three seperate tests
  virtual task body();
    test1;
    test2;
    test3;
  endtask 

  task test1();
    `uvm_info("test1", "random arb", UVM_LOW)
    m_sequencer.set_arbitration(SEQ_ARB_RANDOM);
    fork
      `uvm_do(add)
      `uvm_do(sub)
      `uvm_do(mul)
    join
  endtask 

  task test2();
    `uvm_info("test2", "fifo arb", UVM_LOW)
    m_sequencer.set_arbitration(SEQ_ARB_FIFO);
    fork
      `uvm_do(add)
      `uvm_do(sub)
      `uvm_do(mul)
    join
  endtask 

  task test3();
    `uvm_info("test3", "weighted arb", UVM_LOW)
    m_sequencer.set_arbitration(SEQ_ARB_WEIGHTED);
    `uvm_create(add)
    `uvm_create(sub)
    `uvm_create(mul)
    fork
      add.start(m_sequencer, this, 500);
      sub.start(m_sequencer, this, 100);
      mul.start(m_sequencer, this, 20);
    join
  endtask 

endclass 


