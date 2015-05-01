class dut_reset_seq extends uvm_sequence;

   function new(string name = "dut_reset_seq");
      super.new(name);
   endfunction

   `uvm_object_utils(dut_reset_seq)
   
   virtual task body();
      tb_top.rst = 1;
      repeat (5) @(negedge tb_top.clk);
      tb_top.rst = 0;
   endtask
endclass


