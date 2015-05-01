/*-------------------------------------------------------------------------
File name   : apb_subsystem_sve.e 
Title       : APB Subsystem Verification Environment
Project     :
Created     : November 2010
Description : APB Subsystem Verification Environment

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

<'

import apb_subsystem/sve/e/apb_subsystem_ahb_pkg_env;
import apb_subsystem/e/apb_subsystem_top;

import apb/e/apb_memory_map;

// Setting the UVM Scoreboard Messaging
extend uvm_scoreboard {
  keep logger.tags == {NORMAL;UVM_SCBD};
  keep logger.verbosity == LOW;
};

// Instance the VE in sys
extend sys {
  apb_subsystem : apb_subsystem_sve_u is instance;
  keep apb_subsystem.hdl_path() == "~/tb_apb_subsystem";
};

// APB-Subsystem Environment derived from uvm_env
unit apb_subsystem_sve_u like uvm_env {

  has_apb: bool;
  keep soft has_apb == TRUE;

  has_uart0: bool;
  keep soft has_uart0 == TRUE;

  has_uart1: bool;
  keep soft has_uart1 == TRUE; 

  has_spi: bool;
  keep soft has_spi == TRUE;

  has_gpio: bool;
  keep soft has_gpio == TRUE;

  has_vr_ad: bool;
  keep soft has_vr_ad == TRUE;

  // The module UVC (with scoreboards, reg-files etc.)
  apb_subsystem_env : apb_subsystem_env_u is instance;
  keep apb_subsystem_env.has_apb   == me.has_apb;
  keep apb_subsystem_env.has_uart0 == me.has_uart0;
  keep apb_subsystem_env.has_uart1 == me.has_uart1;
  keep apb_subsystem_env.has_spi   == me.has_spi;
  keep apb_subsystem_env.has_gpio  == me.has_gpio;
  keep apb_subsystem_env.has_vr_ad == me.has_vr_ad;
  
  // Virtual sequence driver to co-ordinate stimulus activity by all UVC's
  driver : apb_subsystem_sequence_driver_u is instance;
  
  when has_vr_ad apb_subsystem_sve_u {

    // An address map for the DUT register space
    vr_ad_map_ins : vr_ad_map;
    keep soft vr_ad_map_ins.size == 32'hffff_ffff;

    // A register-sequence-driver to access the DUT registers
    reg_driver:vr_ad_sequence_driver is instance;
    keep reg_driver.addr_map == value(vr_ad_map_ins);

    connect_pointers() is also {
      apb_subsystem_env.as_a(has_vr_ad apb_subsystem_env_u).p_addr_map = vr_ad_map_ins;
      driver.addr_map = vr_ad_map_ins;
      driver.vr_ad_seq_drv = reg_driver;
    };   
  };

  
  when has_spi apb_subsystem_sve_u {

    // SPI UVC Instance
    spi_if: APBS_ENV_SLAVE spi_env_u is instance;

    // Constrain the Base Address
    keep apb_subsystem_env.has_monitor'apb_subsystem_monitor.has_spi'has_scbd'spi_ahb_scoreboard.base_addr == APB_SUB_SYSTEM_SPI_BASE_ADDR;

    connect_pointers() is also {
      apb_subsystem_env.as_a(has_spi apb_subsystem_env_u).spi_if =spi_if;
        if spi_if.handler is a ACTIVE APBS_ENV_SLAVE spi_agent_u (active_spi_agent) {
	  driver.spi_seq_drv = active_spi_agent.seq_driver;
      }; 
    };
  }; // when has_spi apb_subsystem_sve_u..


  when has_vr_ad has_spi apb_subsystem_sve_u {

    post_generate() is also { 
      var addr : uint = APB_SUB_SYSTEM_SPI_BASE_ADDR;
      vr_ad_map_ins.add_with_offset(APB_SUB_SYSTEM_SPI_BASE_ADDR,apb_subsystem_env.as_a(has_vr_ad has_spi apb_subsystem_env_u).spi_reg_file);
    };
  }; // when has_vr_ad has_spi apb_subsystem_sve_u..

  when has_uart0 apb_subsystem_sve_u {

    fp_uart_sync: uart_sync is instance;
    keep soft fp_uart_sync.sig_uart_HCLK     == "specman_hclk";
    keep soft fp_uart_sync.sig_uart_HRESET   == "hresetn";
    keep soft fp_uart_sync.sig_uart_BUAD_CLK == "specman_hclk";
    keep soft fp_uart_sync.hdl_path()        == "~/tb_apb_subsystem";
    
    -- Instantiate the UART environmant
    fp_uart_if: uart_env_u is instance;
    keep soft fp_uart_if.evc_name   == APB_SS_FP_UART;
    keep soft fp_uart_if.hdl_path() == "~/tb_apb_subsystem";
    keep soft fp_uart_if.p_sync     == value(fp_uart_sync); 

    // Constrain the Base Address
    keep apb_subsystem_env.has_monitor'apb_subsystem_monitor.has_uart0'has_scbd'uart_ahb_scoreboard.base_addr == APB_SUB_SYSTEM_UART_BASE_ADDR;

    connect_pointers() is also {

      apb_subsystem_env.as_a(has_uart0 apb_subsystem_env_u).fp_uart_if = fp_uart_if;
      apb_subsystem_env.as_a(has_uart0 apb_subsystem_env_u).fp_uart_sync = fp_uart_sync;

      if fp_uart_if is a has_tx uart_env_u (tx_uart_env) and 
        tx_uart_env.tx_agent is a ACTIVE TX uart_agent_u (active_tx_agent) {
        driver.fp_uart_seq_drv = active_tx_agent.driver;
      };

      if fp_uart_if is a has_rx uart_env_u (rx_uart_env) and 
        rx_uart_env.rx_agent is a ACTIVE RX uart_agent_u (active_rx_agent) {
        driver.fp_uart_rx_seq_drv = active_rx_agent.driver;
      };
    }; // connect_pointers..
  }; // when has_uart0 apb_subsystem_sve_u..
   
  when has_apb has_uart0 apb_subsystem_sve_u {

    keep apb_subsystem_env.has_apb'has_uart0'uart_ctrl_env.hdl_path() =="~/tb_apb_subsystem/i_apb_subsystem/i_oc_uart0";

    // Constrain the Base Address
    keep apb_subsystem_env.has_apb'has_uart0'uart_ctrl_env.has_monitor'uart_ctrl_monitor.has_scbd'uart_ctrl_scbd.base_addr == APB_SUB_SYSTEM_UART_BASE_ADDR;

  }; // when has_apb has_uart0 apb_subsystem_sve_u..
  

  when has_vr_ad has_apb has_uart0 apb_subsystem_sve_u {

    connect_pointers() is also {
      apb_subsystem_env.has_apb'has_uart0'uart_ctrl_env.has_vr_ad'p_addr_map = vr_ad_map_ins;
    };

    post_generate() is also { 
      vr_ad_map_ins.add_with_offset(APB_SUB_SYSTEM_UART_BASE_ADDR,apb_subsystem_env.has_apb'has_uart0'uart_ctrl_env.has_vr_ad'cfg_reg_file);
    }; // post_generate()..

  }; // has_vr_ad has_apb has_uart0 apb_subsystem_sve_u..
   
  
  when has_uart1 apb_subsystem_sve_u {

    lp_uart_sync: uart_sync is instance;
    keep soft lp_uart_sync.sig_uart_HCLK     == "specman_hclk";
    keep soft lp_uart_sync.sig_uart_HRESET   == "hresetn";
    keep soft lp_uart_sync.sig_uart_BUAD_CLK == "specman_hclk";
    keep soft lp_uart_sync.hdl_path()        == "~/tb_apb_subsystem";
    
    -- Instantiate the UART environmant
    lp_uart_if: uart_env_u is instance;
    keep soft lp_uart_if.evc_name   == APB_SS_LP_UART;
    keep soft lp_uart_if.hdl_path() == "~/tb_apb_subsystem";
    keep soft lp_uart_if.p_sync     == value(lp_uart_sync); 

    // Constrain the Base Address
    keep apb_subsystem_env.has_monitor'apb_subsystem_monitor.has_uart1'has_scbd'uart_ahb_lp_scoreboard.base_addr == APB_SUB_SYSTEM_UART1_BASE_ADDR;
  
    connect_pointers() is also {

      apb_subsystem_env.as_a(has_uart1 apb_subsystem_env_u).lp_uart_if = lp_uart_if;
      apb_subsystem_env.as_a(has_uart1 apb_subsystem_env_u).lp_uart_sync = lp_uart_sync;
      if lp_uart_if is a has_tx uart_env_u (tx_uart_env) and 
        tx_uart_env.tx_agent is a ACTIVE TX uart_agent_u (active_tx_agent) {
        driver.lp_uart_seq_drv = active_tx_agent.driver;
      };

      if lp_uart_if is a has_rx uart_env_u (rx_uart_env) and 
        rx_uart_env.rx_agent is a ACTIVE RX uart_agent_u (active_rx_agent) {
        driver.lp_uart_rx_seq_drv = active_rx_agent.driver;
      };
    }; // connect_pointers()..
  };//has_uart1



  when has_apb has_uart1 apb_subsystem_sve_u {

    keep apb_subsystem_env.has_apb'has_uart1'uart_ctrl_lp_env.hdl_path() =="~/tb_apb_subsystem/i_apb_subsystem/i_oc_uart1";

    keep apb_subsystem_env.has_apb'has_uart1'uart_ctrl_lp_env.has_monitor'uart_ctrl_monitor.has_scbd'uart_ctrl_scbd.base_addr == APB_SUB_SYSTEM_UART1_BASE_ADDR;

  }; // has_apb has_uart1 apb_subsystem_sve_u..


  when has_vr_ad has_apb has_uart1 apb_subsystem_sve_u {

    connect_pointers() is also {
      apb_subsystem_env.has_apb'has_uart1'uart_ctrl_lp_env.has_vr_ad'p_addr_map = vr_ad_map_ins;
    };

    post_generate() is also { 
      vr_ad_map_ins.add_with_offset(APB_SUB_SYSTEM_UART1_BASE_ADDR,apb_subsystem_env.has_apb'has_uart1'uart_ctrl_lp_env.has_vr_ad'cfg_reg_file);
    }; // post_generate()..

  }; // has_vr_ad has_apb has_uart1 apb_subsystem_sve_u..


  when has_gpio apb_subsystem_sve_u {

    gpio_if: gpio_env is instance;
    keep soft gpio_if.hdl_path() == "~/tb_apb_subsystem";
    keep gpio_if.agent() == "verilog";

    connect_pointers() is also {

      apb_subsystem_env.as_a(has_gpio apb_subsystem_env_u).gpio_if =gpio_if;

      if gpio_if.agent is a ACTIVE gpio_agent (active_gpio_agent) {
        driver.gpio_seq_drv = active_gpio_agent.sequencer;
      }; 
    }; // connect_pointers()..
  }; // has_gpio apb_subsystem_sve_u..

 
   // Instantiating the AHB Environment
  ahb_if : AHB_ENV_0 multi_layer_env is instance;
  keep ahb_if.agent() == "verilog";
  
  connect_pointers() is also {
    apb_subsystem_env.ahb_if = ahb_if;
  };
  
  when has_vr_ad apb_subsystem_sve_u {

    connect_pointers() is also {
      reg_driver.default_bfm_sd = ahb_if.ahb_interfaces[0].master.as_a(ACTIVE ahb_master_agent).driver;
    };
  };  
  
  // Hook up various components in the VE
  connect_pointers() is also {

    if ahb_if.ahb_interfaces[0].master is a ACTIVE ahb_master_agent (active_ahb_master) {
       driver.ahb_seq_drv = active_ahb_master.driver;
    }; 
  }; // connect_pointers()..
  
}; // unit apb_subsystem_sve_u..

extend apb_env {
   keep has_checks;
}; -- extend uart apb_env

extend MASTER ahb_agent_monitor {
  keep has_apb_subsystem_scoreboard_hook == TRUE;
};

 
// -----------------------------------------------------------------------------
// Address Space
// -----------------------------------------------------------------------------
apb_set apb_cluster S0 slave address space: start at 0x00810000 size 0x7C ;
apb_set apb_cluster S1 slave address space: start at 0x008F0000 size 0x7C ;

'>

