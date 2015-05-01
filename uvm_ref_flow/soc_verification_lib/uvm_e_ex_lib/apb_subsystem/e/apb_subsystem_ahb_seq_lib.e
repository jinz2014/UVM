/*-------------------------------------------------------------------------
File name   : apb_subsystem_ahb_seq_lib.e
Title       : AHB Sequence Library
Project     :
Created     : November 2010
Description : Contains AHB Sequences
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

// UART Config Sequence
extend ahb::ahb_master_seq_kind : [UART_CONFIG];

---------------------------
-- Write to Tx FIFO via AHB
---------------------------
extend ahb::ahb_master_seq_kind: [UART_DR_WRITE];

extend UART_DR_WRITE'kind ahb::ahb_master_seq {

  !uart_dr_write: WRITE ahb::ahb_master_driven_burst;
  base_address   : uint(bits:32);

  keep soft base_address == APB_SUB_SYSTEM_UART_BASE_ADDR;

  body() @driver.clock is {
    do uart_dr_write keeping {
      it.first_address == base_address + UART_FIFO_REG;
      it.kind == SINGLE;
    };
  }; //body
};// extend

----------------------------
-- Read from Rx FIFO via AHB
----------------------------
extend ahb::ahb_master_seq_kind: [UART_DR_READ];

extend UART_DR_READ'kind ahb::ahb_master_seq {

  !uart_dr_read: READ ahb::ahb_master_driven_burst;
  base_address   : uint(bits:32);

  keep soft base_address == APB_SUB_SYSTEM_UART_BASE_ADDR;
  
  body() @driver.clock is {
    do uart_dr_read keeping {
      it.first_address == base_address + UART_FIFO_REG;
      it.kind == SINGLE;
      it.size == BYTE;
    };
  }; //body
};// extend


------------------------------------
-- Read from Channel Status Register
------------------------------------
extend ahb::ahb_master_seq_kind: [UART_CHN_STS_READ];

extend UART_CHN_STS_READ'kind ahb::ahb_master_seq {
  !uart_chn_sts_read: READ ahb::ahb_master_driven_burst;
  base_address   : uint(bits:32);

  keep soft base_address == APB_SUB_SYSTEM_UART_BASE_ADDR;
  
  body() @driver.clock is {
    do uart_chn_sts_read keeping {
      it.first_address == base_address + APB_SUB_SYSTEM_UART_CHN_STS_REG;
      it.kind == SINGLE;
    };
  }; //body
};// extend

'>
