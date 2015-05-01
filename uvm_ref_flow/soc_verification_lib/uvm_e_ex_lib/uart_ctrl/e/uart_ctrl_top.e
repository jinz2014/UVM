/*-------------------------------------------------------------------------
File name   : uart_ctrl_top.e
Title       : File list of module uart environment
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the list of files of module uart environment

Notes       : Module uart file list
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

// Import the VR_AD Package
import vr_ad/e/vr_ad_top; 

// Import the UVM Scoreboard Package
import uvm_scbd/e/uvm_scbd_top.e;

// Import the UVM 'e' Package Top
import uvm_e/e/uvm_e_top.e;

import uart_ctrl/e/uart_ctrl_types;
import uart/e/uart_top;
import apb/e/apb_top; 
import uart_ctrl/e/uart_ctrl_env_h;

// Import Define and Config Files
import uart_ctrl/e/uart_ctrl_uart_define;
import uart_ctrl/e/uart_ctrl_uart_config.e;
import uart_ctrl/e/uart_ctrl_apb_config.e;

// Import Virtual Sequence Driver
import uart_ctrl/e/uart_ctrl_vir_seq.e;

// Import the extension to APB monitor used for scoreboard
import uart_ctrl/e/uart_ctrl_apb_scbd_methods;

// import the UVM scoreboard for UART-Module environment
import uart_ctrl/e/checker/uart_ctrl_scoreboard;

// Import the Registers
import uart_ctrl/e/uart_ctrl_reg.e;

// Import the Sequence Library
import uart_ctrl/e/uart_ctrl_apb_seq_lib.e;
import uart_ctrl/e/uart_ctrl_uart_seq_lib.e;

// Import the coverage code
import uart_ctrl/e/cover/uart_ctrl_cover;

// Import the UART-CTRL Monitor
import uart_ctrl/e/uart_ctrl_monitor.e;

// Import the Uart register Config
import  uart_ctrl/e/uart_ctrl_reg_config.e;

// Import the UART-CTRL Environment
import uart_ctrl/e/uart_ctrl_env;

'>

