/*-----------------------------------------------------------------
File name     : uart_env.e
Title         : UART Environment unit
Project       :
Created       : Wed Feb 18 10:46:08 2004
Description   : 
Notes         : UART env derived from uvm_env
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

// Declare the env unit - the top level of the eVC.
// Uart environment unit is like inherited from uvm_env
unit uart_env_u like uvm_env {

  // The logical name of this eVC instance
  evc_name :   uart_env_name_t;
  
  // A pointer to the synchronizer
  p_sync : uart_sync;
  
  // A configuration unit for the environment
  config: uart_env_config;
  keep soft config.evc_name == value(evc_name); 

  // An event that will be used to trigger the ending
  // of a test in the case on external event as end of
  // test condition
  event end_trigger;

  short_name() : string is only {
    return( evc_name.as_a(string) );
  }; 

  stop_the_test() @p_sync.clk_r is {
      
    case config.stop_condition {

      CYCLES: {
        wait[config.test_time];
      };

      EXTERNAL_EVENT: {
        sync @end_trigger;
      }; 
    }; 
      
  }; 
   
  run() is also {
    config.test_header();
    start stop_the_test();
  }; 

};

'>
