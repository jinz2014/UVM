/*-------------------------------------------------------------------------
File name   : apb_subsystem_data_poll_virtual.e
Title       : Testcase for APB subsystem using virtual seq
Project     :
Created     : November 2010
Description : uart,spi,gpio test to transmit and receive packets using
              MAIN sequences

Notes       : Limitations - Start bit errors not introduced as scoreboard not
                            sensitive to it.
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

import apb_subsystem/e/apb_subsystem_ahb_package;

//------------------------------------------
// Extent tick_max default as tests runs for 
// longer time as it involve a BAUD RATE clock
--------------------------------------------
extend sys {
  setup() is also {
    set_config(run, tick_max, MAX_INT);
  };
};

// ----------------------------------------------
// Various event declarations related to 
// configuration and data transfers
// ----------------------------------------------
extend apb_subsystem_sve_u {
  event VR_SB_uart0_config_done;
  event VR_SB_uart1_config_done;
  event VR_SB_uart0_data_done;
  event VR_SB_uart1_data_done;
  event VR_SB_spi_config_done;
  event VR_SB_gpio_config_done;
  event VR_SB_spi_transfer_done;
};


// MAIN Sequence for SPI Transfers
extend MAIN'kind spi::spi_sequence {

  !seq1: SIMPLE spi::spi_sequence;

  body() @driver.clock is only {

    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    wait @p_env.VR_SB_spi_config_done;
    do seq1 ;
    do seq1 ;

  }; // body()..
}; // extend MAIN..



// Main Sequence for GPIO Transfers
extend MAIN'kind gpio::gpio_sequence_q {

  !seq1: SIMPLE gpio::gpio_sequence_q;

  body() @driver.clock is only {

    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    wait @p_env.VR_SB_gpio_config_done;
    do seq1;

  }; //body()..
}; // extend MAIN..


// ----------------------------------------------
// Main sequence for data transfer from UART eVC 
// to DUT
// ----------------------------------------------
extend APB_SS_FP_UART'evc_name MAIN'kind uart::uart_sequence {

  tx_count: uint;
  keep soft tx_count == 10;

  body() @driver.clock is only {

    driver.raise_objection(TEST_DONE);
    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    wait @p_env.VR_SB_uart0_config_done;
    for i from 0 to tx_count {
      do frame keeping {
        it.has_startbit_err == FALSE;
      };
    };

    wait [100] * cycle;
    emit p_env.VR_SB_uart0_data_done;

    driver.drop_objection(TEST_DONE);

   }; // body()..
}; // extend MAIN ..


extend APB_SS_LP_UART'evc_name MAIN'kind uart::uart_sequence {

   tx_count: uint;
   keep soft tx_count == 10;

   body() @driver.clock is only {

     driver.raise_objection(TEST_DONE);
     var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
     wait @p_env.VR_SB_uart1_config_done;
     for i from 0 to tx_count {
       do frame keeping {
         it.has_startbit_err == FALSE;
       };
     };

     wait [100] * cycle;
     emit p_env.VR_SB_uart1_data_done;

     driver.drop_objection(TEST_DONE);

   }; // body()..
}; // extend MAIN..

// ----------------------------------------
// vr_ad MAIN sequence
// ----------------------------------------
extend MAIN vr_ad_sequence {

  !spi_config : SPI_CONFIG vr_ad_sequence;

  body() @driver.clock is only {

    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    driver.raise_objection(TEST_DONE);
    wait [500] * cycle;

    wait @p_env.VR_SB_uart1_config_done;
    do spi_config;
    emit p_env.VR_SB_spi_config_done;

    wait [50] * cycle;
    driver.drop_objection(TEST_DONE);

  }; // body()..
}; // extend MAIN..

//-------------------------------------------------------
// AHB Sequence to poll UART registers:
//-------------------------------------------------------
extend MAIN'kind ahb::ahb_master_seq {

  !uart0_config  : UART_CONFIG ahb::ahb_master_seq;
  !uart1_config  : UART_CONFIG ahb::ahb_master_seq;
  !uart0_poll    : UART_POLL   ahb::ahb_master_seq;
  keep uart0_poll.rx_pkt_max == 10;

  !uart1_poll: UART_POLL ahb::ahb_master_seq;
  keep uart1_poll.rx_pkt_max == 10;

  !gpio_config: GPIO_CONFIG ahb::ahb_master_seq;
  !gpio_poll: GPIO_POLL ahb::ahb_master_seq;
  !spi_config: SPI_CONFIG ahb::ahb_master_seq;
  !spi_poll: SPI_POLL ahb::ahb_master_seq;

  keep uart0_config.base_address == APB_SUB_SYSTEM_UART_BASE_ADDR;
  keep uart0_config.uart_config == get_enclosing_unit(apb_subsystem_sve_u).as_a(has_uart0 apb_subsystem_sve_u).fp_uart_if.config;
  keep uart1_config.base_address == APB_SUB_SYSTEM_UART1_BASE_ADDR;
  keep uart1_config.uart_config == get_enclosing_unit(apb_subsystem_sve_u).as_a(has_uart1 apb_subsystem_sve_u).lp_uart_if.config;
  keep uart0_poll.base_address == APB_SUB_SYSTEM_UART_BASE_ADDR;
  keep uart1_poll.base_address == APB_SUB_SYSTEM_UART1_BASE_ADDR;

  body() @driver.clock is only {

    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);

    do uart0_config;
    emit p_env.VR_SB_uart0_config_done;

    do uart1_config;
    emit p_env.VR_SB_uart1_config_done;

    wait @p_env.VR_SB_spi_config_done;

    do spi_poll;

    do gpio_config;
    emit p_env.VR_SB_gpio_config_done ;

    do gpio_poll;
    driver.raise_objection(TEST_DONE);

    wait [50] * cycle;

    wait @p_env.VR_SB_uart0_data_done;
    wait [500] * cycle;
    do uart0_poll;
    do uart1_poll;
    wait [2500] * cycle;

    driver.drop_objection(TEST_DONE);

  }; // body()..
}; // extend MAIN..

'>

