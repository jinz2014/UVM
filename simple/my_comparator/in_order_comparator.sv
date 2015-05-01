//
// A sample usage of uvm_in_order_comparator
//
// Each of the compoments has an analysis port that is connected
// to the export of the comparator.
//
// In the run_phase, each of the compoments generates a stream of data to be compared
// with each other in the comparator.
//

`include "uvm_macros.svh"
import uvm_pkg::*;

class pkt extends uvm_object;
  int a;
  int b;

  function new(string name=" ");
    super.new(name);
  endfunction 

  function string convert2string();
    convert2string={$sformatf("a=%d",a), super.convert2string};
  endfunction
endclass

class my_comp1 extends uvm_component ;
  uvm_analysis_port#(pkt) my_port;
  pkt temp_pkt;

  `uvm_component_utils(my_comp1)

  function new(string name ,uvm_component parent=null);
    super.new(name,parent);
    my_port=new("my_port",this);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    for(int i=0 ; i<=10 ;i++)
    begin
      temp_pkt=new($sformatf("ins=%-d",i));
      temp_pkt.a=100;
      temp_pkt.b=8;
      my_port.write(temp_pkt);
    end

    phase.drop_objection(this);

  endtask
endclass

class my_comp2 extends uvm_component ;
  uvm_analysis_port#(pkt) my_port;
  pkt temp_pkt ;

  `uvm_component_utils(my_comp2)
  function new(string name ,uvm_component parent=null);
    super.new(name,parent);
    my_port=new("my_port",this);
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    for (int i=0 ; i<=10 ;i++)
    begin
      temp_pkt=new($sformatf("ins=%d",i));
      temp_pkt.a=100;
      temp_pkt.b=9;
      my_port.write(temp_pkt);
    end

    phase.drop_objection(this);
  endtask 
endclass // my_comp2

// if a uvm_object has more than one data member,
// then we may customize the uvm_class_converter to
// display all the data members and their values 
// instead of just one data member (default)
class uvm_class_converter #(type T = int);
  static function string convert2string (T a);
    convert2string = $sformatf("a=%0d b=%0d", a.a, a.b);
  endfunction
endclass

class uvm_class_comp #(type T = int);
  static function bit comp (T a, T b);
    comp = (a.a == b.a && a.b == b.b) ? 1 : 0;
  endfunction
endclass

class my_comp3 extends uvm_component ;

  `uvm_component_utils(my_comp3)

  uvm_in_order_comparator # (pkt,uvm_class_comp#(pkt),uvm_class_converter#(pkt)) my_comparator ;

  function new(string name ,uvm_component parent=null);
    super.new(name,parent); 
    my_comparator=new("my_comparator",this);
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

  // connect two analysis ports to two exports in the in-order comparator
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
