/*-------------------------------------------------------------------------
File name   : uart_ctrl_uart_define.e
Title       : APB package 
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the register address for all uart register 

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

#ifdef FV_KIT_NO_AHB_UVC {
  #define UART_BASE_ADDR           0x00;
} #else {
  #define UART_BASE_ADDR           0x00810000;
};


#define UART_FIFO_REG              0x00;
#define UART_DIVISOR_LSB_REG       0x00;
#define UART_DIVISOR_MSB_REG       0x01;
#define UART_INTR_EN_REG           0x01;
#define UART_INTR_INDEN_REG        0x02;
#define UART_FIFO_CNTRL_REG        0x02;
#define UART_LINE_CNTRL_REG        0x03;
#define UART_MODEM_CNTRL_REG       0x04;
#define UART_LINESTATUS_REG        0x05;
#define UART_MODEMSTATUS_REG       0x06;
#define UART_INT_EN_REG            0x08;
#define UART_INT_DIS_REG           0x0c;
#define UART_INT_MSK_REG           0x10;
#define UART_CHN_INT_STS_REG       0x14;
#define UART_BAUD_RATE_REG         0x18;
#define UART_RX_TIMEOUT_REG        0x1c;
#define UART_RX_FIFO_TRIG          0x20;
#define UART_MODEM_CTRL_REG        0x24;
#define UART_MODEM_STS_REG         0x28;
#define UART_CHN_STS_REG           0x2c;
#define UART_RX_FIFO               0x0;
#define UART_TX_FIFO               0x0;
#define UART_BAUD_RATE_DIV_REG     0x34;
#define UART_FLOW_DEL_REG          0x38;
#define UART_IR_MIN_PULSE          0x3c;
#define UART_IR_TX_PULSE           0x40;  
#define UART_TX_FIFO_TRIG          0x44;


'>

