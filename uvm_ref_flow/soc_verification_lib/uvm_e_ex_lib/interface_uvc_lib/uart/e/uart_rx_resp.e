/*-----------------------------------------------------------------
File name     : uart_rx_resp.e
Title         : Response struct defination
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

// Response struct
struct uart_rx_resp_s like any_sequence_item {

  delay_bt_frame : uint;
  keep soft delay_bt_frame in [0..10];

  num_of_frames  : uint; 
  keep soft num_of_frames in [1 .. 20];

};


'>
