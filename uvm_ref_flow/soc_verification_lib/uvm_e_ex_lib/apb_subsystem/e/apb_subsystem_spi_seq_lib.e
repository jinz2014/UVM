/*-------------------------------------------------------------------------
File name   : apb_subsystem_spi_seq_lib.e
Title       : Sequence library 
Project     :
Created     : November 2010
Description : SPI test to transmit and receive packets

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

package apb_subsystem_pkg;

extend ahb_master_seq_kind : [SPI_POLL,SPI_CONFIG];

extend SPI_CONFIG'kind ahb::ahb_master_seq {

  base_address   : uint(bits:32);
  keep soft base_address == APB_SUB_SYSTEM_SPI_BASE_ADDR;

  !mas_mode_spi  : WRITE ahb::ahb_master_driven_burst;
  !spi_enable    : WRITE ahb::ahb_master_driven_burst;
  !spi_read      : READ  ahb::ahb_master_driven_burst;

  SPI_MODE   : uint(bits:32) ;
  keep soft SPI_MODE == 0x00001608;

  EN_MODE   : uint(bits:32) ;
  keep soft EN_MODE == 0x1;
   
  body() @driver.clock is only {

    wait [100] * cycle;

    do spi_read keeping {
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_CTRL_REG;
      it.kind == SINGLE;
    };

    wait [100] * cycle;
      
    do mas_mode_spi keeping {
      it.data[0] == SPI_MODE;
      it.size == WORD;
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_CTRL_REG;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

    do mas_mode_spi keeping {
      it.data[0] == 0xf;
      it.size == WORD;
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_SS_REG;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

    do spi_enable keeping {
      it.data[0] == EN_MODE;
      it.size == WORD;
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_DIVISOR_REG;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

  }; //body
};// extend SPI_CONFIG..


extend SPI_POLL'kind ahb::ahb_master_seq {

  base_address   : uint(bits:32);
  keep soft base_address == APB_SUB_SYSTEM_SPI_BASE_ADDR;

  !spi_trans    : WRITE ahb::ahb_master_driven_burst;
  !spi_read     : READ  ahb::ahb_master_driven_burst;
  !mas_mode_spi : WRITE ahb::ahb_master_driven_burst;
   
  SPI_MODE   : uint(bits:32) ;
  keep soft SPI_MODE == 0x00001708;
   
  body() @driver.clock is {

    wait [100] * cycle;
        
    do spi_trans keeping {
      it.data.size() == 1;
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_TXFIFO_ADDR;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

    do mas_mode_spi keeping {
      it.data[0] == SPI_MODE;
      it.size == WORD;
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_CTRL_REG;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

    do spi_read keeping {
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_RXFIFO_ADDR;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

    do spi_trans keeping {
      it.data.size() == 1;
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_TXFIFO_ADDR;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

    do mas_mode_spi keeping {
      it.data[0] == SPI_MODE;
      it.size == WORD;
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_CTRL_REG;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

    do spi_read keeping {
      it.first_address == base_address + APB_SUB_SYSTEM_SPI_RXFIFO_ADDR;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

  };// body()..
};// extend SPI_POLL..
'>

