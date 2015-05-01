/*-------------------------------------------------------------------------
File name   : tb_apb_subsystem.v 
Title       : Top level file for the testbench 
Project     : APB subsystem
Created     : November 2010
Description : This is top level file which instantiate the dut apb_subsystem
              It also has the assertion module which checks for the power down 
              and power up.

Notes       : 
-------------------------------------------------------------------------*/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

`timescale 1ns/10ps


// ========================================================
//  Example for an hdl top file for a DUT Slave. 
//  It contains the following steps :
//
//  1.Environments constants (Data and Address width)
//
//  2.SHARED signals definitions
//
//  3.DUT signals (slave) definitions
//
//  4.UVC AGENTS signals definitions
//
//  5.DUT Instantiation
//
//  6.MUXES Instantiations
//
//  7.Initialization (Reset, clock)
//
// =========================================================


// Environment Constants
`define AHB_DATA_WIDTH          32              // AHB bus data width [32/64]
`define AHB_ADDR_WIDTH          32              // AHB bus address width [32/64]
`define AHB_DATA_MAX_BIT        31              // MUST BE: AHB_DATA_WIDTH - 1
`define AHB_ADDRESS_MAX_BIT     31              // MUST BE: AHB_ADDR_WIDTH - 1

`define DEFAULT_HWDATA_VALUE    {`AHB_DATA_WIDTH{1'b0}} // All zeros
`define DEFAULT_HADDR_VALUE     {`AHB_ADDR_WIDTH{1'b0}} // All zeros
`define DEFAULT_HTRANS_VALUE    2'b00                   // IDLE
`define DEFAULT_HWRITE_VALUE    1'b0                    // READ
`define DEFAULT_HBURST_VALUE    3'b000                  // SINGLE
`define DEFAULT_HSIZE_VALUE     3'b010                  // WORD
`define DEFAULT_HPROT_VALUE     4'b0011                 // NON_CACHE, NON_BUFFERABLE, PRIVALIGED, DATA
`define DEFAULT_HGRANT_VALUE    1'b0                    // NOT GRANTED
`define DEFAULT_HBUSREQ_VALUE   1'b0                    // MASTER IS NOT REQUESTING
`define DEFAULT_HLOCK_VALUE     1'b0                    // MASTER IS NOT LOCKING


`define DEFAULT_HREADY_VALUE    1'b1                    // Ready Asserted
`define DEFAULT_HRESP_VALUE     2'b00                   // OKAY Response
`define DEFAULT_HRDATA_VALUE    {`AHB_DATA_WIDTH{1'b0}} // All zeros
`define DEFAULT_HSPLIT_VALUE     16'b0000000000000000   // No splits

// TestBench Module
module tb_apb_subsystem;

  // Clock
  reg specman_hclk;
  
  // Reset
  reg hresetn;
  reg hreset_n;
  
  // post-mux from master mux
  wire [`AHB_DATA_MAX_BIT:0] hwdata;
  wire [`AHB_ADDRESS_MAX_BIT:0] haddr;
  wire [1:0]  htrans;
  wire [2:0]  hburst;
  wire [2:0]  hsize;
  wire [3:0]  hprot;
  wire hwrite;

  // post-mux from slave mux
  wire        hready;
  wire [1:0]  hresp;
  wire  [15:0] hsplit;
  wire [`AHB_DATA_MAX_BIT:0] hrdata;
  
  // ====================================
  // ====================================
  // DUT signals
  // ====================================
  // ====================================

  // ------------------------------------
  // DUT Slave
  // ------------------------------------

  // S0
  wire [1:0]                  hresp0;
  wire                        hready0; 
  wire [`AHB_DATA_MAX_BIT:0]  hrdata0; 
  wire [15:0]                 hsplit0 = 1'b0; // no split required

  // =============================
  // =============================
  // UVC AGENTS signals
  // =============================
  // =============================

  // -----------------------------
  // UVC Masters
  // -----------------------------

  // M0
  reg 	      hbusreq0;
  reg 	      hlock0;
  reg 	      hgrant0;
  reg [`AHB_DATA_MAX_BIT:0] hwdata0;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr0;
  reg [1:0]  htrans0;
  reg hwrite0;
  reg [2:0]  hburst0;
  reg [2:0]  hsize0;
  reg [3:0]  hprot0;
  
  // M1
  reg 	      hbusreq1;
  reg 	      hlock1;
  reg 	      hgrant1;
  reg [`AHB_DATA_MAX_BIT:0] hwdata1;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr1;
  reg [1:0]  htrans1;
  reg hwrite1;
  reg [2:0]  hburst1;
  reg [2:0]  hsize1;
  reg [3:0]  hprot1;

  // M2
  reg 	      hbusreq2;
  reg 	      hlock2;
  reg 	      hgrant2;
  reg [`AHB_DATA_MAX_BIT:0] hwdata2;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr2;
  reg [1:0]  htrans2;
  reg hwrite2;
  reg [2:0]  hburst2;
  reg [2:0]  hsize2;
  reg [3:0]  hprot2;

  // M3
  reg 	      hbusreq3;
  reg 	      hlock3;
  reg 	      hgrant3;
  reg [`AHB_DATA_MAX_BIT:0] hwdata3;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr3;
  reg [1:0]  htrans3;
  reg hwrite3;
  reg [2:0]  hburst3;
  reg [2:0]  hsize3;
  reg [3:0]  hprot3;

  // M4
  reg 	      hbusreq4;
  reg 	      hlock4;
  reg 	      hgrant4;
  reg [`AHB_DATA_MAX_BIT:0] hwdata4;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr4;
  reg [1:0]  htrans4;
  reg hwrite4;
  reg [2:0]  hburst4;
  reg [2:0]  hsize4;
  reg [3:0]  hprot4;

  // M5
  reg 	      hbusreq5;
  reg 	      hlock5;
  reg 	      hgrant5;
  reg [`AHB_DATA_MAX_BIT:0] hwdata5;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr5;
  reg [1:0]  htrans5;
  reg hwrite5;
  reg [2:0]  hburst5;
  reg [2:0]  hsize5;
  reg [3:0]  hprot5;

  // M6
  reg 	      hbusreq6;
  reg 	      hlock6;
  reg 	      hgrant6;
  reg [`AHB_DATA_MAX_BIT:0] hwdata6;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr6;
  reg [1:0]  htrans6;
  reg hwrite6;
  reg [2:0]  hburst6;
  reg [2:0]  hsize6;
  reg [3:0]  hprot6;

  // M7
  reg 	      hbusreq7;
  reg 	      hlock7;
  reg 	      hgrant7;
  reg [`AHB_DATA_MAX_BIT:0] hwdata7;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr7;
  reg [1:0]  htrans7;
  reg hwrite7;
  reg [2:0]  hburst7;
  reg [2:0]  hsize7;
  reg [3:0]  hprot7;


  // M8
  reg 	      hbusreq8;
  reg 	      hlock8;
  reg 	      hgrant8;
  reg [`AHB_DATA_MAX_BIT:0] hwdata8;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr8;
  reg [1:0]  htrans8;
  reg hwrite8;
  reg [2:0]  hburst8;
  reg [2:0]  hsize8;
  reg [3:0]  hprot8;


  // M9
  reg 	      hbusreq9;
  reg 	      hlock9;
  reg 	      hgrant9;
  reg [`AHB_DATA_MAX_BIT:0] hwdata9;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr9;
  reg [1:0]  htrans9;
  reg hwrite9;
  reg [2:0]  hburst9;
  reg [2:0]  hsize9;
  reg [3:0]  hprot9;


  // M10
  reg 	      hbusreq10;
  reg 	      hlock10;
  reg 	      hgrant10;
  reg [`AHB_DATA_MAX_BIT:0] hwdata10;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr10;
  reg [1:0]  htrans10;
  reg hwrite10;
  reg [2:0]  hburst10;
  reg [2:0]  hsize10;
  reg [3:0]  hprot10;


  // M11
  reg 	      hbusreq11;
  reg 	      hlock11;
  reg 	      hgrant11;
  reg [`AHB_DATA_MAX_BIT:0] hwdata11;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr11;
  reg [1:0]  htrans11;
  reg hwrite11;
  reg [2:0]  hburst11;
  reg [2:0]  hsize11;
  reg [3:0]  hprot11;


  // M12
  reg 	      hbusreq12;
  reg 	      hlock12;
  reg 	      hgrant12;
  reg [`AHB_DATA_MAX_BIT:0] hwdata12;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr12;
  reg [1:0]  htrans12;
  reg hwrite12;
  reg [2:0]  hburst12;
  reg [2:0]  hsize12;
  reg [3:0]  hprot12;


  // M13
  reg 	      hbusreq13;
  reg 	      hlock13;
  reg 	      hgrant13;
  reg [`AHB_DATA_MAX_BIT:0] hwdata13;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr13;
  reg [1:0]  htrans13;
  reg hwrite13;
  reg [2:0]  hburst13;
  reg [2:0]  hsize13;
  reg [3:0]  hprot13;


  // M14
  reg 	      hbusreq14;
  reg 	      hlock14;
  reg 	      hgrant14;
  reg [`AHB_DATA_MAX_BIT:0] hwdata14;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr14;
  reg [1:0]  htrans14;
  reg hwrite14;
  reg [2:0]  hburst14;
  reg [2:0]  hsize14;
  reg [3:0]  hprot14;


  // M15
  reg 	      hbusreq15;
  reg 	      hlock15;
  reg 	      hgrant15;
  reg [`AHB_DATA_MAX_BIT:0] hwdata15;
  reg [`AHB_ADDRESS_MAX_BIT:0] haddr15;
  reg [1:0]  htrans15;
  reg hwrite15;
  reg [2:0]  hburst15;
  reg [2:0]  hsize15;
  reg [3:0]  hprot15;

  // ---------------------------------
  // UVC slaves agents signals
  // ---------------------------------

  // S1
  reg                         hready1;
  reg  [1:0]                  hresp1;
  reg  [15:0]                 hsplit1;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata1;
  
  // S2
  reg                         hready2;
  reg  [1:0]                  hresp2;
  reg  [15:0]                 hsplit2;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata2;


  // S3
  reg                         hready3;
  reg  [1:0]                  hresp3;
  reg  [15:0]                 hsplit3;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata3;
  
  // S4
  reg                         hready4;
  reg  [1:0]                  hresp4;
  reg  [15:0]                 hsplit4;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata4;
 

  // S5
  reg                         hready5;
  reg  [1:0]                  hresp5;
  reg  [15:0]                 hsplit5;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata5;
  
  // S6
  reg                         hready6;
  reg  [1:0]                  hresp6;
  reg  [15:0]                 hsplit6;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata6;
 
  // S7
  reg                         hready7;
  reg  [1:0]                  hresp7;
  reg  [15:0]                 hsplit7;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata7;
  
  // S8
  reg                         hready8;
  reg  [1:0]                  hresp8;
  reg  [15:0]                 hsplit8;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata8;

  // S9
  reg                         hready9;
  reg  [1:0]                  hresp9;
  reg  [15:0]                 hsplit9;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata9;
  
  // S10
  reg                         hready10;
  reg  [1:0]                  hresp10;
  reg  [15:0]                 hsplit10;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata10;
  

  // S11
  reg                         hready11;
  reg  [1:0]                  hresp11;
  reg  [15:0]                 hsplit11;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata11;
  
  // S12
  reg                         hready12;
  reg  [1:0]                  hresp12;
  reg  [15:0]                 hsplit12;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata12;


  // S13
  reg                         hready13;
  reg  [1:0]                  hresp13;
  reg  [15:0]                 hsplit13;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata13;
  
  // S14
  reg                         hready14;
  reg  [1:0]                  hresp14;
  reg  [15:0]                 hsplit14;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata14;

  // S15
  reg                         hready15;
  reg  [1:0]                  hresp15;
  reg  [15:0]                 hsplit15;
  reg  [`AHB_DATA_MAX_BIT:0]  hrdata15;

  // ---------------------------------
  // UVC Arbiter agent signals
  // ---------------------------------
  wire [3:0]  hmaster;
  wire        hmastlock;

  // ---------------------------------
  // UVC Decoder agent signals
  // ---------------------------------
  reg 	      hsel0;
  reg 	      hsel1;
  reg 	      hsel2;
  reg 	      hsel3;
  reg 	      hsel4;
  reg 	      hsel5;
  reg 	      hsel6;
  reg 	      hsel7;
  reg 	      hsel8;
  reg 	      hsel9;
  reg 	      hsel10;
  reg 	      hsel11;
  reg 	      hsel12;
  reg 	      hsel13;
  reg 	      hsel14;
  reg 	      hsel15;


  // ----------------------------------
  //  Specific signals of apb subsystem
  // ----------------------------------
  reg         ua_rxd;
  reg         ua_ncts;


  // uart outputs 
  wire        ua_txd;
  wire        ua_nrts;
  wire        ua_ncts_int;

  assign ua_ncts_int = ~ua_ncts;

  reg         ua_rxd1;
  reg         ua_ncts1;

  wire        ua_ncts1_int;

  assign ua_ncts1_int = ~ua_ncts1;

  // uart outputs 
  wire        ua_txd1;
  wire        ua_nrts1;

  // gpio connections
  reg  [15:0]  gpio_pin_in ;
  wire [15:0]  n_gpio_pin_oe;
  wire [15:0]  gpio_pin_out;

  // wires for SPI
  wire        so;                    // data reg from slave
  wire        mo;                    // data reg from master
  wire        sclk_out;              // clock reg from master
  wire  [7:0] n_ss_out;              // peripheral select lines from master
  wire        n_so_en;               // out enable for slave data
  wire        n_mo_en;               // out enable for master data
  wire        n_sclk_en;             // out enable for master clock
  wire        n_ss_en;               // out enable for master peripheral lines

  //wires for spi
  reg         n_ss_in;      // select wire  to slave
  reg         mi;           // data wire  to master
  reg         si;           // data wire  to slave
  reg         sclk_in;      // clock wire  to slave

  assign hmaster = 0;
  assign hmastlock = 0;

  // DUT Instantiation
  apb_subsystem_0 i_apb_subsystem (

    // Inputs
    // system signals
    .hclk              (specman_hclk),// AHB Clock
    .n_hreset          (hresetn),     // AHB reset - Active low
    .pclk              (specman_hclk),// APB Clock
    .n_preset          (hresetn),     // APB reset - Active low
    
    // AHB interface for AHB2APM bridge
    .hsel      (hsel0),                // AHB2APB select
    .haddr             (haddr),        // Address bus
    .htrans            (htrans),       // Transfer type
    .hsize             (hsize),        // AHB Access type - byte half-word word
    .hwrite            (hwrite),       // Write signal
    .hwdata            (hwdata),       // Write data
    .hready_in         (hready),       // Indicates that the last master has finished 
                                       // its bus access
    .hburst            (hburst),       // Burst type
    .hprot             (hprot),        // Protection control
    .hmaster           (hmaster),      // Master select
    .hmastlock         (hmastlock),    // Locked transfer

    // AHB interface for SMC
    .smc_hclk          (1'b0),
    .smc_n_hclk        (1'b1),
    .smc_haddr         (32'd0),
    .smc_htrans        (2'b00),
    .smc_hsel          (1'b0),
    .smc_hwrite        (1'b0),
    .smc_hsize         (3'd0),
    .smc_hwdata        (32'd0),
    .smc_hready_in     (1'b1),
    .smc_hburst        (3'b000),
    .smc_hprot         (4'b0000),
    .smc_hmaster       (4'b0000),
    .smc_hmastlock     (1'b0),

    // Interrupt from Enet MAC
    .macb0_int     (1'b0),
    .macb1_int     (1'b0),
    .macb2_int     (1'b0),
    .macb3_int     (1'b0),

    // PMC Ports
    .clk_SRPG_macb0_en(),
    .clk_SRPG_macb1_en(),
    .clk_SRPG_macb2_en(),
    .clk_SRPG_macb3_en(),
    .core06v(),
    .core08v(),
    .core10v(),
    .core12v(),
    .macb3_wakeup(),
    .macb2_wakeup(),
    .macb1_wakeup(),
    .macb0_wakeup(),
    .mte_smc_start(),
    .mte_uart_start(),
    .mte_smc_uart_start(),  
    .mte_pm_smc_to_default_start(), 
    .mte_pm_uart_to_default_start(),
    .mte_pm_smc_uart_to_default_start(),

     // Peripheral Interrupt
    .pcm_irq(),
    .ttc_irq(),
    .gpio_irq(),
    .uart0_irq(),
    .uart1_irq(),
    .spi_irq(),
    //interrupt from DMA
    .DMA_irq           (1'b0),      
    // Interrupt from the USB

    // Scan inputs
    .scan_en           (1'b0),         // Scan enable pin
    .scan_in_1         (1'b0),         // Scan input for first chain
    .scan_in_2         (1'b0),        // Scan input for second chain
    .scan_mode         (1'b0),
    //input for smc
    .data_smc          (32'd0),
    //.wait_smc          (1'b0),
    //inputs for uart
    .ua_rxd            (ua_rxd),
    .ua_rxd1           (ua_rxd1),
    .ua_ncts           (ua_ncts),
    .ua_ncts1          (ua_ncts1),
    //inputs for spi
    .si(1'b0),
    .n_ss_in(1'b1),
    .mi(mi),
    .sclk_in(1'b0),
    //input for ttc
    //.ttc_ext_clk       (3'd0),
    //input for wdt
    //inputs for GPIO
    .gpio_pin_in       (gpio_pin_in),
 
    // Scan outputs
    .scan_out_1        (),             // Scan out for chain 1
    .scan_out_2        (),             // Scan out for chain 2
   
    //output from APB 
    // AHB interface for AHB2APB bridge
    .hrdata            (hrdata0),       // Read data provided from target slave
    .hready            (hready0),       // Ready for new bus cycle from target slave
    .hresp             (hresp0),        // Response from the bridge

    // AHB interface for SMC
    .smc_hrdata        (), 
    .smc_hready        (),
    .smc_hresp         (),
  

    // Watchdog Reset output    
    //.wd_rst            (),
    //outputs from apic
    //.nfiq              (),// Fiq int output time being as ARM not there leave floating 
    //.nirq              (),// Irq int output time being as ARM not there leave floating 
    //outputs from smc
    .smc_n_ext_oe      (),
    .smc_data          (),
    .smc_addr          (),
    .smc_n_be          (),
    .smc_n_cs          (), 
    .smc_n_we          (),
    .smc_n_wr          (),
    .smc_n_rd          (),
    //outputs from uart
    .ua_txd             (ua_txd),
    .ua_txd1            (ua_txd1),
    .ua_nrts            (ua_nrts),
    .ua_nrts1           (ua_nrts1),
    // outputs from ttc
    //.waveform          (),
    //.n_waveform_oe     (),
    // outputs from SPI
    .so(so),
    .mo(mo),
    .sclk_out(sclk_out),
    .n_ss_out(n_ss_out),
    .n_so_en(n_so_en),
    .n_mo_en(n_mo_en),
    .n_sclk_en(n_sclk_en),
    .n_ss_en(n_ss_en),
    //outputs from gpio
    .n_gpio_pin_oe     (n_gpio_pin_oe),
    .gpio_pin_out      (gpio_pin_out)
);



    // =====================================
    // =====================================
    //         MUXES Instantiations
    // =====================================
    // =====================================

    // -----------------------------------
    //    Slaves mux
    // -----------------------------------


  
    assign hsplit = hsplit0 | hsplit1 | hsplit2 | hsplit3 |  
                    hsplit4 | hsplit5 | hsplit6 | hsplit7 | 
		    hsplit8 | hsplit9 | hsplit10 | hsplit11 | 
		    hsplit12 | hsplit13 | hsplit14 | hsplit15;
  
   slave_mux  slave_mux(//output
                    .hready(hready),
                    .hresp(hresp),
                    .hrdata(hrdata),
                    
                     //input
                    .hready0(hready0), 
                    .hready1(hready1),
                    .hready2(hready2),
                    .hready3(hready3),
                    .hready4(hready4), 
                    .hready5(hready5),
                    .hready6(hready6),
                    .hready7(hready7),
                    .hready8(hready8), 
                    .hready9(hready9),
                    .hready10(hready10),
                    .hready11(hready11),
                    .hready12(hready12), 
                    .hready13(hready13),
                    .hready14(hready14),
                    .hready15(hready15),
                    .hresp0(hresp0),
                    .hresp1(hresp1),
                    .hresp2(hresp2),
                    .hresp3(hresp3),
                    .hresp4(hresp4),
                    .hresp5(hresp5), 
                    .hresp6(hresp6),
                    .hresp7(hresp7),
                    .hresp8(hresp8),
                    .hresp9(hresp9),
                    .hresp10(hresp10), 
                    .hresp11(hresp11),
                    .hresp12(hresp12),
                    .hresp13(hresp13),
                    .hresp14(hresp14),
                    .hresp15(hresp15),
                    .hrdata0(hrdata0),
                    .hrdata1(hrdata1),
                    .hrdata2(hrdata2),
                    .hrdata3(hrdata3),
                    .hrdata4(hrdata4),
                    .hrdata5(hrdata5), 
                    .hrdata6(hrdata6),
                    .hrdata7(hrdata7),
                    .hrdata8(hrdata8),
                    .hrdata9(hrdata9),
                    .hrdata10(hrdata10), 
                    .hrdata11(hrdata11),
                    .hrdata12(hrdata12),
                    .hrdata13(hrdata13),
                    .hrdata14(hrdata14),
                    .hrdata15(hrdata15),
                    .hsel0(hsel0),
                    .hsel1(hsel1),
                    .hsel2(hsel2),
                    .hsel3(hsel3),
                    .hsel4(hsel4),
                    .hsel5(hsel5),
                    .hsel6(hsel6),
                    .hsel7(hsel7),
                    .hsel8(hsel8),
                    .hsel9(hsel9),
                    .hsel10(hsel10),
                    .hsel11(hsel11),
                    .hsel12(hsel12),
                    .hsel13(hsel13),
                    .hsel14(hsel14),
                    .hsel15(hsel15),
                    .specman_hclk(specman_hclk),
                    .hresetn(hresetn));





    // -----------------------------------
    //    Masters mux
    // -----------------------------------

    master_mux master_mux(//Input
                  .haddr0(haddr0), 
                  .haddr1(haddr1), 
                  .haddr2(haddr2), 
                  .haddr3(haddr3),
	          .haddr4(haddr4), 
                  .haddr5(haddr5), 
                  .haddr6(haddr6), 
                  .haddr7(haddr7),
	          .haddr8(haddr8), 
                  .haddr9(haddr9), 
                  .haddr10(haddr10), 
                  .haddr11(haddr11),   
	          .haddr12(haddr12), 
                  .haddr13(haddr13), 
                  .haddr14(haddr14), 
                  .haddr15(haddr15),
                  .htrans0(htrans0), 
                  .htrans1(htrans1), 
                  .htrans2(htrans2), 
                  .htrans3(htrans3),
	          .htrans4(htrans4), 
                  .htrans5(htrans5), 
                  .htrans6(htrans6), 
                  .htrans7(htrans7),
	          .htrans8(htrans8), 
                  .htrans9(htrans9), 
                  .htrans10(htrans10), 
                  .htrans11(htrans11),   
	          .htrans12(htrans12), 
                  .htrans13(htrans13), 
                  .htrans14(htrans14), 
                  .htrans15(htrans15),
	          .hwrite0(hwrite0), 
                  .hwrite1(hwrite1), 
                  .hwrite2(hwrite2), 
                  .hwrite3(hwrite3),
	          .hwrite4(hwrite4), 
                  .hwrite5(hwrite5), 
                  .hwrite6(hwrite6), 
                  .hwrite7(hwrite7),
	          .hwrite8(hwrite8), 
                  .hwrite9(hwrite9), 
                  .hwrite10(hwrite10), 
                  .hwrite11(hwrite11),   
	          .hwrite12(hwrite12), 
                  .hwrite13(hwrite13), 
                  .hwrite14(hwrite14), 
                  .hwrite15(hwrite15),
	          .hburst0(hburst0), 
                  .hburst1(hburst1), 
                  .hburst2(hburst2), 
                  .hburst3(hburst3),
	          .hburst4(hburst4), 
                  .hburst5(hburst5),  
                  .hburst6(hburst6), 
                  .hburst7(hburst7),
	          .hburst8(hburst8), 
                  .hburst9(hburst9), 
                  .hburst10(hburst10), 
                  .hburst11(hburst11),   
	          .hburst12(hburst12), 
                  .hburst13(hburst13), 
                  .hburst14(hburst14), 
                  .hburst15(hburst15),
	          .hsize0(hsize0), 
                  .hsize1(hsize1), 
                  .hsize2(hsize2), 
                  .hsize3(hsize3),
	          .hsize4(hsize4), 
                  .hsize5(hsize5), 
                  .hsize6(hsize6), 
                  .hsize7(hsize7),
	          .hsize8(hsize8), 
                  .hsize9(hsize9), 
                  .hsize10(hsize10), 
                  .hsize11(hsize11),   
	          .hsize12(hsize12), 
                  .hsize13(hsize13), 
                  .hsize14(hsize14), 
                  .hsize15(hsize15),
	          .hprot0(hprot0), 
                  .hprot1(hprot1), 
                  .hprot2(hprot2), 
                  .hprot3(hprot3),
	          .hprot4(hprot4), 
                  .hprot5(hprot5), 
                  .hprot6(hprot6), 
                  .hprot7(hprot7),
	          .hprot8(hprot8), 
                  .hprot9(hprot9), 
                  .hprot10(hprot10), 
                  .hprot11(hprot11),   
	          .hprot12(hprot12), 
                  .hprot13(hprot13),
                  .hprot14(hprot14), 
                  .hprot15(hprot15),
                  .hmaster(hmaster),  
                  .hwdata0(hwdata0), 
                  .hwdata1(hwdata1), 
                  .hwdata2(hwdata2), 
                  .hwdata3(hwdata3),
	          .hwdata4(hwdata4), 
                  .hwdata5(hwdata5), 
                  .hwdata6(hwdata6), 
                  .hwdata7(hwdata7),
	          .hwdata8(hwdata8), 
                  .hwdata9(hwdata9), 
                  .hwdata10(hwdata10), 
                  .hwdata11(hwdata11),
	          .hwdata12(hwdata12), 
                  .hwdata13(hwdata13), 
                  .hwdata14(hwdata14), 
                  .hwdata15(hwdata15),
                  .specman_hclk(specman_hclk), 
                  .hresetn(hresetn), 
                  .hready(hready),
                  
                  //Output
                  .haddr(haddr), 
                  .htrans(htrans), 
                  .hwrite(hwrite), 
                  .hburst(hburst),
                  .hsize(hsize), 
                  .hprot(hprot),
                  .hwdata(hwdata));



    // =====================================
    // =====================================
    //         Initialization
    // =====================================
    // =====================================

    initial
      begin

         // Simulation Clock Initialization
         specman_hclk = 0;

         hsel0 = 1'b1;
         hsel1 = 1'b0;
         hsel2 = 1'b0;
         hsel3 = 1'b0;
         hsel4 = 1'b0;
         hsel5 = 1'b0;
         hsel6 = 1'b0;
         hsel7 = 1'b0;
         hsel8 = 1'b0;
         hsel9 = 1'b0;
         hsel10 = 1'b0;
         hsel11 = 1'b0;
         hsel12 = 1'b0;
         hsel13 = 1'b0;
         hsel14 = 1'b0;
         hsel15 = 1'b0;
         
 
         // M0
         hbusreq0= `DEFAULT_HBUSREQ_VALUE;
         hlock0  = `DEFAULT_HLOCK_VALUE;
         hgrant0 = `DEFAULT_HGRANT_VALUE;
         hwdata0 = `DEFAULT_HWDATA_VALUE;
         haddr0  = `DEFAULT_HADDR_VALUE;
         htrans0 = `DEFAULT_HTRANS_VALUE;
         hwrite0 = `DEFAULT_HWRITE_VALUE;
         hburst0 = `DEFAULT_HBURST_VALUE;
         hsize0  = `DEFAULT_HSIZE_VALUE;
         hprot0  = `DEFAULT_HPROT_VALUE;
  
         // M1
         hbusreq1= `DEFAULT_HBUSREQ_VALUE;
         hlock1  = `DEFAULT_HLOCK_VALUE;
         hgrant1 = `DEFAULT_HGRANT_VALUE;
         hwdata1 = `DEFAULT_HWDATA_VALUE;
         haddr1  = `DEFAULT_HADDR_VALUE;
         htrans1 = `DEFAULT_HTRANS_VALUE;
         hwrite1 = `DEFAULT_HWRITE_VALUE;
         hburst1 = `DEFAULT_HBURST_VALUE;
         hsize1  = `DEFAULT_HSIZE_VALUE;
         hprot1  = `DEFAULT_HPROT_VALUE;
  
         // M2
         hbusreq2= `DEFAULT_HBUSREQ_VALUE;
         hlock2  = `DEFAULT_HLOCK_VALUE;
         hgrant2 = `DEFAULT_HGRANT_VALUE;
         hwdata2 = `DEFAULT_HWDATA_VALUE;
         haddr2  = `DEFAULT_HADDR_VALUE;
         htrans2 = `DEFAULT_HTRANS_VALUE;
         hwrite2 = `DEFAULT_HWRITE_VALUE;
         hburst2 = `DEFAULT_HBURST_VALUE;
         hsize2  = `DEFAULT_HSIZE_VALUE;
         hprot2  = `DEFAULT_HPROT_VALUE;
   
         // M3
         hbusreq3= `DEFAULT_HBUSREQ_VALUE;
         hlock3  = `DEFAULT_HLOCK_VALUE;
         hgrant3 = `DEFAULT_HGRANT_VALUE;
         hwdata3 = `DEFAULT_HWDATA_VALUE;
         haddr3  = `DEFAULT_HADDR_VALUE;
         htrans3 = `DEFAULT_HTRANS_VALUE;
         hwrite3 = `DEFAULT_HWRITE_VALUE;
         hburst3 = `DEFAULT_HBURST_VALUE;
         hsize3  = `DEFAULT_HSIZE_VALUE;
         hprot3  = `DEFAULT_HPROT_VALUE;
  
         // M4
         hbusreq4= `DEFAULT_HBUSREQ_VALUE;
         hlock4  = `DEFAULT_HLOCK_VALUE;
         hgrant4 = `DEFAULT_HGRANT_VALUE;
         hwdata4 = `DEFAULT_HWDATA_VALUE;
         haddr4  = `DEFAULT_HADDR_VALUE;
         htrans4 = `DEFAULT_HTRANS_VALUE;
         hwrite4 = `DEFAULT_HWRITE_VALUE;
         hburst4 = `DEFAULT_HBURST_VALUE;
         hsize4  = `DEFAULT_HSIZE_VALUE;
         hprot4  = `DEFAULT_HPROT_VALUE;
  
          // M5
         hbusreq5= `DEFAULT_HBUSREQ_VALUE;
         hlock5  = `DEFAULT_HLOCK_VALUE;
         hgrant5 = `DEFAULT_HGRANT_VALUE;
         hwdata5 = `DEFAULT_HWDATA_VALUE;
         haddr5  = `DEFAULT_HADDR_VALUE;
         htrans5 = `DEFAULT_HTRANS_VALUE;
         hwrite5 = `DEFAULT_HWRITE_VALUE;
         hburst5 = `DEFAULT_HBURST_VALUE;
         hsize5  = `DEFAULT_HSIZE_VALUE;
         hprot5  = `DEFAULT_HPROT_VALUE;
      
         // M6
         hbusreq6= `DEFAULT_HBUSREQ_VALUE;
         hlock6  = `DEFAULT_HLOCK_VALUE;
         hgrant6 = `DEFAULT_HGRANT_VALUE;
         hwdata6 = `DEFAULT_HWDATA_VALUE;
         haddr6  = `DEFAULT_HADDR_VALUE;
         htrans6 = `DEFAULT_HTRANS_VALUE;
         hwrite6 = `DEFAULT_HWRITE_VALUE;
         hburst6 = `DEFAULT_HBURST_VALUE;
         hsize6  = `DEFAULT_HSIZE_VALUE;
         hprot6  = `DEFAULT_HPROT_VALUE;
  
         // M7
         hbusreq7= `DEFAULT_HBUSREQ_VALUE;
         hlock7  = `DEFAULT_HLOCK_VALUE;
         hgrant7 = `DEFAULT_HGRANT_VALUE;
         hwdata7 = `DEFAULT_HWDATA_VALUE;
         haddr7  = `DEFAULT_HADDR_VALUE;
         htrans7 = `DEFAULT_HTRANS_VALUE;
         hwrite7 = `DEFAULT_HWRITE_VALUE;
         hburst7 = `DEFAULT_HBURST_VALUE;
         hsize7  = `DEFAULT_HSIZE_VALUE;
         hprot7  = `DEFAULT_HPROT_VALUE;
  
         // M8
         hbusreq8= `DEFAULT_HBUSREQ_VALUE;
         hlock8  = `DEFAULT_HLOCK_VALUE;
         hgrant8 = `DEFAULT_HGRANT_VALUE;
         hwdata8 = `DEFAULT_HWDATA_VALUE;
         haddr8  = `DEFAULT_HADDR_VALUE;
         htrans8 = `DEFAULT_HTRANS_VALUE;
         hwrite8 = `DEFAULT_HWRITE_VALUE;
         hburst8 = `DEFAULT_HBURST_VALUE;
         hsize8  = `DEFAULT_HSIZE_VALUE;
         hprot8  = `DEFAULT_HPROT_VALUE;
  
         // M9
         hbusreq9= `DEFAULT_HBUSREQ_VALUE;
         hlock9  = `DEFAULT_HLOCK_VALUE;
         hgrant9 = `DEFAULT_HGRANT_VALUE;
         hwdata9 = `DEFAULT_HWDATA_VALUE;
         haddr9  = `DEFAULT_HADDR_VALUE;
         htrans9 = `DEFAULT_HTRANS_VALUE;
         hwrite9 = `DEFAULT_HWRITE_VALUE;
         hburst9 = `DEFAULT_HBURST_VALUE;
         hsize9  = `DEFAULT_HSIZE_VALUE;
         hprot9  = `DEFAULT_HPROT_VALUE;
  
         // M10
         hbusreq10= `DEFAULT_HBUSREQ_VALUE;
         hlock10  = `DEFAULT_HLOCK_VALUE;
         hgrant10 = `DEFAULT_HGRANT_VALUE;
         hwdata10 = `DEFAULT_HWDATA_VALUE;
         haddr10  = `DEFAULT_HADDR_VALUE;
         htrans10 = `DEFAULT_HTRANS_VALUE;
         hwrite10 = `DEFAULT_HWRITE_VALUE;
         hburst10 = `DEFAULT_HBURST_VALUE;
         hsize10  = `DEFAULT_HSIZE_VALUE;
         hprot10  = `DEFAULT_HPROT_VALUE;
  
         // M11
         hbusreq11= `DEFAULT_HBUSREQ_VALUE;
         hlock11  = `DEFAULT_HLOCK_VALUE;
         hgrant11 = `DEFAULT_HGRANT_VALUE;
         hwdata11 = `DEFAULT_HWDATA_VALUE;
         haddr11  = `DEFAULT_HADDR_VALUE;
         htrans11 = `DEFAULT_HTRANS_VALUE;
         hwrite11 = `DEFAULT_HWRITE_VALUE;
         hburst11 = `DEFAULT_HBURST_VALUE;
         hsize11  = `DEFAULT_HSIZE_VALUE;
         hprot11  = `DEFAULT_HPROT_VALUE;
  
         // M12
         hbusreq12= `DEFAULT_HBUSREQ_VALUE;
         hlock12  = `DEFAULT_HLOCK_VALUE;
         hgrant12 = `DEFAULT_HGRANT_VALUE;
         hwdata12 = `DEFAULT_HWDATA_VALUE;
         haddr12  = `DEFAULT_HADDR_VALUE;
         htrans12 = `DEFAULT_HTRANS_VALUE;
         hwrite12 = `DEFAULT_HWRITE_VALUE;
         hburst12 = `DEFAULT_HBURST_VALUE;
         hsize12  = `DEFAULT_HSIZE_VALUE;
         hprot12  = `DEFAULT_HPROT_VALUE;
  
         // M13
         hbusreq13= `DEFAULT_HBUSREQ_VALUE;
         hlock13  = `DEFAULT_HLOCK_VALUE;
         hgrant13 = `DEFAULT_HGRANT_VALUE;
         hwdata13 = `DEFAULT_HWDATA_VALUE;
         haddr13  = `DEFAULT_HADDR_VALUE;
         htrans13 = `DEFAULT_HTRANS_VALUE;
         hwrite13 = `DEFAULT_HWRITE_VALUE;
         hburst13 = `DEFAULT_HBURST_VALUE;
         hsize13  = `DEFAULT_HSIZE_VALUE;
         hprot13  = `DEFAULT_HPROT_VALUE;
  
         // M14
         hbusreq14= `DEFAULT_HBUSREQ_VALUE;
         hlock14  = `DEFAULT_HLOCK_VALUE;
         hgrant14 = `DEFAULT_HGRANT_VALUE;
         hwdata14 = `DEFAULT_HWDATA_VALUE;
         haddr14  = `DEFAULT_HADDR_VALUE;
         htrans14 = `DEFAULT_HTRANS_VALUE;
         hwrite14 = `DEFAULT_HWRITE_VALUE;
         hburst14 = `DEFAULT_HBURST_VALUE;
         hsize14  = `DEFAULT_HSIZE_VALUE;
         hprot14  = `DEFAULT_HPROT_VALUE;
  
         // M15
         hbusreq15= `DEFAULT_HBUSREQ_VALUE;
         hlock15  = `DEFAULT_HLOCK_VALUE;
         hgrant15 = `DEFAULT_HGRANT_VALUE;
         hwdata15 = `DEFAULT_HWDATA_VALUE;
         haddr15  = `DEFAULT_HADDR_VALUE;
         htrans15 = `DEFAULT_HTRANS_VALUE;
         hwrite15 = `DEFAULT_HWRITE_VALUE;
         hburst15 = `DEFAULT_HBURST_VALUE;
         hsize15  = `DEFAULT_HSIZE_VALUE;
         hprot15  = `DEFAULT_HPROT_VALUE;
  

         // S1
         hready1  = `DEFAULT_HREADY_VALUE;
         hresp1   = `DEFAULT_HRESP_VALUE;
         hsplit1  = `DEFAULT_HSPLIT_VALUE;
         hrdata1  = `DEFAULT_HRDATA_VALUE;

         // S2
         hready2  = `DEFAULT_HREADY_VALUE;
         hresp2   = `DEFAULT_HRESP_VALUE;
         hsplit2  = `DEFAULT_HSPLIT_VALUE;
         hrdata2  = `DEFAULT_HRDATA_VALUE;

         // S3
         hready3  = `DEFAULT_HREADY_VALUE;
         hresp3   = `DEFAULT_HRESP_VALUE;
         hsplit3  = `DEFAULT_HSPLIT_VALUE;
         hrdata3  = `DEFAULT_HRDATA_VALUE;
         
         // S4
         hready4  = `DEFAULT_HREADY_VALUE;
         hresp4   = `DEFAULT_HRESP_VALUE;
         hsplit4  = `DEFAULT_HSPLIT_VALUE;
         hrdata4  = `DEFAULT_HRDATA_VALUE;

         // S5
         hready5  = `DEFAULT_HREADY_VALUE;
         hresp5   = `DEFAULT_HRESP_VALUE;
         hsplit5  = `DEFAULT_HSPLIT_VALUE;
         hrdata5  = `DEFAULT_HRDATA_VALUE;

         // S6
         hready6  = `DEFAULT_HREADY_VALUE;
         hresp6   = `DEFAULT_HRESP_VALUE;
         hsplit6  = `DEFAULT_HSPLIT_VALUE;
         hrdata6  = `DEFAULT_HRDATA_VALUE;

         // S7
         hready7  = `DEFAULT_HREADY_VALUE;
         hresp7   = `DEFAULT_HRESP_VALUE;
         hsplit7  = `DEFAULT_HSPLIT_VALUE;
         hrdata7  = `DEFAULT_HRDATA_VALUE;

         // S8
         hready8  = `DEFAULT_HREADY_VALUE;
         hresp8   = `DEFAULT_HRESP_VALUE;
         hsplit8  = `DEFAULT_HSPLIT_VALUE;
         hrdata8  = `DEFAULT_HRDATA_VALUE;

         // S9
         hready9  = `DEFAULT_HREADY_VALUE;
         hresp9   = `DEFAULT_HRESP_VALUE;
         hsplit9  = `DEFAULT_HSPLIT_VALUE;
         hrdata9  = `DEFAULT_HRDATA_VALUE;

         // S10
         hready10  = `DEFAULT_HREADY_VALUE;
         hresp10   = `DEFAULT_HRESP_VALUE;
         hsplit10  = `DEFAULT_HSPLIT_VALUE;
         hrdata10  = `DEFAULT_HRDATA_VALUE;

         // S11
         hready11  = `DEFAULT_HREADY_VALUE;
         hresp11   = `DEFAULT_HRESP_VALUE;
         hsplit11  = `DEFAULT_HSPLIT_VALUE;
         hrdata11  = `DEFAULT_HRDATA_VALUE;

         // S12
         hready12  = `DEFAULT_HREADY_VALUE;
         hresp12   = `DEFAULT_HRESP_VALUE;
         hsplit12  = `DEFAULT_HSPLIT_VALUE;
         hrdata12  = `DEFAULT_HRDATA_VALUE;

         // S13
         hready13  = `DEFAULT_HREADY_VALUE;
         hresp13   = `DEFAULT_HRESP_VALUE;
         hsplit13  = `DEFAULT_HSPLIT_VALUE;
         hrdata13  = `DEFAULT_HRDATA_VALUE;

         // S14
         hready14  = `DEFAULT_HREADY_VALUE;
         hresp14   = `DEFAULT_HRESP_VALUE;
         hsplit14  = `DEFAULT_HSPLIT_VALUE;
         hrdata14  = `DEFAULT_HRDATA_VALUE;

         // S15
         hready15  = `DEFAULT_HREADY_VALUE;
         hresp15   = `DEFAULT_HRESP_VALUE;
         hsplit15  = `DEFAULT_HSPLIT_VALUE;
         hrdata15  = `DEFAULT_HRDATA_VALUE;

         // Reset Initialization
	 hresetn = 0;
	 #80 hresetn = 1;
	 #400 hresetn = 0;
         #1200 hresetn = 1;

        
      end

    always #40 specman_hclk = ~specman_hclk;


endmodule
