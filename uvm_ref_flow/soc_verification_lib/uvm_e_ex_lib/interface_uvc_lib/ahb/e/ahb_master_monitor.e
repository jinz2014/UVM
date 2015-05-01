-----------------------------------------------------------------
File name     : ahb_master_monitor.e
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
-- master monitor unit.
-- ==========================================================================
extend MASTER'agent_kind ahb_agent_monitor {
  
  // MASTER Collector Agent instance
  collector : MASTER'agent_kind ahb_agent_collector is instance;
  keep collector.abstraction_level == read_only(abstraction_level) ;

  // Binding the Signals maps using connect_pointers()
  connect_pointers() is also {
    collector.p_smp = p_smp;
    collector.p_sys_smp = p_sys_smp;
  };

  // Binding the TLM ports
  connect_ports() is also {
    collector.transfer_complete_o.connect(transfer_complete_i);
  };
};


extend has_checks MASTER'agent_kind ahb_agent_monitor {
  -- ***********************************************************************
  -- -----------------------------------------------------------------------
  -- Add protocol checks for the Interface monitor within this scope.
  -- ***********************************************************************
};

extend has_coverage MASTER'agent_kind ahb_agent_monitor {

  // Coverage event for master transfer
  event master_cov_transfer ;

  on cov_transfer {
    emit master_cov_transfer ;
  };
   
  -- ***********************************************************************
  -- -----------------------------------------------------------------------
  -- Modify coverage definitions by editing the coverage group below.
  -- Note that you can also add new coverage groups and new coverage events.
  -- ***********************************************************************

  -- transfer collected coverage group
  cover master_cov_transfer using per_unit_instance is {

    // Address
    item address : uint = cur_transfer.address using radix = HEX 
    , ranges = {
               range ([0x0..0x7FFFFFFF]);
               range ([0x80000000..0xffffffff]);
    };

    // Transfer Kind
    item kind : ahb_transfer_kind = cur_transfer.kind;
    // Transfer Direction
    item direction : ahb_direction = cur_transfer.direction;
  };
};

'>
