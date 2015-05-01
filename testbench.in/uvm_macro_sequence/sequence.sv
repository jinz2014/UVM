/*
start(  uvm_sequencer_base sequencer, uvm_sequence_base parent_sequence = null, int this_priority = -1, bit call_pre_post = 1 )
Task:
      start

      Executes this sequence, returning when the sequence has completed.

      The sequencer argument specifies the sequencer on which to run this
      sequence. The sequencer must be compatible with the sequence.

        If parent_sequence is null, then this sequence is a root parent,
          otherwise it is a child of parent_sequence. The parent_sequence's
          pre_do, mid_do, and post_do methods will be called during the execution
          of this sequence.

          By default, the priority of a sequence
          is the priority of its parent sequence.
          If it is a root sequence, its default priority is 100.
            A different priority may be specified by this_priority.
            Higher numbers indicate higher priority.

            If call_pre_post is set to 1 (default), then the pre_body and
              post_body tasks will be called before and after the sequence
              body is called.

========================================================================================== 
a sample run results:
@ 0: sequencer@@sequence_library.demo_uvm_do:1 [sequencer.sequence_library.demo_uvm_do:1] Before uvm_do macro 
@ 0: sequencer@@sequence_library.demo_uvm_do:1 [demo_uvm_do] PRE_DO
@ 0: sequencer@@sequence_library.demo_uvm_do:1 [demo_uvm_do] MID_DO
0: Driving Instruction  DIV
@ 10: sequencer@@sequence_library.demo_uvm_do:1 [demo_uvm_do] POST_DO
@ 10: sequencer@@sequence_library.demo_uvm_do:1 [sequencer.sequence_library.demo_uvm_do:1] After uvm_do macro 
*/

class uvm_macro_sequence extends uvm_sequence #(instruction);

  `uvm_object_utils(uvm_macro_sequence) 

  instruction req;
 
  function new(string name="operation_addition");
    super.new(name);
  endfunction

  // shouldn't be called directly by the user
  virtual task pre_do(bit is_item);
    `uvm_info("demo_uvm_do", "task pre_do", UVM_LOW)
  endtask

  // shouldn't be called directly by the user
  virtual function void mid_do(uvm_sequence_item this_item);
    `uvm_info("demo_uvm_do", "function mid_do", UVM_LOW)
  endfunction

  // shouldn't be called directly by the user
  virtual function void post_do(uvm_sequence_item this_item);
    `uvm_info("demo_uvm_do", "function post_do", UVM_LOW)
  endfunction

  virtual task body();
     test1;
     //test2;
     //test3;
     //test4;
  endtask

  task test1();
    `uvm_info(get_full_name(), "test1 begin",UVM_LOW)
    `uvm_do(req)
    `uvm_info(get_full_name(), "test1 end" ,UVM_LOW)
  endtask

  task test2();
    `uvm_info(get_full_name(), "test2 begin",UVM_LOW)
    `uvm_do_with(req, {inst == ADD;})
    `uvm_info(get_full_name(), "test2 end",UVM_LOW)
  endtask

  task test3();
    `uvm_info(get_full_name(), "test3 begin",UVM_LOW)
    `uvm_create(req)
    req.inst = instruction::PUSH_B;
    `uvm_send(req)
    `uvm_info(get_full_name(), "test3 end",UVM_LOW)
  endtask
    
  task test4();
    `uvm_info(get_full_name(), "test4 begin",UVM_LOW)
    `uvm_create(req)
    `uvm_rand_send(req)
    `uvm_info(get_full_name(), "test4 end",UVM_LOW)
  endtask

endclass

