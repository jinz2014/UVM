/*-------------------------------------------------------------------------
File name   :  uart_ctrl_env_h.e
Title       :  module uart env 
Project     :  Module UART
Developers  : 
Created     :
Description :  Module uart environment header file

Notes       : 
            :
-------------------------------------------------------------------------*/
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
// ----------------------------------------------------------------------

<'

package uart_ctrl_pkg;

// UART Module level environment derived from uvm_env
unit uart_ctrl_env_u like uvm_env {};

extend uart_ctrl_env_u {
 
  // Environment Name
  env_name : uart_mod_name_t;

  has_scbd : bool;
  keep soft has_scbd;

  has_vr_ad : bool;
  keep soft has_scbd;

  // Pointer to the apb_bridge environmant
  !apb_if: apb_env ;

  // Point to the UART synchronizer
  !uart_sync: uart_sync ;
  
  // Pointer uart env
  !uart_if: uart_env_u ;

  when has_vr_ad uart_ctrl_env_u {
    !p_addr_map : vr_ad_map;
  };
  
  // Message screen logger for thisagent
  logger: message_logger is instance;

  // Message file logger for this agent
  file_logger: message_logger is instance;
  keep soft file_logger.to_screen == FALSE;
  keep soft file_logger.to_file == "uart_ctrl_mod.elog";

  // Perform protocol checking
  has_monitor: bool;
  keep soft has_monitor == TRUE;

  // Use agent's short name in message
  short_name(): string is {
    return env_short_name;
  }; 
  
  // Use env_vt_style in message
  short_name_style() : vt_style is {
    return env_vt_style;
  };
   
  // Agents short name to be used in messages
  env_short_name: string;

  // Agent color to be used in messages
  env_vt_style: vt_style;
  
}; // extend uart_ctrl_env_u..


'>

