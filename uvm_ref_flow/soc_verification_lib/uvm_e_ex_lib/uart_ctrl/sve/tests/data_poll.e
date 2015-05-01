/*-------------------------------------------------------------------------
File name   : data_poll.e
Title       : uart functionality 
Project     : Module UART
Created     :
Description : This test exercises the UART by sending frames and polling for 
              received frames 
Notes       :  
            :
//---------------------------------------------------------------------------
// Copyright 1999-2010 Cadence Design Systems, Inc.
// All Rights Reserved Worldwide
//
// Licensed under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of
// the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in
// writing, software distributed under the License is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied.  See
// the License for the specific language governing
// permissions and limitations under the License.
//------------------------------------------------------------------------*/

<'

// Imports some common code for all tests that use data-polling
import data_poll_common;

//--------------------------------------------
// Send Data from UART UVC to DUT
//--------------------------------------------
extend MAIN uart::uart_sequence {

  // Packet Count
  tx_count: uint;
  keep soft tx_count == 10;

  body() @driver.clock is only {

    driver.raise_objection(TEST_DONE);
    
    // Wait for the UART Config to complete
    wait @sys.VR_SB_uart_config_done;

    for i from 0 to tx_count {
      do frame keeping {
        it.has_startbit_err == FALSE;
      };
    };

    emit sys.VR_SB_uart_data_done;
    wait @sys.VR_SB_uart_read_done;
    driver.drop_objection(TEST_DONE);
  }; 
};


// Purpose of MAIN MAIN_TEST Sequence is to launch
// random activity in phase MAIN_TEST. The predefined
// behavior of MAIN MAIN_TEST sequence is identical to
// that of MAIN Sequence.
extend MAIN MAIN_TEST apb_master_sequence {

  !fifowr: FIFOWR apb::apb_master_sequence;   
  !fiford: FIFORD apb::apb_master_sequence;   

  body() @driver.clock is also {

    do fifowr;
    wait @sys.VR_SB_uart_data_done;

    do fiford;
    emit sys.VR_SB_uart_read_done;

  }; 
};


// Restrict to ODD and EVEN parity
extend uart_env_config {
  keep parity_type in [ODD,EVEN];
};

// Send both legal and illegal frames, but mostly legal frames
extend uart_frame_s {

  keep soft legal_frame == select {
    2 : FALSE;
    8 : TRUE;
  };
};

'>

