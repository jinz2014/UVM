---------------------------------------------------------------
File name   :  apb_master_bfm.e
Title       :  The MASTER BFM
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file adds master functionality to the generic BFM.
Notes       :  This file contains the method to drive address and data in case of master bfm whereas
            :  in case of slave bfm it has method to respond to apb transcation
---------------------------------------------------------------
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

---------------------------------------------------------------

<'

package apb;

// The MASTER BFM extends the generic BFM
extend apb_master_bfm {
    
  // Reference to the env signal map
  keep  p_smp  == p_env.smp;
  
  keep p_ssmp == p_env.ssmp;

  keep reset_asserted == value(p_env.reset_asserted);

  // Reference to the apb bus monitor for this env
  keep p_bus_monitor  == p_env.bus_monitor;

  tf_reset() @tf_phase_clock is also {
    message(LOW, "Starting RESET phase ");
    p_smp.sig_penable$ = 0;
  };

  tf_hard_reset() @tf_phase_clock is also {
    message(LOW, "Starting HARD_RESET phase ");
    p_smp.sig_presetn$ = 0;
  };

  tf_init_dut() @tf_phase_clock is also {
    p_smp.sig_presetn$ = 1;
  };


  // Run the main master BFM in MAIN_TEST phase.
  tf_main_test() @tf_phase_clock is also {
    message(LOW, "Master BFM started");
    start main_loop();
  }; -- tf_main_test()

  tf_finish_test() @tf_phase_clock is also {
    message(LOW, "Starting FINISH_TEST phase ");
  };

  tf_post_test() @tf_phase_clock is also {
    message(LOW, "Starting POST_TEST phase ");
  };

  // This TCM runs continually pulling sequence items from the sequence driver 
  // and passing them to the BFM
  main_loop () @tf_phase_clock is {

    RUN_IN_PHASES {MAIN_TEST;FINISH_TEST;POST_TEST} { 
      while TRUE {
        // here the proper emission of former item_done 
        // is checked and corrected if necessary
        if (not reset_asserted) { 
          if item_done_not_set then {
            emit p_driver.item_done;
            item_done_not_set = FALSE;
          };                
          var transaction := p_driver.get_next_item();
          // set item_done checker flag
          item_done_not_set = TRUE;
          drive_transaction(transaction);
          emit p_driver.item_done;
          // reset item_done checker flag
          item_done_not_set = FALSE;
        } else {
          wait cycle;
        }; // if (not reset
      };  //while
    }; -- Run phases
  }; -- main_loop()    
    
  // This TCM gets a transaction and drive it into the DUT
  drive_transaction (cur_transaction : apb_trans_s)
    @tf_phase_clock is {
    message(LOW, "Transaction started: ", cur_transaction.transaction_str());
    cur_transaction.start_transaction();
    wait [cur_transaction.transaction_delay] * cycle;
     
    -- Drive address signals
    drive_transaction_address(cur_transaction);
    -- Drive data signals
    drive_transaction_data(cur_transaction);
    init_values(); 
    message(LOW, "Transaction completed: ", cur_transaction.transaction_str());
    cur_transaction.end_transaction();
    
    wait cycle;
  };
    
  // This TCM drives the address of the transaction 
  drive_transaction_address (cur_transaction : apb_trans_s)
    @tf_phase_clock is {
       
    p_master.slave_number =  get_selnum(cur_transaction.addr);
    // Drive the address phase signals	
    p_env.smp.sig_pwrite$ = cur_transaction.direction;
    p_env.smp.sig_paddr$ = cur_transaction.addr;
    if cur_transaction.direction == WRITE {
      p_env.smp.sig_pwdata$ = cur_transaction.data;
    };
    p_env.smp.sig_penable$ = 0;
     
    message(MEDIUM,"SLAVE Selected by Master = ",p_master.slave_number);

    if p_env.p_memory_map.get_slave_id(cur_transaction.addr) != UNDEFINED {
      p_ssmp[p_master.slave_number].sig_psel$ = 1;
    };	
    
    wait cycle;
  
  };
  
  // This TCM drives the data of the transaction 
  drive_transaction_data (cur_transaction : apb_trans_s)
    @tf_phase_clock is {
    p_env.smp.sig_penable$ = 1;
    if bind(p_smp.sig_pready, external) {
      wait true(p_smp.sig_pready$ == 1);
    } else {
      wait cycle;
      wait cycle;
    };
    p_env.smp.sig_penable$ = 0;
    if cur_transaction.direction == READ {
      cur_transaction.data = p_env.smp.sig_prdata$;	
    };
    if p_env.p_memory_map.get_slave_id(cur_transaction.addr) != UNDEFINED {
      p_ssmp[p_master.slave_number].sig_psel$ = 0;
    };
  };

  get_selnum(ad: apb_addr_t): uint(bits:4) is {
    result = p_env.p_memory_map.get_slave_number(ad);
  };  

}; 

'>
