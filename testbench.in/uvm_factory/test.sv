////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s              UVM Tutorial            s////
////s                                      s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////

class test1 extends uvm_test;

   `uvm_component_utils(test1)
    env t_env;
 
    function new (string name="test1", uvm_component parent=null);
        super.new (name, parent);
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

