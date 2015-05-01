---------------------------------------------------------------
File name   :  uart_ctrl_sve.e

Title       :  Uart module SVE config 

Project     :  Module UART

Created     :  Tue Mar 11 10:56:54 2008

Description :  This file imports all the files of the UVC.

Notes       :  
---------------------------------------------------------------
//  Copyright 1999-2010 Cadence Design Systems, Inc.
//  All Rights Reserved Worldwide
// 
//  Licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in
//  compliance with the License.  You may obtain a copy of
//  the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in
//  writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//  CONDITIONS OF ANY KIND, either express or implied.  See
//  the License for the specific language governing
//  permissions and limitations under the License.
---------------------------------------------------------------

<'

import uart_ctrl/sve/e/uart_ctrl_define.e;
import uart_ctrl/e/uart_ctrl_top;
import apb/e/apb_memory_map;

// Setting the UVM Scoreboard Messaging
extend uvm_scoreboard {
  keep logger.tags == {NORMAL;UVM_SCBD};
  keep logger.verbosity == LOW;
};

// Soft contraint the parity in ODD,EVEN
extend uart_env_config {
  keep soft parity_type in [ODD,EVEN];
};

// Instance the VE in sys
extend sys {

  uart_ctrl_sve : uart_ctrl_sve_u is instance;

  post_generate() is also {
    var dmgr : tf_domain_manager;
    var dmgr_def : tf_domain_manager;
    dmgr=sys.tf_get_domain_mgr_of(APB_TF);
    dmgr_def=sys.tf_get_domain_mgr_of(DEFAULT);
    //dmgr.set_timer_value(RESET,500);
    //dmgr.set_timer_value(MAIN_TEST,2000000);
    dmgr.set_timeout_off(); 
    dmgr_def.set_timeout_off(); 
  };

};

extend vr_ad_sequence_driver {
  !p_uart_if : uart_env_u;
};

// UART-Control Module Level environment derived from uvm_env
unit uart_ctrl_sve_u like uvm_env {
  
  has_vr_ad : bool;
  keep soft has_vr_ad;

  // Specify the DUT hierarchy to be used for signal accesses
  keep hdl_path() == "tb_uart";
  keep agent()    == "verilog";

  // The module eVC (with scoreboards, reg-files etc.)
  uart_ctrl_env : uart_ctrl_env_u is instance;
  keep uart_ctrl_env.has_vr_ad == me.has_vr_ad;  

  // A synchronizer for the UART eVC 
  uart_sync: uart_sync is instance ;
  keep soft uart_sync.sig_uart_HCLK     == "specman_hclk";
  keep soft uart_sync.sig_uart_HRESET   == "hresetn";
  keep soft uart_sync.sig_uart_BUAD_CLK == "specman_hclk";

  // The UART interface eVC
  uart_if : uart_env_u is instance;
  keep soft uart_if.evc_name   == FP_UART;
  keep soft uart_if.p_sync     == value(uart_sync); 
  keep soft uart_if.has_tx     == TRUE;
  keep soft uart_if.has_rx     == TRUE;
  keep soft uart_if.as_a(has_rx uart_env_u).rx_agent.active_passive == ACTIVE;

  // The APB interface eVC
  apb_if: apb_env is instance;
  keep apb_if.name == uart;
  keep apb_if.master.name == MASTER;
  keep apb_if.passive_slave_names.size()  == 1;
  keep apb_if.active_slave_names.size()   == 0;

  keep for each (ss) in apb_if.slaves  {	// DUT slaves start from 0
    soft ss.name           ==  SLAVE;
    soft ss.active_passive == PASSIVE;
  };

  keep for each (ps) in apb_if.passive_slave_names  {	// DUT slaves start from 0
    soft ps == S0;
  };

  // Virtual sequence driver to coordinate stimulus activity by all eVCS
  driver : uart_ctrl_sequence_driver_u is instance;

  when has_vr_ad uart_ctrl_sve_u {

    // An address map for the DUT register space
    vr_ad_map_ins : vr_ad_map;
    keep soft vr_ad_map_ins.size == 32'hffff_ffff;

    // A register-sequence-driver to access the DUT registers
    reg_driver:vr_ad_sequence_driver is instance;
    keep reg_driver.addr_map == value(vr_ad_map_ins);

    // Set up the DUT register address-map
    post_generate() is also { 
      vr_ad_map_ins.add_with_offset(0,uart_ctrl_env.as_a(has_vr_ad uart_ctrl_env_u).cfg_reg_file);
    };

    connect_pointers() is also {
      driver.vr_ad_seq_drv = reg_driver;
      uart_ctrl_env.as_a(has_vr_ad uart_ctrl_env_u).p_addr_map = vr_ad_map_ins;
      driver.addr_map = vr_ad_map_ins;
      reg_driver.p_uart_if = uart_if;
      reg_driver.default_bfm_sd = apb_if.master.as_a(ACTIVE apb_master).driver;
    };

  }; // when  has_vr_ad uart_ctrl_sve_u..
  
  // Hook up various components in the VE
  connect_pointers() is also {
    if uart_if is a has_tx uart_env_u (tx_uart_env) and 
      tx_uart_env.tx_agent is a ACTIVE TX uart_agent_u (active_tx_agent) {
      driver.uart_seq_drv = active_tx_agent.driver;
    };

    if apb_if.master is a ACTIVE apb_master (active_apb_master) {
      driver.apb_seq_drv = active_apb_master.driver
    }; 

    driver.p_uart_if = uart_if;
  };

  // memory map for the APB bus
  memory_map : apb_memory_map_u is instance;
  keep soft memory_map.slaves_id.size() == 1;
  keep soft apb_if.p_memory_map == memory_map; 

  keep for each (ss) in apb_if.slaves  {  // DUT slaves start from 0
    soft memory_map.slaves_id[index] ==  read_only(ss.id);
  };

  // More VE hookup
  connect_pointers() is also {
    uart_ctrl_env.uart_if = uart_if;
    uart_ctrl_env.apb_if = apb_if;
    uart_ctrl_env.uart_sync = uart_sync;
  };   
};

extend apb_env {
  keep has_checks;
  keep master.active_passive == ACTIVE;
};

extend sys {

  init() is also {
    // Use a performance enhancement feature
    set_config(simulation, enable_ports_unification, TRUE);
    // Ignore the messages from the vr_ad
    specman("set message -remove @vr_ad*");
  };
  setup() is also {
    set_config(run, tick_max, 400000);
  };
};

extend has_coverage uart_ctrl_monitor_u {
  keep soft uart_ctrl_env_cov.hdl_path() == "uart_dut";
};

apb_set uart S0 slave address space: start at 0x00 size 0x7c ;

'>

