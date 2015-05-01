/*-----------------------------------------------------------------
File name     : uart_bfm_tx.e
Title         : UART TX Bus Functional Model
Project       :
Created       : Wed Feb 18 10:46:07 2004
Description   : 
Notes         : 
-------------------------------------------------------------------*/
//  Copyright 1999-2010 Cadence Design Systems, Inc.
//  All Rights Reserved Worldwide
//
//  Licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in
//  compliance with the License.  You may obtain a copy of
//  the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in
//  writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//  CONDITIONS OF ANY KIND, either express or implied.  See
//  the License for the specific language governing
//  permissions and limitations under the License.
//----------------------------------------------------------------------

<'

package uart;

// TX BFM
extend TX uart_bfm_u {
 
  // Get frames from the sequence-driver and send them to the DUT
  execute_items() @p_sync.clk_r is {

    while (TRUE) do {
      cur_frame = p_agent.driver.get_next_item();
      drive_frame(cur_frame);
      emit p_agent.driver.item_done;
    }; // while (TRUE)

  };
    
  // Drive a frame into the DUT
  drive_frame(cur_frame : uart_frame_s) @p_sync.clk_r is  {

    //  when clear to send low, the uart starts to send data
    sync true(ssmp.sig_sec_cdma_ctsb$ == 0); 
        
    message(MEDIUM, "BFM uart tx start send frame ", cur_frame ,"data : ",cur_frame.payload);
    var bit_stream : list of bit = pack(packing.low, cur_frame);
    message(LOW, "BFM Tx frame is ", cur_frame.payload);

    wait [cur_frame.delay_to_next_frame] * cycle;

    emit bfm_trans_started;	// start send uart frame
 
    // Send each bit of the data-stream
    for each in bit_stream {
      ssmp.sig_sec_cdma_tx_data$ = it;
      wait [16] * cycle;	// next Baud-rate cycle
    };
    
    emit bfm_trans_ended;	 // end send uart frame
    message(MEDIUM, "BFM uart tx finish send frame ", cur_frame);
  };

}; // TX BFM


'>
