---------------------------------------------------------------
File name   : gpio_bfm.e
Created     : Tue Jun 17 13:52:03 2008
Description : This files implements the Interface bfm functionality
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

package gpio;

// GPIO Interface BFM unit derived from uvm_bfm
unit gpio_bfm like uvm_bfm {
    
  // ----------------------------------------------------------------------
  // Modify the following methods to match your protocol:
  //   - drive_transfer() - Handshake and transfer driving process
  //   - reset_signals() - Interface signal reset values 
  // Note that if you change/add signals to the signal map file, you must
  // also change these methods.
  // ----------------------------------------------------------------------

  // Reference to the signal map
  !p_smp  : gpio_smp;
    
  // Reference to the Interface sequence driver
  !p_sequencer : gpio_sequencer_u;

  // Current data item
  !transfer : gpio_transfer;
  
  // Set the message logger verbosity to MEDIUM
  logger : message_logger is instance;
  keep logger.verbosity == MEDIUM;    

  // Run phase
  run() is also {
    reset_signals();
    start get_and_drive();
  };
   
  // Reset all Interface signals
  reset_signals() is {
    p_smp.sig_data_out$ = 32'b0;
  }; 
   
  // --------------------------------------------
  // Gets transfers from the sequencer and passes
  // them to the BFM.
  // -----------------------------------------
  get_and_drive() @p_smp.clk is {
    while TRUE {
      // Receive the item from the sequence driver
      transfer = p_sequencer.get_next_item();
      // Call the method to drive the item
      drive_transfer(transfer);
      // Emit item_done
      emit p_sequencer.item_done;
    }; 
  }; 
    
  // Gets a transfer and drive it into the DUT
  drive_transfer (transfer : gpio_transfer) @p_smp.clk is {

    var my_oe : gpio_data_t = p_smp.sig_data_oe$;
    var my_bfm_data_in:gpio_data_t = p_smp.sig_data_in$;
    var my_bfm_data_out:gpio_data_t;
  
    message(MEDIUM,"Processing the Transfer");
    // wait till reset is out
    if p_smp.sig_reset$ != 0 {
      // if the chip is driving the pad
      for i from 0 to (GPIO_DATA_WIDTH - 1) do {
        if my_oe[i:i] == 0 {
          message(MEDIUM,"READING FROM CHIP");
          transfer.data[i:i] = my_bfm_data_in[i:i];
          my_bfm_data_out[i:i] = my_bfm_data_in[i:i];
        } else {
          // if the chip is reading from the pad
    	  message(MEDIUM,"WRITING TO CHIP");
    	  my_bfm_data_out[i:i] = transfer.data[i:i];
        };
      };
      p_smp.sig_data_out$ = my_bfm_data_out;
    };
    wait cycle;
  }; // drive_transfer()..
};  // unit gpio_bfm..



'>
