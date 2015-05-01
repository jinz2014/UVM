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

class operation_multiplication extends uvm_sequence #(instruction);

  instruction req;
 
  function new(string name="operation_multiplication");
    super.new(name);
  endfunction
  
  `uvm_object_utils(operation_multiplication)

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
      req.inst = instruction::MUL;
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

class operation_divide extends uvm_sequence #(instruction);

  instruction req;
 
  function new(string name="operation_divide");
    super.new(name);
  endfunction
  
  `uvm_object_utils(operation_divide)

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
      req.inst = instruction::DIV;
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
