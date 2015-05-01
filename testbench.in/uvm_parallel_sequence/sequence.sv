// a single sequence
class operation_addition extends uvm_sequence #(instruction);

  //`uvm_sequence_utils(operation_addition, instruction_sequencer)    
  `uvm_object_utils(operation_addition)

  instruction req;
 
  function new(string name="operation_addition");
    super.new(name);
  endfunction
  

  virtual task body();
      req = instruction::type_id::create("req");
      wait_for_grant();
      // randomize
      assert(req.randomize() with {inst == instruction::PUSH_A;});
      send_request(req);
      wait_for_item_done();
      //get_response(res); This is optional. Not using in this example.

      req = instruction::type_id::create("req");
      wait_for_grant();
      req.inst = instruction::PUSH_B;
      send_request(req);
      wait_for_item_done();
      //get_response(res); 

      req = instruction::type_id::create("req");
      wait_for_grant();
      req.inst = instruction::ADD;
      send_request(req);
      wait_for_item_done();
      //get_response(res); 

      req = instruction::type_id::create("req");
      wait_for_grant();
      req.inst = instruction::POP_C;
      send_request(req);
      wait_for_item_done();
      //get_response(res); 
  endtask
  
endclass 

// parallel sequences and each one is addition sequence
class fork_join_sequence extends uvm_sequence #(instruction);
  `uvm_object_utils(fork_join_sequence) 
  operation_addition a;
  operation_addition b;

  function new(string name="operation_addition");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("fork_join_sequence", "task body", UVM_LOW)
    fork
      test1;
      test2;
    join
  endtask 

  task test1();
    `uvm_info("fork_join_sequence", "test1 ",UVM_LOW)
    `uvm_do(a)
    `uvm_info("fork_join_sequence", "test1 " ,UVM_LOW)
  endtask

  task test2();
    `uvm_info("fork_join_sequence", "test2 ",UVM_LOW)
    `uvm_do(b)
    `uvm_info("fork_join_sequence", "test2 ",UVM_LOW)
  endtask
endclass 


