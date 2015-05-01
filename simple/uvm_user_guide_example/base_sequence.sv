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
      `uvm_info("body", req.convert2string(), UVM_LOW);
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
