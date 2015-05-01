/*-------------------------------------------------------------------------
File name   : uart_ctrl_apb_seq_lib.e
Title       : Sequence library
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the library of sequence for UART and APB eVC
            : relevant to Module uart environment

Notes       : Library of sequence for uart and apb evc
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

package uart_ctrl_pkg;


extend apb_master_sequence_kind_t : [FIFOWR,FIFORD];

// FIFO Write Sequence for Write Operation
extend FIFOWR apb_master_sequence {

  !fifowr : WRITE apb::apb_master_transaction;

  // Packet Count
  tx_count: uint;
  keep soft tx_count == 10;

  body() @driver.clock is only {
    for i from 0 to tx_count {
      do fifowr keeping {
        it.addr == 0;
      };
    }; // for loop
  }; // body()..
}; // extend FIFOWR..


// FIFO Read Sequence for Read Operation
extend FIFORD apb_master_sequence {

  !fiford : READ apb::apb_master_transaction;

  // Packet Count
  tx_count: uint;
  keep soft tx_count == 10;

  body() @driver.clock is only {
    for i from 0 to tx_count {
      do fiford keeping {
        it.addr == 0;
      };
    }; // for loop
  }; // body()..
}; // extend FIFORD..

'>
