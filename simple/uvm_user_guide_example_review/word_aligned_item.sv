class word_aligned_item extends base_item;

  constraint word_aligned_addr { addr[1:0] == 2'b00; }

  `uvm_object_utils(word_aligned_item)

  function new (string name = "word_aligned_item");
    super.new(name);
  endfunction 

endclass : word_aligned_item 


class word_aligned_zero_item extends word_aligned_item;

  constraint zero_delay { delay_kind == ZERO; }

  `uvm_object_utils(word_aligned_zero_item)

  function new (string name = "word_aligned_zero_item");
    super.new(name);
  endfunction 

endclass : word_aligned_zero_item 


class word_aligned_short_item extends word_aligned_item;

  constraint short_delay { delay_kind == SHORT; }

  `uvm_object_utils(word_aligned_short_item)

  function new (string name = "word_aligned_short_item");
    super.new(name);
  endfunction 

endclass : word_aligned_short_item 


class word_aligned_medium_item extends word_aligned_item;

  constraint medium_delay { delay_kind == MEDIUM; }

  `uvm_object_utils(word_aligned_medium_item)

  function new (string name = "word_aligned_medium_item");
    super.new(name);
  endfunction 

endclass : word_aligned_medium_item 


//---------------------------------------------------------------
// error injection
//---------------------------------------------------------------

class word_aligned_error_item extends base_item;

  constraint control_c { control_kind == WRITE; }
  constraint addr_c    { addr inside {[128:255]}; }

  `uvm_object_utils(word_aligned_error_item)

  function new (string name = "word_aligned_error_item");
    super.new(name);
  endfunction 

endclass : word_aligned_error_item 

