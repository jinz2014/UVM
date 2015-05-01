/*-------------------------------------------------------------------------
File name   : apb_subsystem_ahb_methods.e
Title       : APB Subsystem Scoreboard Hook
Project     :
Created     : November 2010
Description : Extension to AHB monitor in order to pass information
              to the user scoreboard through TLM ports
Notes       : 
-------------------------------------------------------------------------*/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------



<'

package apb_subsystem_pkg;

import ahb/e/ahb_agent_monitor;

extend ahb_agent_monitor {
  has_apb_subsystem_scoreboard_hook : bool;
  keep soft has_apb_subsystem_scoreboard_hook == FALSE;
};

//---------------------------------------------------------------------
// Get the AHB read data when a read is performed.This is required to 
// provide the data for the scoreboard.TLM ports are used to pass the 
// collected data.
//---------------------------------------------------------------------
extend has_apb_subsystem_scoreboard_hook ahb_agent_monitor {
   
  evc_to_duv_apb_in: out interface_port of tlm_analysis of ahb_env_monitor_transfer is instance;
  keep bind(evc_to_duv_apb_in, empty);

  duv_to_evc_apb_in: out interface_port of tlm_analysis of ahb_env_monitor_transfer is instance;
  keep bind(duv_to_evc_apb_in, empty);

  reg_apb_out: out interface_port of tlm_analysis of ahb_env_monitor_transfer is instance;
  keep bind(reg_apb_out, empty);

  do_scoreboard_hook() is {

    // Pass the Read Data through the TLM port
    if (cur_transfer.direction == READ) then { 
      evc_to_duv_apb_in$.write(cur_transfer); 
    };

    // Write to Tx buffer
    if  (cur_transfer.direction == WRITE) then  { 
      duv_to_evc_apb_in$.write(cur_transfer);
    };

    reg_apb_out$.write(cur_transfer);

  };      

  on tr_ended { 
    do_scoreboard_hook();
  };  

};


'>
