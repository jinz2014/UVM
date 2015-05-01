-----------------------------------------------------------------
File name     : spi_env.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file extends the env to add the agent.
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

// SPI agent name 
extend spi_agent_name_t : [DEFAULT];

extend spi_env_u {

  handler: spi_agent_u is instance;
  
  keep handler.env_p == me;
  keep handler.active_passive == ACTIVE;
  keep handler.my_idx == 0;
  keep handler.my_env_name == read_only(name);

};

'>

