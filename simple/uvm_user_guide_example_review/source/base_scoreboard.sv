class base_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp #(base_item, base_scoreboard) item_collected_export; 

  `uvm_component_utils(base_scoreboard)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase (uvm_phase phase);
    item_collected_export = new("item_collected_export", this);
  endfunction

  virtual function void write (base_item item);
    dummy_verify(item);
  endfunction

  function void  dummy_verify(base_item item);
    //if (item.delay_kind == ZERO) 
      //assert (item.delay == 0);
  endfunction

  virtual function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Reporting scoreboard information...\n%s", this.sprint()), UVM_LOW)
  endfunction : report_phase

endclass : base_scoreboard 
