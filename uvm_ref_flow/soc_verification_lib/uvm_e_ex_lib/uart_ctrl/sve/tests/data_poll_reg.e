/*-------------------------------------------------------------------------
File name   :  data_poll_reg.e
Title       :  uart functionality 
Project     :  Module UART
Created     :
Description : This test exercises the UART by sending frames and polling for 
              received frames. Uart registers are polled in the testcase
Notes       :  
----------------------------------------------------------------------*/
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
// ----------------------------------------------------------------------

<'

extend sys {

  // -----------------------------------------------
  // events to signify config & reset done
  // -----------------------------------------------
  event VR_SB_uart_config_done;
  event VR_SB_uart_data_done;
  event VR_SB_uart_read_done;
  event VR_SB_uart_div_config_done;
  event reset_done is @uart_ctrl_sve.uart_sync.reset_ended;

  // Extending the tick_max for long running sim
  setup() is also {
    set_config(run, tick_max, 400000);
  };
};

//------------------------------------------------------
// Use a predefined config sequence to configure the DUT
// vr_ad MAIN sequence
//------------------------------------------------------
extend MAIN vr_ad_sequence {

  // uart config sequence
  !uart_config : UART_CONFIG vr_ad_sequence;
  keep uart_config.uart_config == get_enclosing_unit(uart_ctrl_sve_u).uart_if.config;
  keep uart_config.reg_file == driver.addr_map.get_reg_file_by_address(UART_BASE_ADDR);


  body() @driver.clock is only {

    driver.raise_objection(TEST_DONE);
    wait [50] * cycle;
    do uart_config;
    wait [50] * cycle;
    emit sys.VR_SB_uart_config_done;
    driver.drop_objection(TEST_DONE);
  };
};

// uart MAIN sequence
extend MAIN uart::uart_sequence {

  tx_count: uint;
  keep soft tx_count == 10;

  body() @driver.clock is only {

    driver.raise_objection(TEST_DONE);
    wait @sys.VR_SB_uart_config_done;

    for i from 0 to tx_count {
      do frame keeping {
        it.has_startbit_err == FALSE;
      };
    };

    emit sys.VR_SB_uart_data_done;
    wait @sys.VR_SB_uart_read_done;

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

// Restrict to ODD and EVEN parity
extend uart_env_config {
  keep parity_type in [ODD, EVEN];
};

//-------------------------------------------------------
// AHB Sequence to poll UART registers:
//-------------------------------------------------------

extend MAIN MAIN_TEST apb_master_sequence {

  !fifowr: FIFOWR apb::apb_master_sequence;   
  !fiford: FIFORD apb::apb_master_sequence;   

  body() @driver.clock is only {

    wait @sys.VR_SB_uart_config_done;
    do fifowr;

    wait @sys.VR_SB_uart_data_done;
    do fiford;
    emit sys.VR_SB_uart_read_done;
    wait @sys.VR_SB_uart_data_done;
    do fiford;
    emit sys.VR_SB_uart_read_done;

  };
};

'>

