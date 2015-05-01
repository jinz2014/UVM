-----------------------------------------------------------------
File name     : ahb_agent_collector.e
Developers    : vishwana
Created       : Tue Mar 30 14:29:27 2010
Description   : This file implements the master collector,
              : which collectors the activity of its master agent.
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
-- Master collector unit derived from uvm_collector
-- ==========================================================================
unit ahb_agent_collector like uvm_collector {
 
  -- Signal map reference
  !p_smp      : ahb_smp;

  -- System signal map reference
  !p_sys_smp  : ahb_system_smp;
   
  -- The agent kind, determines the subtype of the collector
  agent_kind:   ahb_agent_kind;
  keep agent_kind in [DECODER,SLAVE,MASTER,ARBITER];
   
  -- Current transfer on the bus
  !cur_transfer: ahb_env_monitor_transfer;
    
  -- Used for selecting mode SIGNAL,ACCEL,TLM   
  abstraction_level : uvm_abstraction_level_t;    
    
  -- This port connects the collector to the scoreboard.
  -- Note that the scoreboard hook is bound to empty so that no error
  -- is issued if the hook is not in use.
  transfer_complete_o : out interface_port of tlm_analysis of ahb_env_monitor_transfer is instance;
  keep bind (transfer_complete_o, empty);
};

'>
