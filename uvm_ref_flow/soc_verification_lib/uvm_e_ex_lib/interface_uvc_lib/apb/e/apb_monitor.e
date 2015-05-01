---------------------------------------------------------------
File name   :  apb_monitor.e
Title       :  Bus and agent monitors implementation.
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file implements the bus monitor and agent monitor units.
Notes       :  This files contains monitor hooked to apb bus  and provides inputs to scoreboard
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

// Declare the monitor unit for the whole bus
extend apb_bus_monitor {
    
  !phase : apb_phase_t;

  !num_of_transfers :	uint;

  !cur_slave : int;

  has_protocol_checker : bool;
  keep soft has_protocol_checker;

  // Transfer properties
  cur_transfer : apb_trans_s;

  !transfers    : list of apb_trans_s;

  !tr_number    : int;  // current transfer number

  cur_transfer_slave : apb_slave_id_t; // slave target of  transfer

  log_transfer() is empty; // For Scoreboard :  This method is empty and is called on tr_ended

  event pclk_r is fall (p_env.smp.sig_pclk$); 
  
  event tr_started;

  event tr_enable;

  event tr_ended;

  event pclk_f;

  on tf_phase_clock {
    emit pclk_f;
  };

  event data_changed is change(p_env.smp.sig_prdata$)@tf_phase_clock;  // PWDATA changed

  event setting_up is  true (p_env.ssmp[cur_slave].sig_psel$ == 1'b1)@tf_phase_clock;

  event enable_up is true(p_env.smp.sig_penable$ == 1'b1) and true (p_env.ssmp[cur_slave].sig_psel$ == 1'b1)@tf_phase_clock;
  
  event new_setup is fall(p_env.smp.sig_penable$) and not fall (p_env.ssmp[cur_slave].sig_psel$)@tf_phase_clock;

  event go_to_sleep is fall(p_env.smp.sig_penable$) and fall (p_env.ssmp[cur_slave].sig_psel$)@tf_phase_clock;

  evaluate_state()@tf_phase_clock is {
    state machine phase {
      IDLE  => SETUP { wait @setting_up;message(MEDIUM,"1 - IDLE to SETUP "); emit tr_started; };
      SETUP => ENABLE { wait @enable_up;message(MEDIUM,"2 - SETUP to ACCESS/ENABLE ");wait;emit tr_enable; }; 
      ENABLE => IDLE {sync @go_to_sleep;message(MEDIUM,"4 - ACCESS/ENABLE to IDLE ");emit tr_ended;};
      ENABLE => SETUP {wait  @new_setup;message(MEDIUM,"3 - ACCESS/ENABLE to SETUP ");emit tr_ended; emit tr_started;};
    };
  };

  // Protocol check
  event bus_phase;

  tf_main_test()@tf_phase_clock is also {
    start evaluate_state();
  };
   
  on tf_phase_clock {
    for i from 0 to p_env.slaves.size() - 1{
      if p_env.ssmp[i].sig_psel$==1 {
        set_cur_slave(i);
        break;
      };
    };
  };

  // Method set_cur_slave would use address map to find the slave id
  set_cur_slave(i : int) is {
    cur_slave = i;
  };
        
  // selected_slave()
  selected_slave(): apb_slave_id_t is {
    result = UNDEFINED;
    for i from 0 to p_env.slaves.size() - 1{
      if p_env.ssmp[i].sig_psel$ == 1 {
        result = p_env.all_slave_names[i];
        break;
      };
    };
  };
    
  on tr_started {
    num_of_transfers += 1;
  };

  on tr_started {  
    cur_transfer = new apb_trans_s with {
      it.addr = p_env.smp.sig_paddr$;
      it.direction = p_env.smp.sig_pwrite$;
      it.data = p_env.smp.sig_pwdata$;
      it.slave_number = selected_slave();       
    };
    message(MEDIUM,"Transfer started");
  };

  on tr_enable {
    // Update transfer data
    if cur_transfer != NULL {
      if cur_transfer.direction == READ {
        //for read data might only be valid around posedge of PCLK.
        cur_transfer.data = p_env.smp.sig_prdata$;
      };
    } else {
      dut_error("Current Transfer is NULL on Transfer Enable");
    };
  };

  on tr_ended { 
    // Update transfer data
    if cur_transfer != NULL {
      if cur_transfer.direction == READ {
        if bind(p_env.smp.sig_pslverr, external) {
          cur_transfer.err = p_env.smp.sig_pslverr$.as_a(bool);
        };
      };
      if p_env.log_enable {
        transfers.add(cur_transfer.copy());
      };
    } else {
      dut_error("Current Transfer is NULL on Transfer Ended");
    };
    
    log_transfer(); 
    transaction_complete$.write(cur_transfer);
  };// on tr_ended    	
};

'>

