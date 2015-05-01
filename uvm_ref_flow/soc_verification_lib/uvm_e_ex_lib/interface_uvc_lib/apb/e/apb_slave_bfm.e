---------------------------------------------------------------
File name   :  apb_slave_bfm.e
Title       :  The slave BFM
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file adds slave functionality to the generic BFM.
Notes       :  This file contains method to respond to apb transaction in slave mode 
 
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

//====================================================================
// The slave BFM extends the generic BFM
//====================================================================
extend apb_slave_bfm {

  !return_value : apb_data_t;

  !err : bool;

  keep p_ssmp == p_env.ssmp.first(.id== me.p_slave.id);

  // Reference to the env signal map
  keep  p_smp  == p_env.smp;
  
  // Reference to the apb bus monitor for this env
  keep p_bus_monitor  == p_env.bus_monitor;

  keep reset_asserted == value(p_env.reset_asserted);
 
  // testflow induced reset does not rerun the driver but might stop the
  // bfm before it emitted item_done event to the driver. since this 
  // causes an error, the following flag is needed to manually supply 
  // item_done in these
  // cases.
  !item_done_not_set: bool;

  // testflow main methods are expected to be found in the top portion of the
  // unit to better recognize the functional behavior of the unit
  // Run the main slave BFM in MAIN_TEST phase.
  tf_main_test() @tf_phase_clock is also {
    // This unit is a slave unit, and must not block the test flow.
    // So it starts the method hence leaving the testflow phases
    // (will not prevent the phase ending)
    start listen_and_respond();
  }; // tf_main_test()

  tf_hard_reset() @tf_phase_clock is also {
    p_smp.sig_presetn$ = 0;
  };

  tf_init_dut() @tf_phase_clock is also {
    p_smp.sig_presetn$ = 1;
  };

  tf_reset() @tf_phase_clock is also {
    p_smp.sig_penable$ = 0;
    p_smp.sig_pready$ =0;
  };

	 
  listen_and_respond() @tf_phase_clock is {
   
    var reply_delay : uint;

    message(LOW, "Slave BFM started");
        
    // Using a macro is defined in tf_utils.e. It stops execution of the 
    // infinite loop if the phase is different from the supplied list 
    RUN_IN_PHASES {MAIN_TEST; FINISH_TEST} { 	     

      while (TRUE) {

        if bind(p_env.smp.sig_pready, external) {
	  p_env.smp.sig_pready$ = 1;
	};

        wait true (p_ssmp.sig_psel$ == 1 and p_env.smp.sig_penable$ ==1 );

        gen reply_delay keeping {
          it in [0..4];
	};
      		
        if bind(p_env.smp.sig_pready, external) {
	  p_env.smp.sig_pready$ = 0;
	  wait [reply_delay];
	  p_env.smp.sig_pready$ = 1;
	};

	gen err;

	if err {
   	  if bind(p_env.smp.sig_pslverr, external) {
	    p_env.smp.sig_pslverr$ = 1;
	  };
	};

	if p_env.smp.sig_pwrite$ == WRITE {
          get_data()
        } else {
          put_data();
        };

        wait cycle;
		
	if bind(p_env.smp.sig_pslverr, external) {
	  p_env.smp.sig_pslverr$ = 0;
        };
      };// while
    };// RUN_PHASE
  };// listen_and respond


  get_data() is {
    message(LOW,append("Slave "," received:",p_env.smp.sig_pwdata$, " for write"));
    check_input(p_env.smp.sig_pwdata$);
  };
  
  put_data() is {
    gen return_value;
    p_env.smp.sig_prdata$ = return_value;
    message(LOW,append("debug Slave ",p_slave.id , " sends:",hex(return_value), " for read"));
    check_output(p_env.smp.sig_prdata$, p_env.smp.sig_prdata$);
  };          

};  // extend apb_slave_bfm..

'>


