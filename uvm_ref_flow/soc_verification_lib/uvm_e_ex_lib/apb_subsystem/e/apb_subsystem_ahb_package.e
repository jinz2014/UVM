/*-------------------------------------------------------------------------
File name   : apb_subsystem_ahb_package.e
Title       : UART DUT Register Addresses
Project     :
Created     : November 2010
Description : UART package file containing UART DUT register addresses

Notes       : 
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

  #ifndef APB_SUB_SYSTEM_UART_BASE_ADDR {
    define APB_SUB_SYSTEM_UART_BASE_ADDR  0x00810000;
  };
  
  #ifndef APB_SUB_SYSTEM_UART1_BASE_ADDR {
    define APB_SUB_SYSTEM_UART1_BASE_ADDR 0x00880000;
  };

  #define APB_SUB_SYSTEM_UART_CTRL_REG          0x00;
  #define APB_SUB_SYSTEM_UART_MODE_REG          0x04;
  #define APB_SUB_SYSTEM_UART_INT_EN_REG        0x08;
  #define APB_SUB_SYSTEM_UART_INT_DIS_REG       0x0c;
  #define APB_SUB_SYSTEM_UART_INT_MSK_REG       0x10;
  #define APB_SUB_SYSTEM_UART_CHN_INT_STS_REG   0x14;
  #define APB_SUB_SYSTEM_UART_BAUD_RATE_REG     0x18;
  #define APB_SUB_SYSTEM_UART_RX_TIMEOUT_REG    0x1c;
  #define APB_SUB_SYSTEM_UART_RX_FIFO_TRIG      0x20;
  #define APB_SUB_SYSTEM_UART_MODEM_CTRL_REG    0x24;
  #define APB_SUB_SYSTEM_UART_MODEM_STS_REG     0x28;
  #define APB_SUB_SYSTEM_UART_CHN_STS_REG       0x2c;
  #define APB_SUB_SYSTEM_UART_RX_FIFO           0x30;
  #define APB_SUB_SYSTEM_UART_TX_FIFO           0x30;
  #define APB_SUB_SYSTEM_UART_BAUD_RATE_DIV_REG 0x34;
  #define APB_SUB_SYSTEM_UART_FLOW_DEL_REG      0x38;
  #define APB_SUB_SYSTEM_UART_IR_MIN_PULSE      0x3c;
  #define APB_SUB_SYSTEM_UART_IR_TX_PULSE       0x40;  
  #define APB_SUB_SYSTEM_UART_TX_FIFO_TRIG      0x44;

  #ifndef APB_SUB_SYSTEM_SPI_BASE_ADDR {
    define APB_SUB_SYSTEM_SPI_BASE_ADDR   0x00800000;
  };

  #define APB_SUB_SYSTEM_SPI_CTRL_REG           0x10;
  #define APB_SUB_SYSTEM_SPI_DIVISOR_REG        0x14;
  #define APB_SUB_SYSTEM_SPI_TXFIFO_ADDR        0x00;
  #define APB_SUB_SYSTEM_SPI_RXFIFO_ADDR        0x00;
  #define APB_SUB_SYSTEM_SPI_SS_REG             0x18;

  #ifndef APB_SUB_SYSTEM_GPIO_BASE_ADDR {
    define APB_SUB_SYSTEM_GPIO_BASE_ADDR  0x00820000;
  };

  #define APB_SUB_SYSTEM_GPIO_BYPASS_REG        0x00;
  #define APB_SUB_SYSTEM_GPIO_DIRECN_REG        0x04;
  #define APB_SUB_SYSTEM_GPIO_OUTENABLE_REG     0x08;
  #define APB_SUB_SYSTEM_GPIO_OUTPUT_ADDR       0x0C;
  #define APB_SUB_SYSTEM_GPIO_INPUT_ADDR        0x10;

'>

