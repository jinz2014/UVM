  class packet extends uvm_object;
    rand int addr;
    rand int data;

    //Use the macro in a class to implement factory registration along with other
    //utilities (create, get_type_name). For only factory registration, use
    //the macro `uvm_object_registry(packet,"packet").
    `uvm_object_utils(packet)
    
    //Base constraints
    constraint c1 { addr inside { ['h0:'h40], ['h100:'h200], ['h1000: 'h1fff], ['h4000: 'h4fff] }; }
    constraint c2 { (addr <= 'h40) -> (data inside { [10:20] } ); }
    constraint c3 { (addr >= 'h100 && addr <= 'h200) -> (data inside { [100:200] } ); }
    constraint c4 { (addr >= 'h1000 && addr <= 'h1fff) -> (data inside { [300:400] } ); }
    constraint c5 { (addr >= 'h4000 && addr <= 'h4fff) -> (data inside { [600:800] } ); }

    //do printing, comparing, etc. These functions can also be automated inside
    //the `uvm_object_utils_begin/end macros if desired. Below show the manual 
    //approach.
    function void do_print(uvm_printer printer);
      printer.print_field("addr", addr, $bits(addr));
      printer.print_field("data", data, $bits(data));
    endfunction
    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      packet rhs_;
      if(rhs==null || !$cast(rhs_, rhs)) return 0;
      do_compare = 1;  
      do_compare &= comparer.compare_field("addr", addr, rhs_.addr, $bits(addr));
      do_compare &= comparer.compare_field("data", data, rhs_.data, $bits(data));
    endfunction
    function void do_copy(uvm_object rhs);
      packet rhs_;
      if(rhs==null || !$cast(rhs_, rhs)) return;
      addr = rhs_.addr;
      data = rhs_.data;
    endfunction
  endclass : packet 

  class my_packet extends packet;
    constraint ct10 { addr >= 0 && addr <= 10; }

    //Use the macro in a class to implement factory registration along with other
    //utilities (create, get_type_name).
    `uvm_object_utils(my_packet)
  endclass : my_packet
