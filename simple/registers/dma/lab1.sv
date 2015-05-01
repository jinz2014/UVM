`include "uvm_macros.svh"

interface avmm_if (input bit clk);
  logic [31:0] addr;
  logic [31:0] write_data;
  logic [31:0] read_data;
  logic        write;
  logic        read;

  clocking mst_cb @ (posedge clk);
    output addr, write, write_data, read;
    input read_data;
  endclocking : mst_cb

  clocking slv_cb @ (posedge clk);
    input addr, write, write_data, read;
    output read_data;
  endclocking : slv_cb

  modport mst_mp (input clk, read_data, 
                  output addr, write, write_data, read );
  modport mst_sync_mp (clocking mst_cb);

  modport slv_mp (input clk, addr, write, write_data, read, 
                  output read_data);
  modport slv_sync_mp (clocking slv_cb);

endinterface : avmm_if 

package av_mm_pkg;
   import uvm_pkg::*;

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
      .individually_accessible(0)
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
      .individually_accessible(0)
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
      .individually_accessible(0)
    );
  endfunction : build

endclass : size_reg 


//----------------------------------------------
// Avalon slave interface
//----------------------------------------------

class av_mm_reg_block extends uvm_reg_block;
  `uvm_object_utils(av_mm_reg_block);

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
    
    r_da = device_addr_reg::type_id::create("r_da");
    r_da.configure(this, null);
    r_da.build();

    r_sz = size_reg::type_id::create("r_sz");
    r_sz.configure(this, null);
    r_sz.build();

    reg_map = create_map(
      .name("reg_map"), 
      .base_addr(32'h1000), 
      .n_bytes(4), 
      .endian(UVM_LITTLE_ENDIAN)
    );

    reg_map.add_reg(r_ha, 32'h0, "RW");
    reg_map.add_reg(r_da, 32'h4, "RW");
    reg_map.add_reg(r_sz, 32'h8, "RW");
    lock_model();

  endfunction : build

endclass : av_mm_reg_block


//--------------------------------------------
// 
//--------------------------------------------
class av_mm_transaction extends uvm_sequence_item;

  rand bit[31:0] addr;
  rand bit       wr_en;
  rand bit       rd_en;
  rand bit[31:0] wr_data;
  rand bit[31:0] rd_data;

  function new(string name = "");
    super.new(name);
  endfunction : new

  `uvm_object_utils_begin( av_mm_transaction )
    `uvm_field_int ( addr,     UVM_ALL_ON )
    `uvm_field_int ( wr_en,    UVM_ALL_ON )
    `uvm_field_int ( rd_en,    UVM_ALL_ON )
    `uvm_field_int ( wr_data,  UVM_ALL_ON )
    `uvm_field_int ( rd_data,  UVM_ALL_ON )
  `uvm_object_utils_end

endclass: av_mm_transaction

class av_mm_slv_transaction extends av_mm_transaction;
  `uvm_object_utils(av_mm_slv_transaction)
  constraint slv_addr { addr inside {32'h0, 32'h4, 32'h8}; }

  function new(string name = "av_mm_slv_transaction");
    super.new(name);
  endfunction : new

endclass: av_mm_slv_transaction


class av_mm_reg_adapter extends uvm_reg_adapter;
  `uvm_object_utils( av_mm_reg_adapter )
  function new(string name = "");
    super.new(name);
    supports_byte_enable = 0;
    provides_responses  = 0;
  endfunction : new

  virtual function uvm_sequence_item reg2bus ( const ref uvm_reg_bus_op rw);
    av_mm_transaction avmm_tx = av_mm_transaction::type_id::create("avmm_tx");

    if (rw.kind == UVM_WRITE) 
      avmm_tx.wr_en = 1;
    else
      avmm_tx.wr_en = 0;

    if (rw.kind == UVM_READ) 
      avmm_tx.rd_en = 1;
    else
      avmm_tx.rd_en = 0;

    if (rw.kind == UVM_WRITE) 
      avmm_tx.wr_data = rw.data;

    if (rw.kind == UVM_READ) 
      avmm_tx.rd_data = rw.data;

    avmm_tx.addr = rw.addr;

    return avmm_tx; 
  endfunction : reg2bus

  virtual function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    av_mm_transaction avmm_tx;
    if (!$cast(avmm_tx, bus_item)) begin
      `uvm_fatal(get_name(), "bus_item is not of the av_mm_transaction type");
      return;
    end
    if (avmm_tx.wr_en) 
      rw.kind = UVM_WRITE;

    if (avmm_tx.rd_en) 
      rw.kind = UVM_READ;

    if (avmm_tx.wr_en)
      rw.data = avmm_tx.wr_data;

    if (avmm_tx.rd_en)
      rw.data = avmm_tx.rd_data;

    rw.addr = avmm_tx.addr;

    rw.status = UVM_IS_OK;
  endfunction : bus2reg

endclass : av_mm_reg_adapter


//
// 
//
typedef uvm_reg_predictor #(av_mm_transaction) av_mm_reg_predictor;


//
// agent config
// + avmm_if
class av_mm_agent_config extends uvm_object;
  `uvm_object_utils(av_mm_agent_config )
  uvm_active_passive_enum active = UVM_ACTIVE;
  bit has_cov_sub = 1;

  virtual avmm_if avmm_vif;

  function new (string name = "");
    super.new(name);
  endfunction : new
endclass : av_mm_agent_config 


//
// + av_mm_agent_config
// + avmm_reg_block
class av_mm_env_config extends uvm_object;
  `uvm_object_utils(av_mm_env_config )
  bit has_avmm_agent = 1;
  bit has_avmm_sb    = 1;  // scoreboard
  bit has_avmm_fc    = 1;  // functional coverage

  av_mm_agent_config  avmm_agent_cfg;
  av_mm_reg_block     avmm_reg_blk;

  function new (string name = "");
    super.new(name);
  endfunction : new
endclass : av_mm_env_config 

//
//
//

class av_mm_sequence extends uvm_sequence #(av_mm_transaction);
  `uvm_object_utils(av_mm_sequence )

  function new (string name = "");
    super.new(name);
  endfunction : new

  task body();
    av_mm_transaction avmm_tx;
    avmm_tx = av_mm_transaction::type_id::create("avmm_tx"); 
    start_item(avmm_tx);
    avmm_tx.randomize();
    finish_item(avmm_tx);
  endtask : body

endclass : av_mm_sequence 

class av_mm_reg_test_sequence extends uvm_reg_sequence;
   `uvm_object_utils( av_mm_reg_test_sequence )

   function new( string name = "" );
      super.new( name );
   endfunction: new

   virtual task body();
      av_mm_reg_block       avmm_reg_blk;
      uvm_status_e               status;
      uvm_reg_data_t             value;

      $cast( avmm_reg_blk, model );
      
      //--------------------------------------------------------------------------
      // register read and write 
      // the waveform should shows the read and write transfers at DUT interface
      // But there is no check on the read and write values
      //--------------------------------------------------------------------------
      write_reg( avmm_reg_blk.r_ha, status, 32'h4000_0000 );
      read_reg( avmm_reg_blk.r_ha, status, value );

      write_reg( avmm_reg_blk.r_da, status, 32'h0400_0000 );
      read_reg( avmm_reg_blk.r_da, status, value );

      write_reg( avmm_reg_blk.r_sz, status, 32'h0040);
      $display("r_sz.get() = %h", avmm_reg_blk.r_sz.get());  // 0
      $display("r_sz.get() = %h", avmm_reg_blk.r_sz.get());  // 0
      read_reg( avmm_reg_blk.r_sz, status, value );
      read_reg( avmm_reg_blk.r_sz, status, value );
      $display("value = %h r_sz.get() = %h", value, avmm_reg_blk.r_sz.get());  // 0, 40

      //--------------------------------------------------------------------------
      // register set and update
      // expect no DUT transaction as defined by update()
      //--------------------------------------------------------------------------
      avmm_reg_blk.r_ha.set(32'h4000_0000);
      update_reg(avmm_reg_blk.r_ha, status, UVM_FRONTDOOR );

      //--------------------------------------------------------------------------
      // register set/update/mirror
      // expect DUT transaction 
      // checks if the read_data from DUT matches the mirrored value (32'h8000_0000)
      //
      // Mirror doesn't consider the read latency ...
      //
      // Alternative functions
      // model.regA.update(status, value, .parent(this));
      // model.regA.mirror(status, UVM_CHECK, .parent(this));
      //--------------------------------------------------------------------------
      avmm_reg_blk.r_ha.set(32'h8000_0000);
      update_reg(avmm_reg_blk.r_ha, status, UVM_FRONTDOOR );
      $display("get r_ha = %h", avmm_reg_blk.r_ha.get());
      //mirror_reg(avmm_reg_blk.r_ha, status, UVM_CHECK);
      //$display("get r_ha = %h", avmm_reg_blk.r_ha.get());

      avmm_reg_blk.r_da.set(32'h0800_0000);
      update_reg(avmm_reg_blk.r_da, status, UVM_FRONTDOOR );
      $display("get r_da = %h", avmm_reg_blk.r_da.get());
      //mirror_reg(avmm_reg_blk.r_da, status, UVM_CHECK);

      avmm_reg_blk.r_sz.set(32'h0000_0080);
      update_reg(avmm_reg_blk.r_sz, status, UVM_FRONTDOOR );
      //mirror_reg(avmm_reg_blk.r_sz, status, UVM_CHECK);

      //--------------------------------------------------------------------------
      // peek/poke
      // Using the peek() and poke() methods reads or writes directly to the register respectively, which
      // bypasses the physical interface. The mirrored value is then updated to reflect the actual sampled or deposited
      // value in the register after the observed transactions.
      //--------------------------------------------------------------------------
      //poke_reg( avmm_reg_blk.r_ha, status, 32'h6000_0000 );
      //peek_reg( avmm_reg_blk.r_ha, status, value );

      // register set/get

   endtask: body
     
endclass: av_mm_reg_test_sequence


typedef uvm_sequencer #(av_mm_transaction) av_mm_sequencer;

class av_mm_driver extends uvm_driver #(av_mm_transaction);
  `uvm_component_utils(av_mm_driver)
  virtual avmm_if avmm_vif;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  task main_phase(uvm_phase phase);
    av_mm_transaction avmm_tx;

    forever begin
      @avmm_vif.mst_cb;
      avmm_vif.mst_cb.write <= 0;
      avmm_vif.mst_cb.read  <= 0;

      seq_item_port.get_next_item(avmm_tx);

      @avmm_vif.mst_cb;
      avmm_vif.mst_cb.addr       <= avmm_tx.addr;
      avmm_vif.mst_cb.write      <= avmm_tx.wr_en;
      avmm_vif.mst_cb.read       <= avmm_tx.rd_en;
      avmm_vif.mst_cb.write_data <= avmm_tx.wr_data;

      seq_item_port.item_done();
    end
  endtask :  main_phase

endclass : av_mm_driver 

//
// Monitor's DUT transactions ( and save the transactions in a transaction item

class av_mm_monitor extends uvm_monitor;
  `uvm_component_utils(av_mm_monitor)

  virtual avmm_if avmm_vif;
  uvm_analysis_port#( av_mm_transaction ) avmm_ap;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    avmm_ap = new( .name( "avmm_ap" ), .parent( this ) );
  endfunction : build_phase

  task main_phase(uvm_phase phase);
    av_mm_transaction avmm_tx;

    forever begin
      @avmm_vif.slv_cb;
      if (avmm_vif.read) begin
        avmm_tx       = av_mm_transaction::type_id::create("avmm_tx");
        avmm_tx.rd_en = 1;
        avmm_tx.wr_en = 0;
        avmm_tx.addr  = avmm_vif.addr;

        @avmm_vif.slv_cb;
        avmm_tx.rd_data = avmm_vif.read_data;

        avmm_ap.write(avmm_tx);
      end

      if (avmm_vif.write) begin
        avmm_tx = av_mm_transaction::type_id::create("avmm_tx");
        avmm_tx.rd_en   = 0;
        avmm_tx.wr_en   = 1;
        avmm_tx.addr    = avmm_vif.addr;
        avmm_tx.wr_data = avmm_vif.write_data;

        avmm_ap.write(avmm_tx);
      end

      /*
      if (avmm_vif.slv_cb.write) begin
        avmm_tx = av_mm_transaction::type_id::create("avmm_tx");
        avmm_tx.wr_en   = 1;
        avmm_tx.addr    = avmm_vif.slv_cb.addr;
        avmm_tx.wr_data = avmm_vif.slv_cb.write_data;

        avmm_ap.write(avmm_tx);
      end
      */
    end
  endtask :  main_phase

endclass : av_mm_monitor 

/*
class  av_mm_fc_subscriber extends uvm_subscriber #(av_mm_transaction);
  `uvm_component_utils( av_mm_fc_subscriber )
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
endclass : av_mm_fc_subscriber  

class   av_mm_scoreboard  extends uvm_scoreboard;
  `uvm_component_utils( av_mm_scoreboard)
  uvm_analysis_export #(av_mm_transaction)  avmm_analysis_export;
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
endclass : av_mm_scoreboard     
*/
//----------------------------------------------------------------------------------------
// agent
//
// db set 
//   agent_cfg 
// assign
//   monitor's virtual_if with agent_cfg.if
//   driver's virtual_if with agent_cfg.if
// create 
//   sequencer
//   driver
//   monitor
//   reg_adapter
//   an analysis port (ap)
// connect
//   driver-sequencer
//   monitor's ap - ap
//----------------------------------------------------------------------------------------
class av_mm_agent extends uvm_agent;
  `uvm_component_utils( av_mm_agent)
  uvm_analysis_port #(av_mm_transaction) avmm_ap;

  av_mm_agent_config  avmm_agent_cfg;
  av_mm_sequencer     avmm_seqr;
  av_mm_driver        avmm_drvr;
  av_mm_monitor       avmm_mon;
  av_mm_reg_adapter   avmm_reg_adapter;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if ( ! uvm_config_db#( av_mm_agent_config )::get( .cntxt( this ), 
                                                           .inst_name ( "" ), 
                                                           .field_name( "avmm_agent_cfg" ),
                                                           .value( avmm_agent_cfg ))) begin
       `uvm_error( "avmm_agent", "avmm_agent_cfg not found" )
    end

    avmm_ap = new( .name( "avmm_ap" ), .parent( this ) );

    if ( avmm_agent_cfg.active == UVM_ACTIVE ) begin
       avmm_seqr = av_mm_sequencer::type_id::create( .name( "avmm_seqr" ), .parent( this ) );
       avmm_drvr = av_mm_driver::type_id::create( .name( "avmm_drvr" ), .parent( this ) );
    end
    avmm_mon = av_mm_monitor::type_id::create( .name( "avmm_mon" ), .parent( this ) );
    avmm_reg_adapter = av_mm_reg_adapter::type_id::create( .name( "avmm_reg_adapter" ), .parent( this ) );
  endfunction: build_phase

  function void connect_phase( uvm_phase phase );
    
    super.connect_phase( phase );

    // i/f is set with agent configure component
    avmm_mon.avmm_vif = avmm_agent_cfg.avmm_vif;

    if ( avmm_agent_cfg.active == UVM_ACTIVE ) begin
       avmm_drvr.seq_item_port.connect( avmm_seqr.seq_item_export );
       avmm_drvr.avmm_vif = avmm_agent_cfg.avmm_vif;
    end
    avmm_mon.avmm_ap.connect( avmm_ap );
  endfunction: connect_phase

endclass : av_mm_agent

//----------------------------------------------------------------------------------------
// env
//
// db set 
//   env_cfg 
// assign
//   env_cfg's reg_block.reg_map.set_sequencer
//   env_cfg's reg_block.reg_map.set_auto_predict
//   reg_predictor.map = env_cfg's reg_block.reg_map
//   reg_predictor.adapter = reg_adapter
// create 
//   agent
//   reg_predictor
//   sb
//   fc
// connect
//   agent's ap - fc's export
//   agent's ap - sb's export
//   agent's ap - reg_predictor.bus_in
//----------------------------------------------------------------------------------------
class av_mm_env extends uvm_env;
   `uvm_component_utils( av_mm_env )

   av_mm_env_config    avmm_env_cfg;
   av_mm_agent         avmm_agent;
   //av_mm_fc_subscriber avmm_fc_sub;
   //av_mm_scoreboard    avmm_sb;
   av_mm_reg_predictor avmm_reg_predictor;

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void build_phase( uvm_phase phase );
      super.build_phase( phase );
      if ( ! uvm_config_db#( av_mm_env_config )::get
           ( .cntxt( this ),
             .inst_name( "" ),
             .field_name( "avmm_env_cfg" ),
             .value( avmm_env_cfg ) ) ) begin
         `uvm_fatal( get_name(), "avmm_env_cfg not found" )
      end

      uvm_config_db#( av_mm_agent_config )::set( .cntxt( this ), 
                                                      .inst_name( "avmm_agent*" ),
                                                      .field_name( "avmm_agent_cfg" ),
                                                      .value( avmm_env_cfg.avmm_agent_cfg ) );
      avmm_agent = av_mm_agent::type_id::create( .name( "avmm_agent" ), .parent( this ) );
      avmm_reg_predictor = av_mm_reg_predictor::type_id::create( .name( "avmm_reg_predictor" ), .parent( this ) );
      /*
      if ( avmm_env_cfg.has_avmm_sb ) begin
        avmm_sb = av_mm_scoreboard::type_id::create( .name( "avmm_sb" ), .parent( this ) );
      end
      if ( avmm_env_cfg.has_avmm_fc ) begin
        avmm_fc_sub = av_mm_fc_subscriber::type_id::create( .name( "avmm_fc_sub" ), .parent( this ) );
      end
      */
    endfunction: build_phase

   function void connect_phase( uvm_phase phase );
      super.connect_phase( phase );

      /*
      if ( avmm_env_cfg.has_avmm_sb ) begin
        avmm_agent.avmm_ap.connect( avmm_sb.avmm_analysis_export );
      end

      if ( avmm_env_cfg.has_avmm_fc ) begin
        avmm_agent.avmm_ap.connect( avmm_fc_sub.analysis_export );
      end
      */

      if ( avmm_env_cfg.avmm_reg_blk.get_parent() == null ) begin // if the top-level env
         avmm_env_cfg.avmm_reg_blk.reg_map.set_sequencer( .sequencer( avmm_agent.avmm_seqr ),
                                                        .adapter( avmm_agent.avmm_reg_adapter ) );
      end
      avmm_env_cfg.avmm_reg_blk.reg_map.set_auto_predict( .on( 0 ) );

      avmm_reg_predictor.map     = avmm_env_cfg.avmm_reg_blk.reg_map;
      avmm_reg_predictor.adapter = avmm_agent.avmm_reg_adapter;
      avmm_agent.avmm_ap.connect( avmm_reg_predictor.bus_in );
   endfunction: connect_phase

endclass : av_mm_env

//------------------------------------------------------------------------------
// Class: avmm_base_test
//------------------------------------------------------------------------------

class av_mm_base_test extends uvm_test;
   `uvm_component_utils( av_mm_base_test )

   av_mm_env          avmm_env;
   av_mm_env_config   avmm_env_cfg;
   av_mm_agent_config avmm_agent_cfg;
   av_mm_reg_block    avmm_reg_blk;

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      avmm_reg_blk = av_mm_reg_block::type_id::create( "avmm_reg_blk" );
      avmm_reg_blk.build();

      avmm_agent_cfg = av_mm_agent_config::type_id::create( "avmm_agent_cfg" );

      avmm_env_cfg = av_mm_env_config::type_id::create( "avmm_env_cfg" );
      avmm_env_cfg.avmm_reg_blk = avmm_reg_blk;
      avmm_env_cfg.avmm_agent_cfg = avmm_agent_cfg;
      
      if ( ! uvm_config_db#( virtual avmm_if )::get( .cntxt( this ),
                                                           .inst_name( "" ),
                                                           .field_name( "avmm_if" ),
                                                           .value( avmm_agent_cfg.avmm_vif ))) begin
         `uvm_error( "avmm_test", "avmm_if not found" )
      end


      uvm_config_db#(av_mm_env_config)::set( .cntxt( null ),
                                                  .inst_name( "*" ),
                                                  .field_name( "avmm_env_cfg" ),
                                                  .value( avmm_env_cfg ) );
      avmm_env = av_mm_env::type_id::create( .name( "avmm_env" ), 
                                                .parent( this ) );
   endfunction: build_phase

   virtual function void start_of_simulation_phase( uvm_phase phase );
      super.start_of_simulation_phase( phase );
      uvm_top.print_topology();
   endfunction: start_of_simulation_phase

endclass : av_mm_base_test

//------------------------------------------------------------------------------
// Class: avmm_reg_test
// + avmm_reg_sequence 
//  + avmm_reg_sequence.model
//  + avmm_reg_sequence.start
//------------------------------------------------------------------------------

class av_mm_reg_test extends av_mm_base_test;
   `uvm_component_utils( av_mm_reg_test )

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   task main_phase( uvm_phase phase );
      av_mm_reg_test_sequence avmm_reg_seq;

      phase.raise_objection( .obj( this ) );
      avmm_reg_seq = av_mm_reg_test_sequence::type_id::create( .name( "avmm_reg_seq" ) );
      avmm_reg_seq.model = avmm_reg_blk;
      avmm_reg_seq.start( .sequencer( avmm_env.avmm_agent.avmm_seqr ) );
      
      #100ns;
      phase.drop_objection( .obj( this ) );
      
   endtask: main_phase
endclass : av_mm_reg_test

//------------------------------------------------------------------------------
// Class: avmm_reg_hw_reset_test
//
// + uvm_reg_hw_reset_seq 
//------------------------------------------------------------------------------

class av_mm_reg_hw_reset_test extends av_mm_base_test;
   `uvm_component_utils( av_mm_reg_hw_reset_test )

   function new( string name, uvm_component parent );
      super.new( name, parent );
   endfunction: new

   task main_phase( uvm_phase phase );
      uvm_reg_hw_reset_seq reg_hw_reset_seq;

      phase.raise_objection( .obj( this ) );
      reg_hw_reset_seq = uvm_reg_hw_reset_seq::type_id::create( .name( "reg_hw_reset_seq" ) );
      reg_hw_reset_seq.model = avmm_reg_blk;
      reg_hw_reset_seq.start( .sequencer( avmm_env.avmm_agent.avmm_seqr ) );
      
      phase.drop_objection( .obj( this ) );
   endtask: main_phase
endclass : av_mm_reg_hw_reset_test

endpackage: av_mm_pkg

//------------------------------------------------------------------------------
// Module: This is the DUT.
//------------------------------------------------------------------------------

module dut( avmm_if.slv_mp avmm_slv_if );
   import av_mm_pkg::*;

   reg [31:0] host_addr;
   reg [31:0] device_addr;
   reg [31:0] size_addr;

   always @ ( posedge avmm_slv_if.clk ) begin
     if (avmm_slv_if.addr[4:0] == 5'h0 && avmm_slv_if.write) begin
       host_addr <= avmm_slv_if.write_data;
     end
   end

   always @ ( posedge avmm_slv_if.clk ) begin
     if (avmm_slv_if.addr[4:0] == 5'h4 && avmm_slv_if.write) begin
       device_addr <= avmm_slv_if.write_data;
     end
   end

   always @ ( posedge avmm_slv_if.clk ) begin
     if (avmm_slv_if.addr[4:0] == 5'h8 && avmm_slv_if.write) begin
       size_addr <= avmm_slv_if.write_data;
     end
   end

   always @ ( posedge avmm_slv_if.clk ) begin
     if ( avmm_slv_if.read) begin
       case (avmm_slv_if.addr[4:0])
         5'h0: avmm_slv_if.read_data <= host_addr;
         5'h4: avmm_slv_if.read_data <= device_addr;
         5'h8: avmm_slv_if.read_data <= size_addr;
         default: avmm_slv_if.read_data <= 0;
       endcase
     end
   end

endmodule: dut

//------------------------------------------------------------------------------
// Module: top
//------------------------------------------------------------------------------

module top;
   import uvm_pkg::*;

   reg clk;
   
   avmm_if     avmm_if( clk );
   dut         dut( avmm_if );

   initial begin
      clk = 0;
      #5ns ;
      forever #5ns clk = ! clk;
   end

   initial begin
      uvm_config_db#( virtual avmm_if )::set( .cntxt( null ), 
                                                    .inst_name( "uvm_test_top" ),
                                                    .field_name( "avmm_if" ),
                                                    .value( avmm_if ) );
      run_test();
   end
endmodule: top

