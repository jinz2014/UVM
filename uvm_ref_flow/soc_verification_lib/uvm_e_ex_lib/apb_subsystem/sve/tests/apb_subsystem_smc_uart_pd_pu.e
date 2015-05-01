/*-------------------------------------------------------------------------
File name   : apb_subsystem_smc_uart_pd_pu.e
Title       : Low Power testcase for APB subsystem
Project     :
Created     : November 2010
Description : UART,SPI,GPIO test to transmit and receive packets

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

// --------------------------------------------
// Setting higher tick_max value
// --------------------------------------------
extend sys {
  setup() is also {
    set_config(run, tick_max,MAX_INT);
  };
};

// Events Related to Configuration
extend apb_subsystem_sve_u {
  event VR_SB_uart0_config_done;
  event VR_SB_uart1_config_done;
  event VR_SB_uart0_data_done;
  event VR_SB_uart1_power_done;
  event VR_SB_uart1_data_done;
  event VR_SB_spi_config_done;
  event VR_SB_gpio_config_done;
  event VR_SB_spi_transfer_done;
};

// SPI Sequence
extend MAIN'kind spi::spi_sequence {

  !seq1: SIMPLE spi::spi_sequence;

  body() @driver.clock is only {
    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    wait @p_env.VR_SB_spi_config_done;
    do seq1 ;
    do seq1 ;
  };
};

// GPIO Sequence
extend MAIN'kind gpio::gpio_sequence_q {

  !seq1: SIMPLE gpio::gpio_sequence_q;

  body() @driver.clock is only {
    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    wait @p_env.VR_SB_gpio_config_done;
    do seq1;
  };
};

// UART Sequence
extend APB_SS_FP_UART'evc_name MAIN'kind uart::uart_sequence {

  // Packet Count
  tx_count: uint;
  keep soft tx_count == 10;

  body() @driver.clock is only {

    driver.raise_objection(TEST_DONE);
    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    wait @p_env.VR_SB_uart0_config_done;

    for i from 0 to tx_count {
       // Frame with No Error
      do frame keeping {
        it.has_startbit_err == FALSE;
      };
    };
    wait [100] * cycle;
    emit p_env.VR_SB_uart0_data_done;
    driver.drop_objection(TEST_DONE);

  };
};

// UART Sequence
extend APB_SS_LP_UART'evc_name MAIN'kind uart::uart_sequence {

  // Packet Count
  tx_count: uint;
  keep soft tx_count == 10;

  body() @driver.clock is only {

    driver.raise_objection(TEST_DONE);
    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    wait @p_env.VR_SB_uart1_power_done;

    for i from 0 to tx_count {
      // Frame with No Error
      do frame keeping {
        it.has_startbit_err == FALSE;
      };
    };

    wait [100] * cycle;
    emit p_env.VR_SB_uart1_data_done;
    driver.drop_objection(TEST_DONE);

  };
};

// vr_ad Sequence
extend MAIN vr_ad_sequence {

  // SPI Config Sequence
  !spi_config : SPI_CONFIG vr_ad_sequence;

  body() @driver.clock is only {

    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);
    driver.raise_objection(TEST_DONE);
    wait [500] * cycle;

    wait until @p_env.VR_SB_uart1_config_done;
    do spi_config;
    emit p_env.VR_SB_spi_config_done;

    wait [50] * cycle;
    driver.drop_objection(TEST_DONE);
  };
};


// AHB Sequence
extend ahb_master_seq_kind : [UART_POLL_POWER];
extend UART_POLL_POWER'kind ahb::ahb_master_seq {

  !tx_fifo_wr     : WRITE        ahb::ahb_master_driven_burst;
  !rxfifo_read    : UART_DR_READ ahb::ahb_master_seq;
  !power_ctrl_wr  : WRITE        ahb::ahb_master_driven_burst;

  base_address: uint(bits:32);

  // Packet Count
  rx_pkt_max   : uint(bits:8) ;
  keep rx_pkt_max == 10;

  tx_pkt_max   : uint(bits:8) ;
  keep tx_pkt_max == 10;

  keep rxfifo_read.base_address == base_address;

  body() @driver.clock is only {

    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);

    // Transmit packets from DUT
    for i from 0 to tx_pkt_max {
      do tx_fifo_wr keeping {
        it.first_address == base_address + UART_FIFO_REG;
        it.size == BYTE;
        it.kind == SINGLE;
      };
      wait [9] * cycle;
    };

    //-----------------------------------------------------------------
    // Write to the Power control register.
    // wait for some time so that UART UVC starts transferring the packet.
    // Power down the UART block wait for some time and then power up.
    //-----------------------------------------------------------------
    wait[6000];
    message(LOW,"POWER CONTROL MODULE TRIGGERED FOR UART AND SMC POWER DOWN");
    do power_ctrl_wr keeping {
      it.data[0]    == 0x03;               
      it.first_address == 0x0086_0004;
      it.kind == SINGLE;
    };

    wait[6000];
    message(LOW,"POWER CONTROL MODULE TRIGGERED FOR UART AND SMC POWER UP");
    do power_ctrl_wr keeping {
      it.data[0]    == 0x00;
      it.first_address == 0x0086_0004;
      it.kind == SINGLE;
    };

    wait[60];
    emit p_env.VR_SB_uart1_power_done;
      
    wait @p_env.VR_SB_uart1_data_done      ;
    for i from 0 to rx_pkt_max {
      do rxfifo_read;
      wait [9] * cycle;
    };
  }; // body()..
};

//-----------------------------------------------------
// AHB Sequence to poll UART registers:
//-----------------------------------------------------
extend MAIN'kind ahb::ahb_master_seq {

  !uart0_config : UART_CONFIG ahb::ahb_master_seq;
  !uart1_config : UART_CONFIG ahb::ahb_master_seq;

  !uart0_poll   : UART_POLL   ahb::ahb_master_seq;
  keep uart0_poll.rx_pkt_max == 10;

  !uart1_poll: UART_POLL_POWER ahb::ahb_master_seq;
  keep uart1_poll.rx_pkt_max == 10;

  !gpio_config  : GPIO_CONFIG ahb::ahb_master_seq;
  !gpio_poll    : GPIO_POLL   ahb::ahb_master_seq;
  !spi_config   : SPI_CONFIG  ahb::ahb_master_seq;
  !spi_poll     : SPI_POLL    ahb::ahb_master_seq;

  keep uart0_config.base_address == APB_SUB_SYSTEM_UART_BASE_ADDR;
  keep uart0_config.uart_config == get_enclosing_unit(apb_subsystem_sve_u).as_a(has_uart0 apb_subsystem_sve_u).fp_uart_if.config;
  keep uart1_config.base_address == APB_SUB_SYSTEM_UART1_BASE_ADDR;
  keep uart1_config.uart_config == get_enclosing_unit(apb_subsystem_sve_u).as_a(has_uart1 apb_subsystem_sve_u).lp_uart_if.config;
  keep uart0_poll.base_address == APB_SUB_SYSTEM_UART_BASE_ADDR;
  keep uart1_poll.base_address == APB_SUB_SYSTEM_UART1_BASE_ADDR;

  body() @driver.clock is only {

    var p_env:= get_enclosing_unit(apb_subsystem_sve_u);

    // UART0 config
    do uart0_config;
    emit p_env.VR_SB_uart0_config_done;

    // UART1 config
    do uart1_config;
    emit p_env.VR_SB_uart1_config_done;

    // Waiting for SPI Config
    wait @p_env.VR_SB_spi_config_done;
    do spi_poll;

    // GPIO Config
    do gpio_config;
    emit p_env.VR_SB_gpio_config_done ;

    do gpio_poll;

    driver.raise_objection(TEST_DONE);

    wait [50] * cycle;

    wait @p_env.VR_SB_uart0_data_done;
    wait [50] * cycle;
    do uart0_poll;
    do uart1_poll;
    wait [2500] * cycle;

    driver.drop_objection(TEST_DONE);

  };
};

'>

