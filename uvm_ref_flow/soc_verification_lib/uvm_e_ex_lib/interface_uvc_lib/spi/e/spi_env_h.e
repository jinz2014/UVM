-----------------------------------------------------------------
File name     : spi_env_h.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file declares the SPI env which is derived
                from uvm_env.
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

// SPI environment unit derived from uvm_env
unit spi_env_u like uvm_env  {

  name : spi_env_name_t;  // realname of this environment instance
  
  event clk_e;	// default clock event
  
  logger : message_logger is instance;
  keep soft logger.tags == {};
  keep soft logger.verbosity == NONE;

  show_banner() is also {
    out("spi instance: ",name," is ",me,"\n");
  }; 

};
'>
