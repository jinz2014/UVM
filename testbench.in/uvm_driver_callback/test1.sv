`include "uvm_macros.svh"
import uvm_pkg::*;

`include "driver.sv"



class Custom_Driver_callbacks_1 extends Driver_callback;

     function new (string name = "Driver_callback");
        super.new(name);
     endfunction
   
     virtual task pre_send();
       $display("CB_1:pre_send: Delaying the packet driving by 20 time units. %d",$time);
       #20;
     endtask
  
     virtual task post_send();
      $display("CB_1:post_send: Just a message from  post send callback method \n");
     endtask
 
endclass 

module test;

initial begin
  Driver drvr;
  Custom_Driver_callbacks_1 cb_1;
  drvr = new("drvr");
  cb_1 = new("cb_1");
  uvm_callbacks #(Driver,Driver_callback)::add(drvr,cb_1);
  uvm_callbacks #(Driver,Driver_callback)::display();
  run_test();
end 

endmodule 
