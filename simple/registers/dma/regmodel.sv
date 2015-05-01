//
// This is a simple register model to get started ...
//
class host_addr_reg extends uvm_reg;
  `uvm_object_utils(host_addr_reg)

  uvm_reg_field addr;
  function new (string name = "HA");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  virtual function void build ();
    addr = uvm_reg_field::type_id::create("value");
    addr.configure(
      .parent(this), 
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset("32'h0"),
      .has_reset(1),
      .is_rand(0),
      individually_accessible(0)
    );
  endfunction : build

endclass : host_addr_reg 

class device_addr_reg extends uvm_reg;
  `uvm_object_utils(device_addr_reg)

  uvm_reg_field addr;
  function new (string name = "DA");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  virtual function void build();
    addr = uvm_reg_field::type_id::create("value");
    addr.configure(
      .parent(this), 
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset("32'h0"),
      .has_reset(1),
      .is_rand(0),
      individually_accessible(0)
    );
  endfunction : build

endclass : device_addr_reg 

class size_reg extends uvm_reg;
  `uvm_object_utils(size_reg)

  uvm_reg_field addr;
  function new (string name = "SZ");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction : new

  virtual function void build();
    addr = uvm_reg_field::type_id::create("value");
    addr.configure(
      .parent(this), 
      .size(32),
      .lsb_pos(0),
      .access("RW"),
      .volatile(0),
      .reset("32'h0"),
      .has_reset(1),
      .is_rand(0),
      individually_accessible(0)
    );
  endfunction : build

endclass : size_reg 


//----------------------------------------------
// Avalon slave interface
//----------------------------------------------

class avmm_reg_block extends uvm_reg_block;
  `uvm_object_utils(avmm_reg_block);

  host_addr_reg   r_ha;
  device_addr_reg r_da;
  size_reg        r_sz;

  uvm_reg_map     reg_map;

  function new (string name = "AVL_BK");
    super.new(name, UVM_NO_COVERAGE);
  endfunction : new

  virtual function void build();
    r_ha = host_addr_reg::type_id::create("r_ha");
    r_ha.configure(this, null);
    r_ha.build();
    
    r_da = host_addr_reg::type_id::create("r_da");
    r_da.configure(this, null);
    r_da.build();

    r_sz = host_addr_reg::type_id::create("r_sz");
    r_sz.configure(this, null);
    r_sz.build();

    reg_map = create_map(
      .name("reg_map"), 
      .base_addr(0), 
      .n_bytes(4), 
      .endian(UVM_LITTLE_ENDIAN)
    );

    reg_map.add_reg(r_ha, 'h0', "RW");
    reg_map.add_reg(r_da, 'h4', "RW");
    reg_map.add_reg(r_sz, 'h8', "RW");
    lock_model();

  endfunction : build

endclass : avmm_reg_block


