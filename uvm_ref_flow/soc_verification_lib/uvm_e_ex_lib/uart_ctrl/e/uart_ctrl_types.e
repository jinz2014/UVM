/*-------------------------------------------------------------------------
File name   :  uart_ctrl_types.e
Title       :  module uart types
Project     :  Module UART
Developers  : 
Created     :
Description : This file contains enum types declated in module uart

Notes       : 
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

// type for parity
type uart_mod_parity_t: [NONE, ODD, EVEN, SPACE];

// uart module name
type uart_mod_name_t : [UART_APB_ENV];

'>

