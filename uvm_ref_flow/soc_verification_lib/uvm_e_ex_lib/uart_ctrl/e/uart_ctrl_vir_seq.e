/*-------------------------------------------------------------------------
File name   : uart_ctrl_vir_seq.e
Title       : virtual  Sequence 
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the declartion of virtual sequence which hooks uart and apb sequence 
            : driver used in  Module uart environment

Notes       : Virtual sequence driver 
            :
---------------------------------------------------------------------------
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
-------------------------------------------------------------------------*/

<'


package uart_ctrl_pkg;

sequence uart_ctrl_sequence using 
  created_driver=uart_ctrl_sequence_driver_u;

extend uart_ctrl_sequence_driver_u {

  !uart_seq_drv   : uart_driver_u;
  !apb_seq_drv    : apb_master_driver_u; 
  !vr_ad_seq_drv  : vr_ad_sequence_driver;
  !addr_map       : vr_ad_map;
  !p_uart_if      : uart_env_u;

  get_sub_drivers() : list of any_sequence_driver is {
    return ({uart_seq_drv;apb_seq_drv;vr_ad_seq_drv});
  };

  // Virtual sequence driver clock
  event clock is only @sys.any;

};

extend  uart_ctrl_sequence_kind : [UART_TEST];

extend MAIN uart_ctrl_sequence {
  pre_body() @sys.any is {
    driver.raise_objection(TEST_DONE);
  };
};

extend MAIN uart_ctrl_sequence {
  post_body() @sys.any is  {
    driver.drop_objection(TEST_DONE);
  };
};

'>

