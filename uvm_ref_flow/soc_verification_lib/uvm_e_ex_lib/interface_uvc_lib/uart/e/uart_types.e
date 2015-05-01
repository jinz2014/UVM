/*-----------------------------------------------------------------
File name     : uart_types.e
Title         : Uart Type files
Project       :
Created       : Wed Feb 18 10:46:08 2004
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

// The environment name-type must be extended by the user in the config file
type uart_env_name_t      : [];

// The agents name
type uart_agent_name_t    : [RX_AGENT, TX_AGENT];

// The different parity types
type uart_frame_parity_t  : [ NONE, ODD, EVEN, SPACE] (bits:3);

// The different stop bit types
type uart_frame_stopbit_t : [ ONE = 1, TWO= 2] (bits:2);

// The different payload lengths
type uart_frame_databit_t : [ FIVE = 5, SIX = 6, SEVEN = 7, EIGHT = 8 ] (bits:4);

// The agent direction can be as transmiter or receiver
type uart_agent_dir_kind_t: [ TX, RX ];

// Used in order to determine the end of the test condition
type uart_end_cond_t      : [CYCLES, EXTERNAL_EVENT];

// monitor state machine states
type uart_mon_state_t     : [IDLE, RECEIVING];

// error status in the frame
type uart_status_t        : [
  NO_ERROR,
  BAD_START,  // start bit is not 0
  BAD_PARITY, // parity bit is incorrect
  BAD_STOP    // stop bit is not 1
];

// baud rate 
type uart_baud_rate_t  : [BAUD_9600 = 8'h0F,BAUD_28800 = 8'h2D,BAUD_57600 = 8'h87];

'>
