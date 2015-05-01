-----------------------------------------------------------------
File name     : spi_monitor.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file declares agent monitor used throughout the UVC.
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

// SPI monitor derived from uvm_monitor
unit spi_monitor_u like uvm_monitor { 

  my_class: spi_agent_class_t;// class of monitor
  event clk_e;	// default clock event
  event clk_e is only cycle@my_agent.clk_e;	
  
  my_agent     : spi_agent_u;	// reference to enclosing agent

  has_coverage : bool;	// monitor contains coverage
  keep soft has_coverage == TRUE;

  has_checks   : bool;	// monitor contains checks
  keep soft has_checks == TRUE;
  
};

'>
