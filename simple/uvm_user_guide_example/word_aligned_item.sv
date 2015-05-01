class word_aligned_item extends base_item;

  constraint word_aligned_addr { addr[1:0] == 2'b00; }

  `uvm_object_utils(word_aligned_item)

  function new (string name = "word_aligned_item");
    super.new(name);
  endfunction 

endclass : word_aligned_item 


class word_aligned_zero_item extends base_item;

  constraint word_aligned_addr { delay_kind == ZERO; }

  `uvm_object_utils(word_aligned_item)

  function new (string name = "word_aligned_zero_item");
    super.new(name);
  endfunction 

endclass : word_aligned_zero_item 


class word_aligned_short_item extends word_aligned_item;

  constraint word_aligned_addr { delay_kind == SHORT; }

  `uvm_object_utils(word_aligned_short_item)

  function new (string name = "word_aligned_short_item");
    super.new(name);
  endfunction 

endclass : word_aligned_short_item 


class word_aligned_medium_item extends word_aligned_item;

  constraint word_aligned_addr { delay_kind == MEDIUM; }

  `uvm_object_utils(word_aligned_medium_item)

  function new (string name = "word_aligned_medium_item");
    super.new(name);
  endfunction 

endclass : word_aligned_medium_item 



