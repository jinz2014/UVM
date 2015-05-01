/*-----------------------------------------------------------------
File name     : uart_sig_map.e
Title         : uart signal map
Project       :
Created       : Wed Feb 18 10:46:07 2004
Description   : Signal Map unit is derived from uvm_signal_map
Notes         : 
-------------------------------------------------------------------*/
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
//----------------------------------------------------------------------

<'

package uart;

unit uart_rx_signal_map_u like uvm_signal_map {

  // The name of the agent
  agent_name: uart_agent_name_t;
  
  // The name of the environment
  evc_name  : uart_env_name_t;
  
  // The rx data signal
  SEC_CDMA_RX_DATA: string;

  // The rx enable uartsignal
  SEC_CDMA_RFRB :string;
   
};


extend uart_rx_signal_map_u {

  sig_sec_cdma_rx_data : inout simple_port of bit is instance; 
  sig_sec_cdma_rfrb    : inout simple_port of bit is instance; 

  keep bind( sig_sec_cdma_rx_data,external);
  keep bind( sig_sec_cdma_rfrb,external);
  keep soft  sig_sec_cdma_rx_data.hdl_path() == SEC_CDMA_RX_DATA;
  keep soft  sig_sec_cdma_rfrb.hdl_path() == SEC_CDMA_RFRB; 

};


unit uart_tx_signal_map_u like uvm_signal_map {

  // The name of the agent
  agent_name: uart_agent_name_t;
  
  // The name of the environment
  evc_name  : uart_env_name_t;
  
  // The serial tx out signal
  SEC_CDMA_TX_DATA: string;

  // The CTSB signal clear to send when low a data should be send
  SEC_CDMA_CTSB: string;
   
};


extend uart_tx_signal_map_u {

  sig_sec_cdma_tx_data  : inout simple_port of bit is instance; 
  sig_sec_cdma_ctsb     : inout simple_port of bit is instance; 

  keep bind( sig_sec_cdma_tx_data,external);
  keep bind( sig_sec_cdma_ctsb,external);
  keep soft  sig_sec_cdma_tx_data.hdl_path() == SEC_CDMA_TX_DATA;
  keep soft  sig_sec_cdma_ctsb.hdl_path() == SEC_CDMA_CTSB; 

};


'>

