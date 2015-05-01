class Driver_callback extends uvm_callback;

  function new (string name = "Driver_callback");
    super.new(name);
  endfunction

  static string type_name = "Driver_callback";

  virtual function string get_type_name();
    return type_name;
  endfunction

  virtual task pre_send(); endtask
  virtual task post_send(); endtask

endclass : Driver_callback

class Driver extends uvm_component;

  `uvm_component_utils(Driver)

  `uvm_register_cb(Driver,Driver_callback)

  function new (string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

 
 virtual task run();
    
     repeat(2) begin 
         `uvm_do_callbacks(Driver,Driver_callback,pre_send())
         $display(" Driver: Started Driving the packet ...... %d",$time);  
         // Logic to drive the packet goes hear
         // let's consider that it takes 40 time units to drive a packet.
         #40; 
         $display(" Driver: Finished Driving the packet ...... %d",$time);   
         `uvm_do_callbacks(Driver,Driver_callback,post_send())
     end
  endtask

endclass
