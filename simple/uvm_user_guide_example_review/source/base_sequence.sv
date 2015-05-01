// execute a sequence item
class base_seq_do extends uvm_sequence #(base_item);

  rand int count;
  base_item req;

  constraint count_c { count >0; count <50; }

  //`uvm_sequence_utils_begin(base_seq_do, uvm_sequencer)
  `uvm_object_utils_begin(base_seq_do)
    `uvm_field_int(count, UVM_ALL_ON)
    `uvm_field_object(req, UVM_ALL_ON)
  //`uvm_sequence_utils_end
  `uvm_object_utils_end

  function new (string name = "base_seq_do");
    super.new(name);
  endfunction : new

  virtual task body();
    repeat(10) begin
      `uvm_do(req)
      //`uvm_info("body", req.convert2string(), UVM_LOW);
      req.print();
    end
  endtask : body

 /* start from basics
  virtual task body();
    repeat (10) begin
      req = base_item::type_id::create("req_item");
      start_item(req);
      req.randomize();
      finish_item(req);
      `uvm_info("body", req.convert2string(), UVM_LOW);
      $display("we are in sequence body!");
    end
  endtask : body
  */

endclass : base_seq_do 

// use uvm_do_with macro 
class base_seq_do_with extends uvm_sequence #(base_item);

  rand int count;
  base_item req;

  constraint count_c { count >0; count <50; }

  `uvm_object_utils_begin(base_seq_do_with)
    `uvm_field_int(count, UVM_ALL_ON)
    `uvm_field_object(req, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (string name = "base_seq_do_with");
    super.new(name);
  endfunction : new

  virtual task body();
    repeat(10) begin
      `uvm_do_with(req,  { req.addr == 16'h0120; req.data_in == 16'h0444; } )
      `uvm_info("body", req.convert2string(), UVM_LOW);
    end
  endtask : body

endclass : base_seq_do_with 


// execute a sequence
class sub_seq_do extends uvm_sequence #(base_item);

  rand int count;
  base_seq_do req;  // defined above

  constraint count_c { count >0; count <50; }

  `uvm_object_utils_begin(sub_seq_do)
    `uvm_field_int(count, UVM_ALL_ON)
    `uvm_field_object(req, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (string name = "sub_seq_do");
    super.new(name);
  endfunction : new

  virtual task body();
    repeat(10) begin
      `uvm_do(req)
      `uvm_info("body", req.convert2string(), UVM_LOW);
    end
  endtask : body

endclass : sub_seq_do 
