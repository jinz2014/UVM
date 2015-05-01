  class base_monitor extends uvm_monitor;
    virtual dut_if vif;
    bit checks_enable = 1;
    bit coverage_enable = 1;
    
    uvm_analysis_port #(base_item) item_collected_port;
    event cov_transaction;
  
  protected base_item trans_collected;
  
  `uvm_component_utils_begin(base_monitor)
  `uvm_field_int(checks_enable, UVM_ALL_ON)
  `uvm_field_int(coverage_enable, UVM_ALL_ON)
  `uvm_component_utils_end
  
  covergroup cov_trans @cov_transaction;
    option.per_instance = 1;
    // Coverage bins definition
    beat_addr : coverpoint trans_collected.addr {
      option.auto_bin_max = 16; }
    beat_data : coverpoint trans_collected.data {
      option.auto_bin_max = 8; }
    beat_delay : coverpoint trans_collected.delay {
      option.auto_bin_max = 8; }
    //beat_addrXdelay: cross beat_addr, beat_delay;
    beat_addrXdata: cross beat_addr, beat_data;
  endgroup : cov_trans
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    cov_trans = new();
    cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"VIF must be set for ", get_full_name(), ".vif"});
  endfunction
  
  virtual task run_phase(uvm_phase phase);
  fork
  collect_transactions(); // Spawn collector task.
  join
  endtask : run_phase
  
  virtual protected task collect_transactions();
    forever begin
      @(posedge vif.clk);
      // Collect the datax from the bus into trans_collected.
      if (coverage_enable) perform_transfer_coverage(); 
      if (checks_enable)   perform_transfer_checks();
      item_collected_port.write(trans_collected);
    end
  endtask : collect_transactions
  
  virtual protected function void perform_transfer_coverage();
    -> cov_transaction;
  endfunction : perform_transfer_coverage
  
  virtual protected function void perform_transfer_checks();
  // Perform data checks on trans_collected.
  endfunction : perform_transfer_checks
endclass : base_monitor
