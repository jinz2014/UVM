---------------------------------------------------------------
File name   : ahb_master_bfm.e
Developers  : vishwana
Created     : Tue Mar 30 14:29:27 2010
Description : This file implements the master bfm functionality
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
-- The master BFM derived from uvm_bfm
--====================================================================
unit ahb_master_bfm like uvm_bfm {
    
  -- Reference to the signal map
  !p_smp      : ahb_smp;

  -- Reference to system signal map
  !p_sys_smp  : ahb_system_smp;
    
  -- Reference to the master sequence driver
  !p_driver      : ahb_master_seq_driver;
    
  -- Used for selecting mode SIGNAL,ACCEL,TLM   
  abstraction_level : uvm_abstraction_level_t;    
 
  -- Current data item
  !burst : ahb_master_driven_burst;
    
  -- Run phase
  run() is also {
    reset_signals();
    start get_and_drive();
  };
    
  -- Gets bursts from the driver
  -- and passes them to the BFM.
  get_and_drive() @p_sys_smp.clk is {
    while TRUE {
      burst = p_driver.get_next_item();
      drive_burst(burst);
      emit p_driver.item_done;
    }; 
  }; 
   
  -- Reset all slave signals
  reset_signals() is  empty ;
  drive_burst (burst : ahb_master_driven_burst) @p_sys_smp.clk is empty ;

};
    
extend ahb_master_bfm {
   
  -- Reset all master signals
  reset_signals() is {

    -- Use this section to initialize all the UVC ports that are
    -- derived by the master agent.
    -- To do so, edit the following example:

    p_smp.AHB_HTRANS$ = IDLE;
    p_smp.AHB_HLOCK$ = 0;  
    p_smp.AHB_HWDATA.put_mvl_list(32'b0);
  }; 
    
  -- Gets a burst and drive it into the DUT
  drive_burst (burst : ahb_master_driven_burst) @p_sys_smp.clk is {
      
    -- ------------------------------------------------------------------
    -- Use this section to drive the burst into the DUT.
    -- This section should include both the handshake and the 
    -- burst driving process.
            
    p_smp.AHB_HTRANS$ = NONSEQ;  
    p_smp.AHB_HWRITE$ = burst.direction;
    p_smp.AHB_HSIZE$ =  burst.size;  
    p_smp.AHB_HBURST$ = burst.kind ;  
    p_smp.AHB_HADDR$ =  burst.first_address;  

    wait true (p_smp.AHB_HREADY$ == 1);
      p_smp.AHB_HTRANS$ = IDLE;  
    if(burst.direction == WRITE) { 
      p_smp.AHB_HWDATA$ = burst.data[0];
      wait true (p_smp.AHB_HREADY$ == 1);
    } else {
      burst.data[0] = p_smp.AHB_HRDATA$  ;
    };
    wait cycle;         
    p_smp.AHB_HWDATA.put_mvl_list(32'b0);
  };  
}; 

'>
