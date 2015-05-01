-----------------------------------------------------------------
File name     : spi_demo_config.e
Developers    : vishwana
Created       : Tue Jul 27 13:52:04 2008
Description   : This file configures the uVC.
Notes         :
-------------------------------------------------------------------
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

// Importing the SPI top file
import spi/e/spi_top;

// SPI env names
extend spi_env_name_t: [DEMO_INST1,DEMO_INST2];

extend sys {
  my_demo_inst1 : DEMO_INST1 spi_env_u is instance;
  my_demo_inst2 : DEMO_INST2 spi_env_u is instance;
};

// Clocks
extend  DEMO_INST1 spi_env_u {
  event clk_e is only cycle @sys.any;
};

extend  DEMO_INST2 spi_env_u {
  event clk_e is only cycle @sys.any;
};

define <pbind'struct_member> "PBIND <inst'name> <bnd'name> <pth'exp>" as {
  keep bind(<inst'name>,<bnd'name>);
  keep <inst'name>.hdl_path() == <pth'exp>;
};

extend HANDLER spi_agent_u {
  keep soft  spi_cs_p.verilog_wire() == TRUE; 
  keep soft  clk_p.verilog_wire() == TRUE; 
  keep soft  spi_simo_p.verilog_wire() == TRUE; 
  keep soft  spi_somi_p.verilog_wire() == TRUE; 
};

extend DEMO_INST1 HANDLER spi_agent_u {
  PBIND spi_cs_p external "~/tb/cs_p"; 
  PBIND clk_p external "~/tb/clk";
  PBIND spi_simo_p external "~/tb/simo";
  PBIND spi_somi_p external "~/tb/somi";
};

extend DEMO_INST2 HANDLER spi_agent_u {
  PBIND spi_cs_p external "~/tb/cs_p"; 
  PBIND clk_p external "~/tb/clk";
  PBIND spi_simo_p external "~/tb/somi";
  PBIND spi_somi_p external "~/tb/simo";
};


extend spi_item_s {
  keep op_mode        == PIN3;
  keep clock_polarity == POSEDGE;
  keep clock_phase    == ALIGNED;
  keep data_out.size() == 8;
};

extend HANDLER spi_agent_config_s {
  keep half_clock_period == 1 ns;
};

'>
