`include "uvm_macros.svh"
import uvm_pkg::*;


class my_comp1 extends uvm_component ;
  uvm_analysis_port#(int) my_port;

  `uvm_component_utils(my_comp1)

  function new(string name ,uvm_component parent=null);
    super.new(name,parent);
    my_port=new("my_port",this);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    for(int i=0 ; i<=100 ;i++)
    begin
      my_port.write(i);
    end

    phase.drop_objection(this);

  endtask
endclass

class my_comp2 extends uvm_component ;
  uvm_analysis_port#(int) my_port;

  `uvm_component_utils(my_comp2)
  function new(string name ,uvm_component parent=null);
    super.new(name,parent);
    my_port=new("my_port",this);

  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    for (int i=1 ; i<=100 ;i++)
    begin
      my_port.write(i);
    end
    phase.drop_objection(this);
  endtask 
endclass // my_comp2

class my_comp3 extends uvm_component ;

  `uvm_component_utils(my_comp3)

  uvm_in_order_built_in_comparator #(int) my_comparator;

  function new(string name ,uvm_component parent=null);
    super.new(name,parent); 
    my_comparator=new("my_in_order_builtin_comparator",this);

    // my_port1=new("my_port",this);
  endfunction 
endclass // my_comp3

class test extends uvm_test ;
  my_comp1 comp1;
  my_comp2 comp2 ;
  my_comp3 comp3;

  `uvm_component_utils(test)

  function new(string name ,uvm_component parent=null);
    super.new(name,parent);
  endfunction // new

  function void build_phase(uvm_phase phase);
    comp1=my_comp1::type_id::create("my_comp1",this);
    comp2=my_comp2::type_id::create("my_comp2",this);
    comp3=my_comp3::type_id::create("my_comp3",this);
  endfunction // build_phase

  function void connect_phase (uvm_phase phase);
    comp1.my_port.connect(comp3.my_comparator.after_export);
    comp2.my_port.connect(comp3.my_comparator.before_export);
  endfunction // connect_phase

  /*
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    phase.drop_objection(this);
  endtask // run_phase
  */

endclass // test

module top ;
  initial
    run_test("test");
  endmodule
