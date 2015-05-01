//
// To create a data item:
//
// 1 identify app-specific properties, constraints, tasks and functions
// 2 derive the item from uvm_sequence_item base class (or a derivative of
// it)
// 3 define a constructor for the item
// 4 add control fields
// 5 use UVM field macros to enable printing,copying, comparing
// 6 keep in mind what range of values are often used or which categories
// are of interest to that item


// Q1 address (range), data, delay



typedef enum {ZERO, SHORT, MEDIUM, LARGE, MAX} base_item_delay_e;
typedef enum {READ, WRITE, NOP} base_item_control_e;

class base_item extends uvm_sequence_item;
  rand int unsigned addr;
  rand int unsigned data_in;
  rand int unsigned data_out;
  rand int unsigned delay;
  rand base_item_delay_e delay_kind;
  rand base_item_control_e control_kind;

  // collect i/f rd and write enable signals
  bit rd_en;
  bit wr_en;

  constraint addr_order_c { solve control_kind before addr; }
  constraint addr_c {
    (control_kind == WRITE) -> addr inside { [0:127] };
    //(control_kind == READ ) -> addr inside { [128:255] };
    addr >= 0; addr <= 255;
  }

  //constraint data_c { data < 32'h1000; }
  constraint delay_order_c { solve delay_kind before delay; }
  constraint delay_c {
    (delay_kind == ZERO)   -> delay == 0;
    (delay_kind == SHORT)  -> delay inside { [1:10] };
    (delay_kind == MEDIUM) -> delay inside { [11:99] };
    (delay_kind == LARGE)  -> delay inside{ [100:999] };
    (delay_kind == MAX)    -> delay == 1000;
    delay >= 0; delay <= 1000; 
  }


  // uvm auto macros after declaring the class fields
  `uvm_object_utils_begin(base_item)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data_in, UVM_ALL_ON)
    `uvm_field_int(data_out, UVM_ALL_ON)
    `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_field_int(rd_en, UVM_ALL_ON)
    `uvm_field_int(wr_en, UVM_ALL_ON)
    `uvm_field_enum     (base_item_control_e, control_kind, UVM_ALL_ON)
    `uvm_field_enum     (base_item_delay_e, delay_kind, UVM_ALL_ON)
  `uvm_object_utils_end

  // constructor
  function new (string name = "base_item");
    super.new(name);
  endfunction 

endclass : base_item 


