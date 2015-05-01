/*-------------------------------------------------------------------------
File name   :  test_uart.e
Title       :  Datalen error 
Project     :  Module UART
Created     :
Description :  This is a Negative Testcase where datalen error
               is introduced
Notes       :  Module Level UVM scoreboard,if enabled,should throw 
               packet mismatch error for this test.
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

// Import some base test code
import data_poll_reg;

extend uart_env_config {
  keep databit_type == EIGHT;
};

extend UART_CONFIG'kind vr_ad_sequence {

  body() @driver.clock is also {

    // DataLen Error is introduced
    datalen_val= 1;

    // Data to be Written into the Line Control Register
    line_ctrl_val = pack(packing.high, 3'b0, parity_val , parity_sel, stopbit_val, datalen_val );

    // Register Write
    write_reg line_ctrl_reg value line_ctrl_val;

  };
};

'>



