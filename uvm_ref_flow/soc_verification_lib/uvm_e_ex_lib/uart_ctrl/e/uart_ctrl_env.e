/*-------------------------------------------------------------------------
File name   : uart_ctrl_env.e
Title       : Uart environement
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the uart module environment with pointers to apb and uart eVC

Notes       : Unit for module uart environment
-------------------------------------------------------------------------*/
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
// ----------------------------------------------------------------------


<'

package uart_ctrl_pkg;

import  uart_ctrl/e/uart_ctrl_reg_seq_lib.e;

extend has_vr_ad uart_ctrl_env_u {
  cfg_reg_file  : UART_CORE vr_ad_reg_file;
};

extend uart_sequence {

  keep soft frame.parity_type  == read_only(driver.p_agent.p_env.config.parity_type);
  keep soft frame.stopbit_type == read_only(driver.p_agent.p_env.config.stopbit_type);
  keep soft frame.databit_type == read_only(driver.p_agent.p_env.config.databit_type);

};


extend UART_CONFIG'kind vr_ad_sequence {
  !p_vr_ad_seq_drv : vr_ad_sequence_driver;
};

extend has_monitor uart_ctrl_env_u {
  uart_ctrl_monitor : uart_ctrl_monitor_u is instance;
  keep uart_ctrl_monitor.p_env == me;
  keep uart_ctrl_monitor.has_vr_ad == me.has_vr_ad;
};

extend has_scbd has_monitor uart_ctrl_env_u {
    
  connect_pointers() is also {
    // Pass configuration info the the scoreboard
    uart_ctrl_monitor.has_scbd'uart_ctrl_scbd.data_len=uart_if.config.databit_type.as_a(uint);
  };
  
  connect_ports() is also {

    // The APB connected to the add trans port
    apb_if.slaves[0].agent_monitor.p_bus_monitor.transaction_complete.connect(
    uart_ctrl_monitor.has_scbd'uart_ctrl_scbd.apb_trans_add);
    
    // The UART connected to the match frame port
    if uart_if is a has_rx uart_env_u (rx_uart_env) and 
      rx_uart_env.rx_agent is a has_monitor ACTIVE RX uart_agent_u
                                                      (active_rx_agent) {
      active_rx_agent.monitor.frame_ended.connect(
      uart_ctrl_monitor.has_scbd'uart_ctrl_scbd.uart_frame_match);
    };
    
    // The UART connected to the add frame port
    if uart_if is a has_tx uart_env_u (tx_uart_env) and 
      tx_uart_env.tx_agent is a has_monitor ACTIVE TX uart_agent_u
                                     (active_tx_agent) {
      active_tx_agent.monitor.frame_ended.connect(
      uart_ctrl_monitor.has_scbd'uart_ctrl_scbd.uart_frame_add);    
    };
    
    // The APB connected to the match trans port
    apb_if.slaves[0].agent_monitor.p_bus_monitor.transaction_complete.connect(
      uart_ctrl_monitor.has_scbd'uart_ctrl_scbd.apb_trans_match);
    };
};


extend has_vr_ad has_scbd has_monitor uart_ctrl_env_u {

  connect_ports() is  also {
    apb_if.slaves[0].agent_monitor.p_bus_monitor.transaction_complete.connect(has_monitor'uart_ctrl_monitor.as_a(has_scbd has_vr_ad uart_ctrl_monitor_u).reg_uart_ctrl_in);
  };

};

'>
