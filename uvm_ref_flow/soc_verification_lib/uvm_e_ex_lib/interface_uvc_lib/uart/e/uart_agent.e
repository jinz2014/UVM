/*-----------------------------------------------------------------
File name     : uart_agent.e
Title         : UART Agent unit
Project       :
Created       : Wed Feb 18 10:46:07 2004
Description   : The Agent unit is derived from uvm_agent
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

// Agent unit is like inherited from uvm_agent
unit uart_agent_u like uvm_agent {

  // Name of the environment
  evc_name : uart_env_name_t;

  // Agent name
  agent_name: uart_agent_name_t;

  // A pointer to the synchronizer
  p_sync: uart_sync;

  // A pointer to the env
  p_env: uart_env_u;
  
  // define TX or RX
  direction: uart_agent_dir_kind_t;

  // Enable Monitor 
  has_monitor: bool;
  keep soft has_monitor;

  // Defines active or passive agent (predefined enum type uvm_active_passive_t)
  keep soft active_passive == ACTIVE;

  // Perform protocol checking
  has_checks: bool;

  // Collect coverage
  has_coverage: bool;

  keep active_passive == ACTIVE  => soft has_checks   == FALSE;
  keep active_passive == ACTIVE  => soft has_coverage == FALSE;
  keep active_passive == PASSIVE => soft has_checks   == TRUE;
  keep active_passive == PASSIVE => soft has_coverage == TRUE;

  // Message screen logger for this agent
  logger: message_logger is instance;

  // Message file logger for this agent
  file_logger: message_logger is instance;
  keep soft file_logger.to_screen == FALSE;
  keep soft file_logger.to_file == "uart.elog";

  // Reset started
  event reset_started is @p_sync.reset_started;

  // Reset ended
  event reset_ended is @p_sync.reset_ended;

  // Use agent's short name in message
  short_name(): string is {
    return agents_short_name;
  }; 
  
  -- Use agents_vt_style in message
  short_name_style() : vt_style is {
     return agents_vt_style;
  };
  
  // Agents short name to be used in messages
  agents_short_name: string;

  // Agent color to be used in messages
  agents_vt_style: vt_style;
  
  // This method gets called by the agent at the start of test before any
  // of the agent TCMs get started. This can be extended by the user to
  // cause the agent to wait for some reset condition before starting.
  wait_for_reset() @p_sync.clk_r is {
    message(LOW, "Waiting for Reset done");
    wait until true (p_sync.reset_completed == TRUE);
    message(LOW, " Reset done");
  };
}; 

'>

