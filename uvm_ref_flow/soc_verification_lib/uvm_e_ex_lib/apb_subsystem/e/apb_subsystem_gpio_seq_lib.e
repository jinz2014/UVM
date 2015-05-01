/*-------------------------------------------------------------------------
File name   : apb_subsystem_gpio_seq_lib.e
Title       : GPIO Sequence Lib for APB Subsystem
Project     :
Created     : November 2010
Description : GPIO Sequences for Transmit and Receive purpose
              
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

extend ahb_master_seq_kind : [GPIO_CONFIG,GPIO_POLL];

extend GPIO_CONFIG'kind ahb::ahb_master_seq {

  base_address   : uint(bits:32);
  keep soft base_address == APB_SUB_SYSTEM_GPIO_BASE_ADDR;

  !mode_gpio    : WRITE ahb::ahb_master_driven_burst;
  !gpio_enablew : WRITE ahb::ahb_master_driven_burst;
  !gpio_direcnw : WRITE ahb::ahb_master_driven_burst;

  BYPASS_MODE : uint(bits : 16); 
  keep soft BYPASS_MODE == 0x0;

  DIREC_REG : uint(bits : 16); 
  keep soft DIREC_REG == 0x0;

  ENABLE_MODE : uint(bits : 16); 
  keep soft ENABLE_MODE == 0xFF;

  body() @driver.clock is {
      
    do mode_gpio keeping {
      it.data[0] == BYPASS_MODE;
      it.data.size() == 1;
      it.first_address == base_address + APB_SUB_SYSTEM_GPIO_BYPASS_REG;
      it.kind == SINGLE;
    };

    do gpio_direcnw keeping {
      it.data[0] == DIREC_REG;
      it.data.size() == 1;
      it.first_address == base_address + APB_SUB_SYSTEM_GPIO_DIRECN_REG;
      it.kind == SINGLE;
    };

    do gpio_enablew keeping {
      it.data[0] == ENABLE_MODE;
      it.data.size() == 1 ;
      it.first_address == base_address + APB_SUB_SYSTEM_GPIO_OUTENABLE_REG;
      it.kind == SINGLE;
    };

    wait [100] * cycle;

   }; //body
};// extend


extend GPIO_POLL'kind ahb::ahb_master_seq {

  base_address   : uint(bits:32);
  keep soft base_address == APB_SUB_SYSTEM_GPIO_BASE_ADDR;

  !gpio_enabler  : WRITE ahb::ahb_master_driven_burst;
  !gpio_direcnr  : WRITE ahb::ahb_master_driven_burst;
  !gpio_trans    : WRITE ahb::ahb_master_driven_burst;
  !gpio_read     : READ  ahb::ahb_master_driven_burst;

  DIREC_REG : uint(bits : 16); 
  keep soft DIREC_REG == 0xFF;

  ENABLE_MODE : uint(bits : 16); 
  keep soft ENABLE_MODE == 0x0;

  DATA_VAL : uint(bits : 16); 
  keep soft DATA_VAL == 0xC;
   
  body() @driver.clock is {

    do gpio_trans keeping {
      it.data[0] == DATA_VAL;
      it.data.size() == 1;
      it.first_address == base_address + APB_SUB_SYSTEM_GPIO_OUTPUT_ADDR;
      it.kind == SINGLE;
      it.size == HALFWORD;
    };

    do gpio_enabler keeping {
      it.data[0] == ENABLE_MODE;
      it.data.size() == 1;
      it.first_address == base_address + APB_SUB_SYSTEM_GPIO_OUTENABLE_REG;
      it.size == HALFWORD;
      it.kind == SINGLE;
    };

    do gpio_direcnr keeping {
      it.data[0] == DIREC_REG;
      it.data.size() == 1;
      it.first_address == base_address + APB_SUB_SYSTEM_GPIO_DIRECN_REG;
      it.size == HALFWORD;
      it.kind == SINGLE;
     };

    wait [100] * cycle;

    do gpio_read keeping {
      it.first_address == base_address + APB_SUB_SYSTEM_GPIO_INPUT_ADDR;
      it.kind == SINGLE;
    };

  }; //body
};// extend

'>

