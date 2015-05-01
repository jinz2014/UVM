
  class driverB #(type T=uvm_object) extends uvm_driver;

    // parameterized classes must use the _param_utils version
    `uvm_component_param_utils(driverB #(T))

    // our packet type; this can be overridden via the factory
    T pkt;
    
    // component constructor
    function new (string name, uvm_component parent=null);
      super.new(name, parent);
    endfunction

    /*
    virtual function packet get_packet();
      packet p;

      //use the factory to generate a package
      p = packet::type_id::create("p", this);
     
      //randomize it
      void'(p.randomize());      
     
      return p; 
    endfunction
    */

   // get_type_name not implemented by macro for parameterized classes
   const static string type_name={"driverB #(", T::type_name, ")"};
    virtual function string get_type_name();
      return type_name;
    endfunction

    // using the factory allows pkt overrides from outside the class
    virtual function void build_phase(uvm_phase phase);
      pkt = packet::type_id::create("pkt", this);
    endfunction

    // confirm the type of the packet when printing
    virtual function void do_print(uvm_printer printer);
      printer.print_object("pkt", pkt);
    endfunction

  endclass

typedef driverB #(packet) B_driver;
