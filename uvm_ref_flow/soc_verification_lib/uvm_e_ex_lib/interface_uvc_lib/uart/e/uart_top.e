/*-----------------------------------------------------------------
File name     : uart_top.e
Title         : eRM package for UART verification, cDMA group
Project       :
Created       : Wed Feb 18 10:46:08 2004
Description   : 
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

++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++

Environment structure

sys
 |____env
       |____ agent (active)
               |____ bfm
               |____ monitor 
               |____ driver 
       

++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++

<'

package uart;

define uart_VERSION_0_2_OR_LATER;
define uart_VERSION_0_2;

import uvm_e/e/uvm_e_top.e; // Import the uvm package top
import uart/e/uart_types;
import uart/e/uart_rx_resp;
import uart/e/uart_frame;
import uart/e/uart_frame_check;
import uart/e/uart_env_config;
import uart/e/uart_sync;
import uart/e/uart_sig_map;
import uart/e/uart_env_h;
import uart/e/uart_agent;
import uart/e/uart_env;
import uart/e/uart_sequence_tx;
import uart/e/uart_sequence_rx;
import uart/e/uart_monitor_h;
import uart/e/uart_monitor;
import uart/e/uart_monitor_rx;
import uart/e/uart_monitor_tx;
import uart/e/uart_bfm;
import uart/e/uart_bfm_rx;
import uart/e/uart_bfm_tx;
import uart/e/uart_sequence_lib;
import uart/e/uart_coverage;
import uart/e/uart_package;
//import uart/e/uart_g5;

'>

