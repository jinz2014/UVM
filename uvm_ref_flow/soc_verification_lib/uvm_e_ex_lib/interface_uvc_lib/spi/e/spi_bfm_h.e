-----------------------------------------------------------------
File name     : spi_bfm_h.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file defines the BFM unit for SPI uVC
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


// Declaration of the generic spi bfm unit derived from uvm_bfm base unit
unit spi_bfm_u like uvm_bfm { 

  my_class : spi_agent_class_t;	// class bfm
  event clk_e ;	// the default clock event
  my_agent_name : spi_agent_name_t; // name of enclosing agent
  my_env_name : spi_env_name_t;	// name of enclosing env

};

extend  spi_bfm_u {

  my_agent : ACTIVE  spi_agent_u; // reference to enclosing agent
  !my_driver: spi_sequence_driver_u;// reference to sequence driver

  event clk_e is only cycle@my_agent.clk_e;
  drive(data : spi_item_s) @clk_e is empty;  // hook to send items in PUSH_MODE

};

'>	

