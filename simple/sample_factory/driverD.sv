class driverD1 #(type T=uvm_object) extends driverB #(T);

  // parameterized classes must use the _param_utils version
  `uvm_component_param_utils(driverD1 #(T))

  // our packet type; this can be overridden via the factory
  T pkt;
  
  // component constructor
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

 // get_type_name not implemented by macro for parameterized classes
 const static string type_name={"driverD1 #(", T::type_name, ")"};
  virtual function string get_type_name();
    return type_name;
  endfunction

endclass : driverD1

class driverD2 #(type T=uvm_object) extends driverB #(T);

  // parameterized classes must use the _param_utils version
  `uvm_component_param_utils(driverD2 #(T))

  // our packet type; this can be overridden via the factory
  T pkt;
  
  // component constructor
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction

 // get_type_name not implemented by macro for parameterized classes
 const static string type_name={"driverD2 #(", T::type_name, ")"};
  virtual function string get_type_name();
    return type_name;
  endfunction

endclass : driverD2


typedef driverD1 #(packet) D1_driver;
typedef driverD2 #(packet) D2_driver;

