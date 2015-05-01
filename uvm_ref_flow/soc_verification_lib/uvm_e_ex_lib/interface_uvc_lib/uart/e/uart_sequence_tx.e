/*-----------------------------------------------------------------
File name     : uart_sequence_tx.e
Title         : UART sequence and driver hook
Project       :
Created       : Wed Feb 18 10:46:08 2004
Description   : 
Notes         : 
-------------------------------------------------------------------*/
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
//----------------------------------------------------------------------

<'

package uart;

// create a generic uart sequence
sequence uart_sequence using 
  item = uart_frame_s, 
  created_driver = uart_driver_u;


// Hook up the driver
extend uart_driver_u {

  // This field is a reference to the agent this driver is contained in.
  p_agent:   TX uart_agent_u;

  // This field holds the name of the env this driver is contained in.
  evc_name:  uart_env_name_t;
   
  // A pointer to the synchronizer
  p_sync: uart_sync;
 
  // A configuration unit for the environment
  config: uart_env_config;
    
  // Hook up the clock
  event clock is only @p_sync.clk_r;
   
  // propagate agent name to sequence tree
  keep sequence.evc_name == value(evc_name);

}; 

// Instantiate the sequence driver only in the ACTIVE agent
extend ACTIVE TX uart_agent_u {

  driver:  uart_driver_u is instance;
  keep driver.p_agent == me;
  keep driver.evc_name == read_only(evc_name);
  keep driver.p_sync == p_sync;
  keep driver.config == value(p_env.config);

}; 

// Create utility field for basic sequences do actions
extend uart_sequence {

  evc_name : uart_env_name_t;

  !frame: uart_frame_s; 

  // This field determines what kind of frame this is.
  keep soft frame.parity_type  == read_only(driver.config.parity_type);
  keep soft frame.stopbit_type == read_only(driver.config.stopbit_type);
  keep soft frame.databit_type == read_only(driver.config.databit_type);

}; 

// Call the reset wait method before the Sequence executes
// Take care of distributed stopping of the test
extend MAIN uart_sequence {

  pre_body() @sys.any is first {
    driver.p_agent.wait_for_reset();
  };

  post_body() @sys.any is also {};
    
};

'>
