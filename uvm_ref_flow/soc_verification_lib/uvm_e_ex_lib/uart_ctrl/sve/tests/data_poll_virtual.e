/*-------------------------------------------------------------------------
File name   : data_poll_virtual.e
Title       : uart functionality 
Project     : Module UART
Created     :
Description : This test exercises the UART by sending frames and polling for 
              received frames using virtual sequence
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

package uart_ctrl_pkg;

extend sys {

  //-----------------------------------------------
  // events to signify config & reset done
  //-----------------------------------------------
  event VR_SB_uart_config_done;
  event reset_done is @uart_ctrl_sve.uart_sync.reset_ended;

  // For long test,therefore extend the tick_max value
  setup() is also {
    set_config(run, tick_max, MAX_INT);
  };
};


// Restrict to ODD and EVEN parity
extend uart_env_config {
  keep parity_type in [ODD, EVEN];
};


// MAIN sequence
extend MAIN uart_ctrl_sequence {

  !uart_config  : UART_CONFIG vr_ad_sequence;
  keep uart_config.driver == read_only(driver.vr_ad_seq_drv);
  keep uart_config.uart_config == get_enclosing_unit(uart_ctrl_sve_u).uart_if.config;
  keep uart_config.reg_file == driver.vr_ad_seq_drv.addr_map.get_reg_file_by_address(UART_BASE_ADDR);

  !uart_traffic  : UART_TRAFFIC uart::uart_sequence;
  keep uart_traffic.driver == read_only(driver.uart_seq_drv);

  !fiford: FIFORD apb::apb_master_sequence;   
  keep fiford.driver == read_only(driver.apb_seq_drv); 

  !fifowr: FIFOWR apb::apb_master_sequence;   
  keep fifowr.driver == read_only(driver.apb_seq_drv); 

  body() @driver.clock is only {

    wait [50] * cycle;

    do uart_config;   
    wait [50] * cycle;

    do fifowr; 
    wait [50] * cycle;

    do uart_traffic;
    wait [50] * cycle;

    do fiford;
    wait [50] * cycle;

    do uart_traffic;
    wait [50] * cycle;

    do fiford;

   };
}; // end MAIN sequence


//------------------------------------------------------
// body() of the sub-sequences are made empty
//------------------------------------------------------
extend MAIN vr_ad_sequence {
  body() @driver.clock is only {};
};

// When using the Virtual Sequence to solely control the 
// environment behavior , we need to NULL the body() methods
// of all 8 sub-phases within the environment
extend MAIN ENV_SETUP apb_master_sequence {
  body() @driver.clock is only {};
};

extend MAIN HARD_RESET apb_master_sequence {
  body() @driver.clock is only {};
};

extend MAIN RESET apb_master_sequence {
  body() @driver.clock is only {};
};

extend MAIN INIT_DUT apb_master_sequence {
  body() @driver.clock is only {};
};

extend MAIN INIT_LINK apb_master_sequence {
  body() @driver.clock is only {};
};

extend MAIN MAIN_TEST apb_master_sequence {
  body() @driver.clock is only {};
};

extend MAIN FINISH_TEST apb_master_sequence {
  body() @driver.clock is only {};
};

extend MAIN POST_TEST apb_master_sequence {
  body() @driver.clock is only {};
};

extend MAIN uart::uart_sequence {
  body() @driver.clock is only {};
};

'>


