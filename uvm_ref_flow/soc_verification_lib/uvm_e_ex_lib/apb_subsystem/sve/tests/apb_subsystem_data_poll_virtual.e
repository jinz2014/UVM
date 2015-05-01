/*-------------------------------------------------------------------------
File name   : apb_subsystem_data_poll_virtual.e
Title       : Testcase for APB subsystem using virtual seq
Project     :
Created     : November 2010
Description : uart,spi,gpio test to transmit and receive packets using
              virtual sequence

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

import apb_subsystem/sve/e/apb_subsystem_ahb_package;

//--------------------------------------------
// Extend tick_max default as tests runs for 
// longer time as it involve a BAUD RATE clock
//--------------------------------------------
extend sys {
  setup() is also {
    set_config(run, tick_max, MAX_INT);
  };
};


//--------------------------------------------
// body() is made empty for all the MAIN
// sequences
//--------------------------------------------


extend MAIN'kind spi::spi_sequence {
  body() @driver.clock is only {};
};

extend MAIN'kind gpio::gpio_sequence_q {
  body() @driver.clock is only {};
};

extend APB_SS_FP_UART'evc_name MAIN'kind uart::uart_sequence {
  body() @driver.clock is only {};
};

extend APB_SS_LP_UART'evc_name MAIN'kind uart::uart_sequence {
  body() @driver.clock is only {};
};

extend MAIN vr_ad_sequence {
  body() @driver.clock is only {};
};

extend MAIN'kind ahb::ahb_master_seq {
  body() @driver.clock is only {};
};



// ----------------------------------------------
// Data from UART eVC to DUT
// ----------------------------------------------
extend uart_sequence_kind : [UART_DATA];
extend UART_DATA uart::uart_sequence {

  // Transmit Packet Count
  tx_count: uint;
  keep soft tx_count == 10;

  body() @driver.clock is only {

    for i from 0 to tx_count {
      do frame keeping {
        it.has_startbit_err == FALSE;
      };
    };

    wait [100] * cycle;

  };// body()..
};// extend UART_DATA..


-------------------------------------------------------
// AHB Sequence to poll UART registers:
//
// Transmit data from UART DUT when UART Tx FIFO empty
// Service received data when Rx FIFO threshold crossed
-------------------------------------------------------
extend MAIN apb_subsystem_sequence {

  !uart0_config: UART_CONFIG ahb::ahb_master_seq;
  keep uart0_config.driver == read_only(driver.ahb_seq_drv);

  !uart1_config: UART_CONFIG ahb::ahb_master_seq;
  keep uart1_config.driver == read_only(driver.ahb_seq_drv);

  !uart0_poll: UART_POLL ahb::ahb_master_seq;
  keep uart0_poll.driver == read_only(driver.ahb_seq_drv);
  keep uart0_poll.rx_pkt_max == 10;

  !uart1_poll: UART_POLL ahb::ahb_master_seq;
  keep uart1_poll.driver == read_only(driver.ahb_seq_drv);
  keep uart1_poll.rx_pkt_max == 10;

  !gpio_config: GPIO_CONFIG ahb::ahb_master_seq;
  keep gpio_config.driver == read_only(driver.ahb_seq_drv);

  !gpio_poll: GPIO_POLL ahb::ahb_master_seq;
  keep gpio_poll.driver == read_only(driver.ahb_seq_drv);

  !seqgpio: SIMPLE gpio::gpio_sequence_q;
  keep seqgpio.driver == read_only(driver.gpio_seq_drv);

  !spi_poll: SPI_POLL ahb::ahb_master_seq;
  keep spi_poll.driver == read_only(driver.ahb_seq_drv);

  !spi_config : SPI_CONFIG vr_ad_sequence;
  keep spi_config.driver == read_only(driver.vr_ad_seq_drv);

  !seq1: SIMPLE spi::spi_sequence;
  keep seq1.driver == read_only(driver.spi_seq_drv);

  !uartseq0: UART_DATA uart::uart_sequence;
  keep uartseq0.driver == read_only(driver.fp_uart_seq_drv);

  !uartseq1: UART_DATA uart::uart_sequence;
  keep uartseq1.driver == read_only(driver.lp_uart_seq_drv);

  keep uart0_config.base_address == APB_SUB_SYSTEM_UART_BASE_ADDR;
  keep uart0_config.uart_config == get_enclosing_unit(apb_subsystem_sve_u).as_a(has_uart0 apb_subsystem_sve_u).fp_uart_if.config;

  keep uart1_config.base_address == APB_SUB_SYSTEM_UART1_BASE_ADDR;
  keep uart1_config.uart_config == get_enclosing_unit(apb_subsystem_sve_u).as_a(has_uart1 apb_subsystem_sve_u).lp_uart_if.config;

  keep uart0_poll.base_address == APB_SUB_SYSTEM_UART_BASE_ADDR;

  keep uart1_poll.base_address == APB_SUB_SYSTEM_UART1_BASE_ADDR;

  body() @driver.clock is only {

    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    driver.raise_objection(TEST_DONE);

    wait [500] * cycle;
    do uart0_config;

    do uart1_config;
    
    do spi_config;

    wait [500]*cycle;

    all of {

      { 
        do spi_poll; 
      };

      { 
        do seq1; 
      };

      { 
        do seq1; 
      };

    };

    do gpio_config;
    do gpio_poll;
    do seqgpio;

    wait [50] * cycle;

    do uartseq0;

    do uartseq1;

    wait [500] * cycle;

    do uart0_poll;

    do uart1_poll;

    wait [4500] * cycle;

    driver.drop_objection(TEST_DONE);

  }; // body()..
}; // extend MAIN..


'>

