-----------------------------------------------------------------
File name     : spi_agent_h.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file declares agent architecture used throughout the UVC.
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

// SPI agent unit derived from uvm_agent
unit spi_agent_u like uvm_agent { 

  // Pointer to enclosing unit
  env_p : spi_env_u;

  // Default clock event
  event clk_e ;
  event clk_e is only cycle@env_p.clk_e;

  // SPI Agent name
  name : spi_agent_name_t;

  // SPI Environment name
  my_env_name : spi_env_name_t;

  // uvm_active_passive_t set to PASSIVE for monitor
  keep soft active_passive == PASSIVE;		

  // SPI agent class name
  my_kind : spi_agent_class_t;

  // Index of the agent in the enclosing environment
  my_idx: uint;

  clk_p:  inout simple_port of bit is instance;
  keep bind (clk_p,external);

  spi_somi_p: inout simple_port of bit is instance;
  keep bind (spi_somi_p,external);

  spi_simo_p: inout simple_port of bit is instance;
  keep bind (spi_simo_p,external);

  spi_cs_p: inout simple_port of bit is instance;
  keep bind (spi_cs_p,external);

  // reformat env-name
  short_name(): string is only {
    return append(my_env_name,"/", name);
  };

  short_name_style() :vt_style is only {
    return RED;
  }; 

  // message logger instance
  logger : message_logger is instance;
  keep soft logger.tags == {};
  keep soft logger.verbosity == NONE;

  // default event for begin of reset
  event reset_start_e;

  // default event for end of reset
  event reset_end_e;

};


// SPI agent config struct
struct spi_agent_config_s {
  my_agent      : spi_agent_u;	    // pointer to enclosing agent
  my_kind       : spi_agent_class_t;// classname of the enclosing agent
  my_env_name   : spi_env_name_t;// realname of the enclosing environment instance
  my_agent_name : spi_agent_name_t; // realname of the enclosing agent instance
  half_clock_period: time;    
};


'>
