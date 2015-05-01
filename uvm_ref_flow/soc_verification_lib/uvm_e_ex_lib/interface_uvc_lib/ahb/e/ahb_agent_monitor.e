-----------------------------------------------------------------
File name     : ahb_agent_monitor.e
Developers    : vishwana
Created       : Tue Mar 30 14:29:27 2010
Description   : This file implements the master monitor,
              : which monitors the activity of its master agent.
Notes         :
-----------------------------------------------------------------
Copyright 1999-2010 Cadence Design Systems, Inc.
All Rights Reserved Worldwide

Licensed under the Apache License, Version 2.0 (the
"License"); you may not use this file except in
compliance with the License.  You may obtain a copy of
the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in
writing, software distributed under the License is
distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See
the License for the specific language governing
permissions and limitations under the License.
-----------------------------------------------------------------

<'

package ahb;

-- ==========================================================================
-- Master monitor unit derived from uvm_monitor
-- ==========================================================================
unit ahb_agent_monitor like uvm_monitor {
 
  -- Signal map reference
  !p_smp      : ahb_smp;

  -- System Signal map reference
  !p_sys_smp  : ahb_system_smp;
   
  -- Current transfer ended
  event tr_ended;      

  -- The agent kind, determines the subtype of the monitor
  agent_kind:     ahb_agent_kind;
  keep agent_kind in [DECODER,SLAVE,MASTER,ARBITER];
   
  -- Current transfer on the bus
  !cur_transfer: ahb_env_monitor_transfer;
    
  -- The following two fields control whether checks and coverage
  -- are performed by the monitor.
  has_checks : bool;
  keep soft has_checks == TRUE;

  has_coverage : bool;
  keep soft has_coverage == TRUE;
  
  -- Used for selecting mode SIGNAL,ACCEL,TLM   
  abstraction_level : uvm_abstraction_level_t;    
  
  -- Event needed to trigger covergroups
  event cov_transfer;
  
  -- This port connects the monitor to the scoreboard.
  -- Note that the scoreboard hook is bound to empty so that no error
  -- is issued if the hook is not in use.
  monitor_transfer_o : out interface_port of tlm_analysis of ahb_env_monitor_transfer is instance;
  keep bind (monitor_transfer_o , empty);

  -- This port connects the monitor to the collector .
  transfer_complete_i : in interface_port of tlm_analysis of ahb_env_monitor_transfer is instance;
  keep bind (transfer_complete_i, empty);
    
  -- when getting transfer from lower level - perform some analysis,
  -- and write to port to higher level
  write(new_transfer : ahb_env_monitor_transfer) is {
    cur_transfer = new_transfer;
    emit tr_ended;
    emit cov_transfer;
    -- Write to port, for higher levels to get
    monitor_transfer_o$.write(cur_transfer);
  };
};

'>
