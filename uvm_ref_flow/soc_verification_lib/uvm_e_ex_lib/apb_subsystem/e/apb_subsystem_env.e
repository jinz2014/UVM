/*-------------------------------------------------------------------------
File name   : apb_subsystem_env.e
Title       : APB Subsystem Environment
Project     :
Created     : November 2010
Description : Environment unit for APB Subsystem

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

package apb_subsystem_pkg;


extend apb_subsystem_env_u {

  when has_vr_ad has_spi apb_subsystem_env_u {
    // SPI register File
    spi_reg_file : SPI_CORE vr_ad_reg_file; 
  };

  when has_apb apb_subsystem_env_u {

     // The APB interface UVC
    apb_if: apb_env is instance;

    keep apb_if.name == apb_cluster;
    keep soft apb_if.master.name == MASTER;
    keep soft apb_if.master.active_passive == PASSIVE;
    keep soft apb_if.passive_slave_names.size()  == 5;
    keep soft apb_if.active_slave_names.size()   == 0;
    keep soft apb_if.agent() == "verilog";
    keep soft apb_if.hdl_path() == "~/tb_apb_subsystem/i_apb_subsystem";
    keep for each (ss) in apb_if.slaves  {	// DUT slaves start from 0
      soft ss.name == SLAVE;
      soft ss.active_passive == PASSIVE;
    };

    keep for each (ps) in apb_if.passive_slave_names  {	// DUT slaves start from 0
      index == 0 =>  soft ps ==  S0;
      index == 1 =>  soft ps ==  S1;
      index == 2 =>  soft ps ==  S2;
      index == 3 =>  soft ps ==  S3;
      index == 4 =>  soft ps ==  S4;
    };


    // Memory map for the APB bus
    memory_map : apb_memory_map_u is instance;
    keep soft memory_map.slaves_id.size() == 5;
    keep soft apb_if.p_memory_map == memory_map; 

    keep for each (ss) in apb_if.slaves  {	// DUT slaves start from 0
      soft memory_map.slaves_id[index] == read_only(ss.id);
    };

    keep soft memory_map.name == apb_if.name;

  };    


  // The module eVC (with scoreboards, reg-files etc.)
  when has_apb has_uart0 apb_subsystem_env_u {

    uart_ctrl_env : uart_ctrl_env_u is instance;
    keep uart_ctrl_env.has_vr_ad == me.has_vr_ad;
    keep uart_ctrl_env.has_scbd  == me.has_scbd;

    connect_pointers() is also {
      uart_ctrl_env.uart_if   = fp_uart_if;
      uart_ctrl_env.uart_sync = fp_uart_sync;
      uart_ctrl_env.apb_if    = apb_if;
    };   

  };

  when has_apb has_uart1 apb_subsystem_env_u {

    uart_ctrl_lp_env : uart_ctrl_env_u is instance;
    keep uart_ctrl_lp_env.has_vr_ad == me.has_vr_ad;
    keep uart_ctrl_lp_env.has_scbd  == me.has_scbd;

    connect_pointers() is also {
      uart_ctrl_lp_env.uart_if   = lp_uart_if;
      uart_ctrl_lp_env.uart_sync = lp_uart_sync;
      uart_ctrl_lp_env.apb_if    = apb_if;
    };   

  };
}; //extend apb_subsystem_env_u..


extend has_monitor apb_subsystem_env_u {

  apb_subsystem_monitor : apb_subsystem_monitor_u is instance;
  keep apb_subsystem_monitor.p_env     == me;
  keep apb_subsystem_monitor.has_uart0 == me.has_uart0;
  keep apb_subsystem_monitor.has_uart1 == me.has_uart1;
  keep apb_subsystem_monitor.has_spi   == me.has_spi;
  keep apb_subsystem_monitor.has_gpio  == me.has_gpio;
  keep apb_subsystem_monitor.has_vr_ad == me.has_vr_ad;

};


// Binding the TLM ports for scoreboards
extend has_spi has_scbd apb_subsystem_env_u {

  connect_ports() is also {

    spi_if.handler.as_a(ACTIVE spi_agent_u).bfm.spi_read_in.connect(has_monitor'apb_subsystem_monitor.has_spi'has_scbd'spi_ahb_scoreboard.spi_frame_add);
    ahb_if.mas_monitor.has_apb_subsystem_scoreboard_hook'evc_to_duv_apb_in.connect(has_monitor'apb_subsystem_monitor.has_spi'has_scbd'spi_ahb_scoreboard.ahb_trans_match);


    ahb_if.mas_monitor.has_apb_subsystem_scoreboard_hook'duv_to_evc_apb_in.connect(has_monitor'apb_subsystem_monitor.has_spi'has_scbd'spi_ahb_scoreboard.ahb_trans_add);
    spi_if.handler.as_a(ACTIVE spi_agent_u).bfm.spi_write_in.connect(has_monitor'apb_subsystem_monitor.has_spi'has_scbd'spi_ahb_scoreboard.spi_frame_match);

  };
};


// Binding the TLM ports for scoreboards
extend  has_uart0 has_scbd apb_subsystem_env_u {

  connect_ports() is also {

    fp_uart_if.has_tx'tx_agent.has_monitor'TX'monitor.frame_ended.connect(has_monitor'apb_subsystem_monitor.has_uart0'has_scbd'uart_ahb_scoreboard.uart_frame_add);
    ahb_if.mas_monitor.has_apb_subsystem_scoreboard_hook'evc_to_duv_apb_in.connect(has_monitor'apb_subsystem_monitor.has_uart0'has_scbd'uart_ahb_scoreboard.ahb_trans_match);

    ahb_if.mas_monitor.has_apb_subsystem_scoreboard_hook'duv_to_evc_apb_in.connect(has_monitor'apb_subsystem_monitor.has_uart0'has_scbd'uart_ahb_scoreboard.ahb_trans_add);
    fp_uart_if.has_rx'rx_agent.has_monitor'RX'monitor.frame_ended.connect(has_monitor'apb_subsystem_monitor.has_uart0'has_scbd'uart_ahb_scoreboard.uart_frame_match);
   
  };
};


// Binding the TLM ports for scoreboards
extend  has_uart1 has_scbd apb_subsystem_env_u {

  connect_ports() is also {

    me.as_a(has_uart1 apb_subsystem_env_u).lp_uart_if.has_tx'tx_agent.has_monitor'TX'monitor.frame_ended.connect(has_monitor'apb_subsystem_monitor.has_uart1'has_scbd'uart_ahb_lp_scoreboard.uart_frame_add);
    ahb_if.mas_monitor.has_apb_subsystem_scoreboard_hook'evc_to_duv_apb_in.connect(has_monitor'apb_subsystem_monitor.has_uart1'has_scbd'uart_ahb_lp_scoreboard.ahb_trans_match);

    ahb_if.mas_monitor.has_apb_subsystem_scoreboard_hook'duv_to_evc_apb_in.connect(has_monitor'apb_subsystem_monitor.has_uart1'has_scbd'uart_ahb_lp_scoreboard.ahb_trans_add);
    me.as_a(has_uart1 apb_subsystem_env_u).lp_uart_if.has_rx'rx_agent.has_monitor'RX'monitor.frame_ended.connect(has_monitor'apb_subsystem_monitor.has_uart1'has_scbd'uart_ahb_lp_scoreboard.uart_frame_match);
   
  };
};


// Binding the TLM ports
extend  has_vr_ad has_scbd apb_subsystem_env_u {

  connect_ports() is also {
    ahb_if.mas_monitor.has_apb_subsystem_scoreboard_hook'reg_apb_out.connect(has_monitor'apb_subsystem_monitor.has_vr_ad'has_scbd'reg_apb_subsystem_in);
  };
};


'>
