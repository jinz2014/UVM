/*-----------------------------------------------------------------
File name     : uart_bfm_rx.e
Title         : UART RX Bus Functional Model
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

// RX BFM unit
extend RX uart_bfm_u {

  // Receive the item from the sequence driver and drive
  execute_items() @p_sync.clk_r is {

    var cur_trans : uart_rx_resp_s;

    while (TRUE) do {
      cur_trans = p_agent.driver.get_next_item();
      emit p_agent.driver.item_done;
      drive_frame(cur_trans.num_of_frames,cur_trans.delay_bt_frame);
    }; // while (TRUE)
  }; // execute_items()



  // Driving the Frame data  
  drive_frame(num : uint, delay_between_frames:uint) @p_sync.clk_r is  {

    var cur_fsize := bit_size();
    sync true(ssmp.sig_sec_cdma_rfrb$ == 1); 

    // just wait for the last byte has been taken out, not synchronize
    message(MEDIUM, "BFM uart RX strat drive RFRB low ");
    ssmp.sig_sec_cdma_rfrb$ = 0; 
    emit bfm_trans_started;  // start send uart frame 
    wait [num*cur_fsize] * cycle;
    ssmp.sig_sec_cdma_rfrb$ = 1; 
    emit bfm_trans_ended;    // end send uart frame
    message(MEDIUM, "BFM uart RX drive FRRB high ");
    wait [delay_between_frames]*cycle;
  };

};// end RX bfm

'>
