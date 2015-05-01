/*-------------------------------------------------------------------------
File name   : apb_subsystem_vir_seq.e
Title       : Virtual Sequence
Project     :
Created     : November 2010
Description : This file contains the declartion of virtual sequence which hooks
              different sequence drivers used in the APB subsystem environment 

Notes       : Virtual Sequence Driver for APB subsystem
                            
-------------------------------------------------------------------------*/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------


<'

package apb_subsystem_pkg;

// Virtual Sequence
sequence apb_subsystem_sequence using 
  created_driver=apb_subsystem_sequence_driver_u;

// Pointers of sequence drivers in virtual sequence driver
extend apb_subsystem_sequence_driver_u {

  // uart sequence driver
  !fp_uart_seq_drv : uart_driver_u;
  !lp_uart_seq_drv : uart_driver_u;
  !fp_uart_rx_seq_drv : uart_rx_driver_u;
  !lp_uart_rx_seq_drv : uart_rx_driver_u;

  // spi sequence driver
  !spi_seq_drv : spi_sequence_driver_u;

  // gpio sequence driver
  !gpio_seq_drv : gpio_sequencer_u;

  // ahb sequence driver
  !ahb_seq_drv  : ahb_master_seq_driver ; 

  // vr_ad sequence driver
  !vr_ad_seq_drv  : vr_ad_sequence_driver;

  // vr_ad address map
  !addr_map  : vr_ad_map;

  get_sub_drivers() : list of any_sequence_driver is {
    return ({fp_uart_seq_drv;lp_uart_seq_drv;spi_seq_drv;gpio_seq_drv;ahb_seq_drv;vr_ad_seq_drv});
  };
 
  // Virtual Sequence driver clock
  event clock is only @sys.any;

}; //extend..

extend apb_subsystem_sequence_kind : [UART_TEST];

extend MAIN apb_subsystem_sequence {
  pre_body() @sys.any is {
    driver.raise_objection(TEST_DONE);
  };
};

extend MAIN apb_subsystem_sequence {
  post_body() @sys.any is  {
    driver.drop_objection(TEST_DONE);
  };
};







'>





