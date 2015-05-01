/*-----------------------------------------------------------------
File name     : uart_config.e
Title         : UART Configuration
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

struct uart_env_config {

  // The logical name of this eVC instance
  evc_name:   uart_env_name_t;
  
  parity_type  : uart_frame_parity_t;
  stopbit_type : uart_frame_stopbit_t;
  databit_type : uart_frame_databit_t;

  baud_rate :  uart_baud_rate_t;
  keep soft baud_rate == BAUD_9600;

  rx_enable : bit;
  keep  rx_enable == 1'b1;

  tx_enable : bit;
  keep tx_enable == 1'b1;

  // data check in monitor
  rxres : bit;
  keep soft rxres == 1'b0;

  txres : bit;
  keep soft txres == 1'b0;

  rxdis : bit;
  keep soft rxdis == 1'b0;

  txdis : bit;
  keep soft txdis == 1'b0;

  rstto : bit;
  keep soft rstto == 1'b0;

  sttbrk : bit;
  keep soft sttbrk == 1'b0;

  stpbrk : bit;
  keep soft stpbrk == 1'b0;

  cd : uint (bits :16);
  keep soft cd == 0x01;

  dtr : uint (bits:1);
  keep soft dtr == 1'b0;

  rts : uint (bits:1);
  keep soft dtr == 1'b0;

  fcm : uint (bits:1);
  keep soft fcm == 1'b1;

  check_protocol:bool;
  keep soft check_protocol == TRUE;
  
  // Determines the end of the test condition
  stop_condition: uart_end_cond_t;
  keep soft stop_condition == CYCLES;

  // The number of cycles until ending the test
  test_time: uint;
  keep soft test_time == 2000;


  //------------------------------------------------------------
  // test_header
  // 
  // When test start write a descriptive header 
  // (about env. config).
  //------------------------------------------------------------
  test_header() is {
    message(LOW,"****************************************************************");
    message(LOW,"*******************  Started an UART test **********************");
    message(LOW,"****************************************************************");
    message(LOW,"eVC name:                   ",evc_name); 
    message(LOW,"Test time:                  ",sys.time);
    message(LOW,"Parity type:                ", parity_type);
    message(LOW,"Stop bit type:              ", stopbit_type);
    message(LOW,"Payload type:               ", databit_type);
    message(LOW,"Stop condition:             ", stop_condition);
    if stop_condition == CYCLES {
      message(LOW,"Will stop after:            ", test_time);
    };
    message(LOW,"****************************************************************");
  };// test_header

};

'>

