/*-----------------------------------------------------------------
File name     : uart_ctrl_uart_config.e
Title         : Port bindings 
Project       :
Created       : Tue Feb 18 10:46:09 2008

Description   : UART DUT to UART eVC port mapping

Notes         : 
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

import uart/e/uart_top;
import uart_ctrl_types;

extend uart_env_name_t : [FP_UART];

extend FP_UART uart_rx_signal_map_u {
  keep soft SEC_CDMA_RX_DATA == "txd";
  keep soft SEC_CDMA_RFRB    == "cts_n";
};

extend FP_UART uart_tx_signal_map_u {
  keep soft SEC_CDMA_TX_DATA == "rxd";
  keep soft SEC_CDMA_CTSB    == "rts_n";
};

// -------------------------------------------------
// ensure that the eVC does not drive a data 
// value of 5 as the DUT does not support this data 
// length
// -------------------------------------------------
extend uart_env_config {
  keep databit_type != FIVE;
};


'>



