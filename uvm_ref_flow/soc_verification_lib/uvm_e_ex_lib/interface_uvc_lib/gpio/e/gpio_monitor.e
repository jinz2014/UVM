-----------------------------------------------------------------
File name     : gpio_monitor.e
Created       : Tue Jun 17 13:52:03 2008
Description   : This file implements the Interface monitor.
              : The Interface monitor monitors the activity of
              : its Interface agent.
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
package gpio;

extend gpio_transfer_kind_t : [MONITOR];

// GPIO transfer related to Monitor 
extend MONITOR gpio_transfer {
  !data_in : gpio_data_t;
  !data_oe : gpio_data_t;
};

// GPIO monitor unit derived from uvm_monitor unit
unit gpio_monitor like uvm_monitor {
 
  // Signal map reference
  !p_smp  : gpio_smp;
 
  // Flag to control the Protocol Checks
  has_checks : bool;
  keep soft has_checks == TRUE; 

  // Flag to control the coverage
  has_coverage : bool;
  keep soft has_coverage == TRUE;
  
  // transfer_complete is a TLM port is used to connect the monitor to the scoreboard
  // Note that the scoreboard hook is bound to empty so that no error is issued if the 
  // hook is not in use.
  transfer_complete : out interface_port of tlm_analysis of MONITOR gpio_transfer is instance;
  keep bind (transfer_complete, empty);
  
  // Current monitored transfer.
  !Interface_transfer : MONITOR gpio_transfer;
  
  // Event needed to trigger covergroups
  event cov_transfer;
  
  // run phase
  run() is also {     
      start collect_Interface_transfers();
  }; 
    
  // -----------------------------------------------------------------------
  // Modify the collect_Interface_transfers() method to match your protocol.
  // Note that if you change/add signals to the signal map file, you must
  // also change this method.
  // -----------------------------------------------------------------------
  collect_Interface_transfers() @p_smp.clk is {
    while TRUE {
      -- initialize the data item
      Interface_transfer = new MONITOR gpio_transfer with {
        it.data    = p_smp.sig_data_out$;
        it.data_in = p_smp.sig_data_in$;
        it.data_oe = p_smp.sig_data_oe$;
      };
      message(HIGH, "Interface transfer collected :", Interface_transfer.data);
      -- Emit coverage event
      emit cov_transfer;
      -- A call to the scoreboard hook TLM port
      transfer_complete$.write(Interface_transfer) ;
      wait cycle;
    };
  };
};

extend has_checks gpio_monitor {
  // -----------------------------------------------------------------------
  // Add protocol checks for the Interface monitor within this scope.
  // -----------------------------------------------------------------------
};

extend has_coverage gpio_monitor {
   
  // -----------------------------------------------------------------------
  // Modify coverage definitions by editing the coverage group below.
  // Note that you can also add new coverage groups and new coverage events.
  // -----------------------------------------------------------------------

  // Transfer collected coverage group
  cover cov_transfer using per_unit_instance is {
    item data : gpio_data_t = Interface_transfer.data using  
      radix = HEX,
      num_of_buckets = 4; 
    item data_in : gpio_data_t = Interface_transfer.data_in using  
      radix = HEX,
      num_of_buckets = 4; 
    item data_oe : gpio_data_t = Interface_transfer.data_oe using  
      radix = HEX,
      num_of_buckets = 4; 
  };
};

'>
