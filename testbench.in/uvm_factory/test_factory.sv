////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s              UVM Tutorial            s////
////s                                      s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////

class driver_2 extends driver;

   `uvm_component_utils(driver_2)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass

class monitor_2 extends monitor;

   `uvm_component_utils(monitor_2)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass


class test_factory extends uvm_test;

   `uvm_component_utils(test_factory)
    env t_env;
 
    function new (string name="test1", uvm_component parent=null);
        super.new (name, parent);
        factory.set_type_override_by_type(driver::get_type(),driver_2::get_type(),"*");
        factory.set_type_override_by_name("monitor","monitor_2","*");
        factory.print();
        t_env = new("t_env",this);
    endfunction : new 


    function void end_of_elaboration();
        uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW);
        print();
    endfunction : end_of_elaboration
 
    task run ();
        #1000;
        global_stop_request();
    endtask : run


endclass

