////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s             UVM Tutorial             s////
////s           gopi@testbenh.in           s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////

class instruction_driver extends uvm_driver #(instruction);

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(instruction_driver)

  // Constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction 

  task run ();
    forever begin
      seq_item_port.get_next_item(req);
      $display("%0d: Driving Instruction  %s",$time,req.inst.name());
      #10;
      // rsp.set_id_info(req);   These two steps are required only if 
      // seq_item_port.put(esp); responce needs to be sent back to sequence
      seq_item_port.item_done();
    end
  endtask

endclass 



