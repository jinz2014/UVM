---------------------------------------------------------------
File name   :  ahb_slave_bfm.e
Developers  :  vishwana
Created     :  Tue Mar 30 14:29:27 2010
Description :  This files implements the slave bfm
Notes       :  
---------------------------------------------------------------
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
---------------------------------------------------------------

<'

package ahb;

--====================================================================
-- The slave BFM derived from uvm_bfm
--====================================================================
unit ahb_slave_bfm like uvm_bfm {
    
  -- Reference to the env signal map
  !p_smp       : ahb_smp;

  -- Reference to System Signal Map
  !p_sys_smp   : ahb_system_smp;
    
  -- Reference to the slave sequence driver
  !p_driver    : ahb_slave_driver_u;
      
  -- Current response
  !resp : ahb_slave_driven_burst;
    
  -- Used for selecting mode SIGNAL,ACCEL,TLM   
  abstraction_level : uvm_abstraction_level_t;    

  -- Run phase
  run() is also {
    reset_signals();
    start get_and_drive();
  }; 
    
  -- Continually detects transfers
  get_and_drive()  @p_sys_smp.clk is {
    while TRUE {
      resp = p_driver.try_next_item();
      -- In case the get_next_item result is NULL
      -- we create a default transfer
      var default_resp : bool;
      if resp == NULL then {
        default_resp = TRUE;
        resp = new ahb_slave_driven_burst; 
      };
      respond_transfer(resp);
      if not default_resp {
        -- Inform the sequence driver that the response is over.
        emit p_driver.item_done;
      };
    };
  }; 
  
  -- Reset all slave signals
  reset_signals() is  empty ;
    
  -- Response to a transfer from the DUT
  respond_transfer (response : ahb_slave_driven_burst) @p_sys_smp.clk is empty ;

};

extend ahb_slave_bfm {
    
  reset_signals() is only {
    -- Use this section to initiate all the UVC ports that are derived by
    -- the slave agent.
    p_smp.AHB_HREADY$ = 1;  
    p_smp.AHB_HRESP$  = OKAY;
  };   
    
    
  -- Response to a transfer from the DUT
  respond_transfer (response : ahb_slave_driven_burst) @p_sys_smp.clk is only {
  
    -- ------------------------------------------------------------------
    -- Use this section to drive the response to transfer.
    -- ------------------------------------------------------------------
    wait true (p_smp.AHB_HTRANS$ == NONSEQ);        
    if(response.response_delay > 0) {
      p_smp.AHB_HREADY$ = 0;
      wait [response.response_delay] * cycle;
    } else {
      wait cycle;
    };
    p_smp.AHB_HRDATA$ = response.data[0]  ;
    if(response.transfers[0].response != OKAY) {
      p_smp.AHB_HREADY$ = 0;
      p_smp.AHB_HRESP$  = response.transfers[0].response;
      wait cycle;
    };
    p_smp.AHB_HREADY$ = 1;
    wait cycle;
    p_smp.AHB_HRESP$  = OKAY;
  }; 
};

'>
