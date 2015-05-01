/*-------------------------------------------------------------------------
File name   : uart_ctrl_uart_seq_lib.e
Title       : Sequence library
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the library of sequence for UART 

Notes       : Library of sequence for uart and uart evc
            :
-------------------------------------------------------------------------*/
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


package uart;

extend uart_sequence_kind : [UART_TRAFFIC];

extend UART_TRAFFIC uart_sequence {

  num_of_frame : uint;
  keep soft num_of_frame == 10;

  body() @driver.clock is only {

    driver.raise_objection(TEST_DONE);
    for i from 0 to num_of_frame {
      do frame keeping {
        it.has_startbit_err == FALSE;
      };
    };

    wait [100] * cycle;
    driver.drop_objection(TEST_DONE);
  };
};

'>
