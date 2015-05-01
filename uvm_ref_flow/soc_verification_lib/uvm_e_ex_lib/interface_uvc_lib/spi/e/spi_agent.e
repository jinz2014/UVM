-----------------------------------------------------------------
File name     : spi_agent.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file extends agent architecture used throughout the UVC.
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

extend spi_agent_u {

  cfg :  spi_agent_config_s;
  keep cfg.my_agent      == me;
  keep cfg.my_kind       == my_kind;
  keep cfg.my_env_name   == my_env_name;
  keep cfg.my_agent_name == name;

  // Monitor Instance
  monitor :  spi_monitor_u is instance;
  keep monitor.my_agent == me;

  // Shutdown all active behaviour on reset start
  on reset_start_e {
    // Call the re-run method
    rerun();
  };

  rerun() is also {
    monitor.rerun();
  };

  when ACTIVE spi_agent_u {

    // Instantiate the Sequence driver 
    seq_driver: spi_sequence_driver_u is instance; 
    keep seq_driver.my_env_name == my_env_name;
    keep seq_driver.my_agent    == me;
	
    // Instantiate the BFM Unit
    bfm:  spi_bfm_u is instance;
    keep bfm.my_env_name == my_env_name;
    keep bfm.my_agent == me;
    keep bfm.my_agent_name == name;

    // shutdown seq_driver and bfm on reset start
    rerun() is also {
      seq_driver.rerun();
      bfm.rerun();
    };

    post_generate() is also {
      bfm.my_driver = seq_driver;
    }; // post_generate()...

    on clk_e {
      emit bfm.clk_e;
      emit seq_driver.clock;
    };
  };
};
'>

