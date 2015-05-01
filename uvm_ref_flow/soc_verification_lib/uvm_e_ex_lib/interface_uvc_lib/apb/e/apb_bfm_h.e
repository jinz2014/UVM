/*-------------------------------------------------------------------------
File name   : apb_bfm_h.e
Title       : apb bfm 
Project     : APB UVC
Developers  : 
Created     :
Description : This file implements driver functionality.
Notes       : This file contains the unit extension of apb bfm for master and slave modes.
            :
---------------------------------------------------------------------------
Copyright 1999-2011 Cadence Design Systems, Inc.
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
-------------------------------------------------------------------------*/


<'

package apb;

// This unit is the generic BFM. It is used as the base type for all
// BFMs (MASTER, and SLAVE).
extend apb_bfm {
    
  // APB Environment Name
  env_name   : apb_env_name_t;
  
  // Backpointer to the apb env that contains this BFM. This field is constrained
  // from the env.
  p_env      : apb_env;
  
  // Reference to the apb bus monitor for this env
  p_bus_monitor : apb_bus_monitor;
  
  // Reference to the env signal map
  p_smp   : apb_smp;
     
  // This method init the bfm signals and variables values.
  //private init_values() is empty;  
  init_values() is empty;  

  init_link() is empty;  

  !reset_asserted : bool;
  
  // This event is the rising edge of the bus clock, unqualified by reset.
  event unqualified_clock_rise is rise(p_smp.sig_pclk$) @sim;

  // This event is the falling edge of the bus clock, unqualified by reset.
  event unqualified_clock_fall is fall(p_smp.sig_pclk$) @sim;

  // This event is the rising edge of the bus clock, qualified by reset.
  event clock_rise is true(not reset_asserted) @unqualified_clock_rise;

  // This event is the falling edge of the bus clock, qualified by reset.
  event clock_fall is true(not reset_asserted) @unqualified_clock_fall;

  // TestFlow Clocking : Un-Qualified clock is used for all TestFlow Phases
  event tf_phase_clock is only @unqualified_clock_rise;

}; 


// The MASTER BFM extends the generic BFM
extend apb_master_bfm {
    
  // Backpointer to the master agent
  p_master  : apb_master;
    
  // Reference to the sequence driver in the master agent
  p_driver      : apb_master_driver_u;
    
  !transaction : apb_master_transaction;
    
  p_ssmp : list of apb_slave_signal_map_u; 

  // testflow induced reset does not rerun the driver but might stop the bfm
  // before it emitted item_done event to the driver. since this causes an 
  // error, the following flag is needed to manually supply item_done in 
  // these cases.
  !item_done_not_set: bool;
    	
  // testflow main methods are expected to be found in the top portion of the
  // unit to better recognize the functional behavior of the unit
    
  tf_env_setup() @tf_phase_clock is also {
    // all ready signals start the test low.
    message(LOW, "Starting ENV_SETUP phase ");
    p_smp.sig_pready$ = 0;
  }; 
    
  tf_reset() @tf_phase_clock is also {
    p_smp.sig_presetn$ = 0;
  };

  tf_init_dut() @tf_phase_clock is also {
    // Intialize values
    message(LOW, "Starting INIT_DUT phase ");
    init_values()
  };

  tf_init_link() @tf_phase_clock is also {
    message(LOW, "Starting INIT_LINK phase ");
    init_link()
  };

  //------------------------------------------------------------------------------
  // Methods and TCMs declaration
  //--------------------------------------------------------------------------
    
  // This TCM continuously gets transactions from the driver and passes them
  // to the BFM.
  main_loop() @tf_phase_clock is empty;
  
  drive_transfer(cur_transaction : apb_trans_s) @tf_phase_clock is empty;
  get_selnum(ad: apb_addr_t): uint(bits:4) is empty;

  // This TCM drives the address of the transaction 
  drive_transaction_address (cur_transaction : apb_trans_s) 
    @tf_phase_clock is empty;
  
  // This TCM drives the data of the transaction 
  drive_transaction_data (cur_transaction : apb_trans_s) 
    @tf_phase_clock is empty;
};


// The SLAVE BFM extends the generic BFM
extend apb_slave_bfm {
        
  // Backpointer to the slave agent
  p_slave   : apb_slave; 
  
  // Reference to the sequence driver in the slave agent
  p_driver  : apb_slave_driver_u;
  
  p_ssmp : apb_slave_signal_map_u;

  !transaction_resp: apb_slave_transaction;

  //-------------------------------------------------------------------------
  // BFM methods and TCMs declaration
  //-------------------------------------------------------------------------
    
  // This TCM is the main BFM loop that continually detects transactions
  // received by this slave.
  main_loop()  @tf_phase_clock is empty;

  listen_and_respond() @tf_phase_clock is empty;   

  // For DUT slaves checking
  check_input(response : apb_data_t) is empty;
  check_output(response : apb_data_t, data_out : apb_data_t) is empty;
    
};

'>

