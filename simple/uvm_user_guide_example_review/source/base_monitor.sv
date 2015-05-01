  class base_monitor extends uvm_monitor;
    virtual dut_if vif;
    bit checks_enable = 1;
    bit coverage_enable = 1;
    // 
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
    beat_addr : coverpoint trans_collected.addr { option.auto_bin_max = 16; }
    beat_data_out : coverpoint trans_collected.data_out { option.auto_bin_max = 8; }
    beat_data_in : coverpoint trans_collected.data_in { option.auto_bin_max = 8; }
    beat_delay : coverpoint trans_collected.delay { option.auto_bin_max = 8; }
    //beat_addrXdelay: cross beat_addr, beat_delay;
    beat_addrXdata_out: cross beat_addr, beat_data_out;
    beat_addrXdata_in: cross beat_addr, beat_data_in;
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
      // Collect the data from the bus into trans_collected.
      collect_address_phase();
      collect_data_phase();

      if (coverage_enable) perform_transfer_coverage(); 
      if (checks_enable)   perform_transfer_checks();

      // scoreboard
      item_collected_port.write(trans_collected);
    end
  endtask : collect_transactions

  // Avoid delay without @(posedge vif.clk)
  virtual protected task collect_address_phase();
    if (vif.rd_en || vif.wr_en) begin
      trans_collected.addr = vif.addr;
      trans_collected.rd_en = vif.rd_en;
      trans_collected.wr_en = vif.wr_en;
    end
  endtask

  // Avoid delay without @(posedge vif.clk)
  virtual protected task collect_data_phase();
    if (vif.rd_en) begin
      trans_collected.data_out = vif.data_out;
      trans_collected.delay = vif.delay;
    end

    if (vif.wr_en) begin
      trans_collected.data_in = vif.data_in;
      trans_collected.delay = vif.delay;
    end

  endtask
  
  virtual protected function void perform_transfer_coverage();
    -> cov_transaction;
  endfunction : perform_transfer_coverage
  
  // Perform data checks on trans_collected.
  virtual protected function void perform_transfer_checks();
    if (trans_collected.wr_en && trans_collected.addr >= 128) 
      `uvm_error(get_type_name(), "readonly region write !");

    if (trans_collected.wr_en && trans_collected.rd_en)
      `uvm_error(get_type_name(), "read write overlaps!");

    if (trans_collected.rd_en && (^trans_collected.data_out === 1'bx))
      `uvm_error(get_type_name(), "memory read data has X or Z!");


  endfunction : perform_transfer_checks


endclass : base_monitor
