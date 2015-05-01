/*-------------------------------------------------------------------------
File name   : apb_subsystem_top.e
Title       : APB Subsystem Top file
Project     :
Created     : November 2010
Description : Top file for the APB Subsystem environment. 
              This file also imports the UART and AHB eVC config files.       
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


import apb_subsystem_ahb_package;

-- Importing the UART eVC Config file
import apb_subsystem_uart_config/apb_subsystem_uart_config;

-- Importing the APB Related Config File
import apb_subsystem_apb_config/apb_subsystem_apb_config;

-- Importing the SPI Related Config File
import apb_subsystem_spi_config/apb_subsystem_spi_config;

-- Importing the GPIO Related Config File
import apb_subsystem_gpio_config/apb_subsystem_gpio_config;

-- Importing the UART eVC Top file

-- Importing the UART Module level top file 
import uart_ctrl/e/uart_ctrl_top;

-- Importing the APB Subsystem environment file
import apb_subsystem_env_h;

// ---------------------------------------------------------------
// Import the DUT coverage files
// If UART TLM model is used then do not import the coverage file
// Note: Define sent from verilog
// ---------------------------------------------------------------
#ifdef FV_KIT_TLM_UART  then {
} #else {
  import apb_subsystem_cover/apb_subsystem_cover;
};

-- Import the extension to AHB monitor used for scoreboard
import apb_subsystem_ahb_methods;

-- Import the UVM scoreboard for AHB-UART Interface
import apb_subsystem_checker/apb_subsystem_ahb_uart_uvm_scoreboard;

-- Import the UVM scoreboard for AHB-SPI Interface
import apb_subsystem_checker/apb_subsystem_ahb_spi_uvm_scoreboard;

import apb_subsystem_monitor;
import apb_subsystem_reg;
import apb_subsystem_reg_config;
import apb_subsystem_env;

// ---------------------------------------------------------------
// Import the virtual sequence library that contains sequences
// for the AHB interface
// ---------------------------------------------------------------
import apb_subsystem_reg_seq_lib;
import apb_subsystem_ahb_seq_lib;
import apb_subsystem_gpio_seq_lib;
import apb_subsystem_spi_seq_lib;
import apb_subsystem_uart_seq_lib;
import apb_subsystem_vir_seq;


'>

