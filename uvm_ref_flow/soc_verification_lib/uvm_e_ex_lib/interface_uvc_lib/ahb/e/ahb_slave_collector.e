-----------------------------------------------------------------
File name     : ahb_slave_monitor.e
Developers    : vishwana
Created       : Tue Mar 30 14:29:27 2010
Description   : This file implements the slave monitor.
              : The slave monitor monitors the activity of
              : its slave agent.
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
-- SLAVE monitor unit. 
-- ==========================================================================
extend SLAVE ahb_agent_collector {

  -- Run phase
  run() is also {     
    start collect_slave_response();
  };

  -- Collect slave transfer (response)
  collect_slave_response() @p_sys_smp.clk is {
    while TRUE {

      -- Use this section to collect slave transfers.
      wait true(p_smp.AHB_HTRANS$ == NONSEQ);
      cur_transfer = new ahb_env_monitor_transfer with {
        it.kind      = p_smp.AHB_HTRANS$ ; 
        it.direction = p_smp.AHB_HWRITE$ ; 
        it.size      = p_smp.AHB_HSIZE$ ;  
        it.address   = p_smp.AHB_HADDR$ ;  
      };
      wait true(p_smp.AHB_HREADY$ == 1);
      if(cur_transfer.direction == WRITE) { 
        cur_transfer.data = p_smp.AHB_HWDATA$;
      } else {
        cur_transfer.data = p_smp.AHB_HRDATA$;
      };
      message(HIGH,"Slave transfer collected :", cur_transfer.data);
      -- A call to the scoreboard hook method port
      transfer_complete_o$.write(cur_transfer); 
    };
  };
};

'>
