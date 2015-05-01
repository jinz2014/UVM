////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s             UVM Tutorial             s////
////s           gopi@testbenh.in           s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////


class operation_addition extends uvm_sequence #(instruction);

  instruction req;
 
  function new(string name="operation_addition");
    super.new(name);
  endfunction
  
  `uvm_object_utils(operation_addition)

  virtual task body();
      req = instruction::type_id::create("req");
      wait_for_grant();
      assert(req.randomize() with {
         inst == instruction::PUSH_A;
      });
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

class operation_subtraction extends uvm_sequence #(instruction);

  instruction req;
 
  function new(string name="operation_subtraction");
    super.new(name);
  endfunction
  
  `uvm_object_utils(operation_subtraction)

  virtual task body();
      req = instruction::type_id::create("req");
      wait_for_grant();
      assert(req.randomize() with {
         inst == instruction::PUSH_A;
      });
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
      req.inst = instruction::SUB;
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


// define pre/post body callback functions
class demo_sequence_body extends uvm_sequence #(instruction);

  `uvm_object_utils(demo_sequence_body) 

  instruction req;
 
  function new(string name="operation_addition");
    super.new(name);
  endfunction

  // before the pre_body()
  virtual task pre_start();
    super.pre_start();
    `uvm_info("demo_sequence_body", "task pre_start", UVM_LOW)
  endtask

  // after the post_body()
  virtual task post_start();
    super.post_start();
    `uvm_info("demo_sequence_body", "task post_start", UVM_LOW)
  endtask


  virtual task pre_body();
    super.pre_body();
    `uvm_info("demo_sequence_body", "task pre_body", UVM_LOW)
  endtask

  virtual task post_body();
    super.post_body();
    `uvm_info("demo_sequence_body", "task post_body", UVM_LOW)
  endtask

  // The pre_body() and post_body() callbacks are not invoked in a sequence that
  // is executed by one of the `uvm_do `uvm_create and etc macros.
  virtual task body();
    `uvm_info("demo_sequence_body", "task body", UVM_LOW)
  //  `uvm_do(req)

      req = instruction::type_id::create("req");
      wait_for_grant();
      assert(req.randomize());
      send_request(req);
      wait_for_item_done();
  endtask

endclass

