/*-------------------------------------------------------------------------
File name   : apb_subsystem_uart_config.e
Title       : uart UVC config and port bindings
Project     :
Created     : November 2010
Description : uart UVC configuration is defined here. Also uart signal map
              port bindings are performed here
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

// Importing the uart UVC top file
import uart/e/uart_top;

// ------------------------------------------
// Give the env a unique name
// Useful when you have multiple instances
// ------------------------------------------
extend uart_env_name_t : [APB_SS_FP_UART]; 

// Binding the RX signal map
extend APB_SS_FP_UART uart_rx_signal_map_u {
  keep soft SEC_CDMA_RX_DATA == "ua_txd";
  keep soft SEC_CDMA_RFRB =="ua_ncts";
};

// Binding the TX signal map
extend APB_SS_FP_UART uart_tx_signal_map_u {
  keep soft SEC_CDMA_TX_DATA == "ua_rxd";
  keep soft SEC_CDMA_CTSB == "i_apb_subsystem/ua_nrts_int";
};

// ------------------------------------------------------------------------
// ensure that the eVC does not drive a data value of 5 as the DUT does not 
// support this data length
// ------------------------------------------------------------------------
extend APB_SS_FP_UART uart_env_config {
  // keep soft databit_type != FIVE;
  keep soft parity_type == ODD;
  keep soft databit_type == EIGHT;
  keep soft stopbit_type == TWO;
  keep soft stop_condition == EXTERNAL_EVENT;

};

// ------------------------------------------------
// Give the env a unique name
// Useful when you have multiple instances
// ------------------------------------------------
extend uart_env_name_t : [APB_SS_LP_UART]; 

// Binding the Rx signal map
extend APB_SS_LP_UART uart_rx_signal_map_u {
  keep soft SEC_CDMA_RX_DATA == "ua_txd1";
  keep soft SEC_CDMA_RFRB =="ua_ncts1";
};

// Binding the Tx signal map
extend APB_SS_LP_UART uart_tx_signal_map_u {
  keep soft SEC_CDMA_TX_DATA == "ua_rxd1";
  keep soft SEC_CDMA_CTSB == "i_apb_subsystem/ua_nrts1_int";
};

// -----------------------------------------------------------------------
// ensure that the eVC does not drive a data value of 5 as the DUT does not 
// support this data length
// -----------------------------------------------------------------------
extend APB_SS_LP_UART uart_env_config {
  // keep soft databit_type != FIVE;
  keep soft parity_type == NONE;
  keep soft databit_type == EIGHT;
  keep soft stopbit_type == TWO;
  keep soft stop_condition == EXTERNAL_EVENT;

};

'>



