/*-------------------------------------------------------------------------
File name   : uart_ctrl_monitor.e
Title       : Uart environement
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the uart module UVC monitor

Notes       : Unit for module uart environment
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

// UART-control Monitor unit derived from uvm_monitor
unit uart_ctrl_monitor_u like uvm_monitor {

  has_vr_ad : bool;
  keep soft has_vr_ad;

  has_scbd : bool;
  keep soft has_scbd;

  // Collect coverage
  has_coverage: bool;
  keep soft has_coverage == TRUE;

  p_env : uart_ctrl_env_u;

  // UART-Control Scoreboard implemented using UVM-Scoreboard
  when has_scbd uart_ctrl_monitor_u {
    uart_ctrl_scbd : uart_ctrl_scoreboard is instance;
  };

  // switch to control coverage
  when has_coverage uart_ctrl_monitor_u {
    uart_ctrl_env_cov : uart_ctrl_env_cover_u is instance;
    keep soft uart_ctrl_env_cov.hdl_path() == "";
  };

};



'>
