-----------------------------------------------------------------
File name     : spi_top.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file imports files uses throughout the UVC.
Notes         :
-----------------------------------------------------------------
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
-------------------------------------------------------------------

<'

package spi;

define VR_SPI_VERSION_0_1; // Current version
// if compatible with older version define
// a symbol for the defined versions
define VR_SPI_VERSION_0_OR_LATER;

import uvm_e/e/uvm_e_top.e;          // Importing the UVM package
import spi/e/spi_types;              // Type definations
import spi/e/spi_env_h;		     // SPI env header file
import spi/e/spi_agent_h;	     // SPI agent header file
import spi/e/spi_monitor;	     // SPI monitor
import spi/e/spi_sequence;	     // SPI sequence
import spi/e/spi_bfm_h;		     // BFM header file 
import spi/e/spi_item;	             // additional decl. for the item
import spi/e/spi_agent;		     // the topology decl. for this eVC
import spi/e/spi_env;		     // the topology decl. for this eVC
import spi/e/spi_bfm;                // SPI bus functional model
import spi/e/spi_scoreboard_h;       // default scoreboard definition
import spi/e/spi_protocol_checker;   // protocol definition
import spi/e/spi_coverage;           // coverage definition

'>
