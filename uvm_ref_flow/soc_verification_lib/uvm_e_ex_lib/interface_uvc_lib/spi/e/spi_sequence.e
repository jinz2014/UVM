-----------------------------------------------------------------
File name     : spi_sequence.e
Title         : SPI sequences 
Project       : SPI eVC
Created       : Tue Jul 27 13:52:04 2008
Description   : This file declares agent sequence & driver.
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

struct spi_item_s like any_sequence_item {
  // default coverage event 
  event collect_cover_e;
};
          
// SPI Sequence
sequence spi_sequence using 
  item=spi_item_s,
  created_driver=spi_sequence_driver_u,
  created_kind=spi_sequence_kind_t;

// SPI Sequence Driver
extend spi_sequence_driver_u {
  my_agent    : spi_agent_u;// parent agent holding the driver
  my_env_name : spi_env_name_t;// realname of the enclosing environment
  keep bfm_interaction_mode == PULL_MODE; // BFM-Driver interaction in PULL mode
};


extend spi_sequence {
  my_agent :  spi_agent_u;// reference to enclosing agent
  keep soft my_agent  ==  read_only(driver.my_agent);
    
  my_agent_name : spi_agent_name_t;// name of enclosing agent
  keep my_agent_name == read_only(my_agent.name);

  my_env_name  : spi_env_name_t;// name of enclosing env
  keep my_env_name == read_only(my_agent.my_env_name);

  !this_item: spi_item_s;// convenience item to use 
};


extend MAIN spi_sequence {

  pre_body()@sys.any is also {
    driver.raise_objection(TEST_DONE);	
  };

  post_body()@sys.any is also {
    wait delay(50);
    driver.drop_objection(TEST_DONE);	
  };
};
         
'>
