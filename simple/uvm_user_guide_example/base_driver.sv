

class base_driver extends uvm_driver #(base_item);
  base_item b_item;
  virtual dut_if vif;

  `uvm_component_utils(base_driver)

  function new (string name = "base_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"VIF must be set for ", get_full_name(), ".vif"});
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item (b_item);
      drive_item(b_item);
      seq_item_port.item_done();
    end
  endtask

  task drive_item(base_item item);
    vif.addr  <= item.addr;
    vif.delay <= item.delay;
    @(posedge vif.clk);
    vif.data  <= item.data;
  endtask

endclass : base_driver 
