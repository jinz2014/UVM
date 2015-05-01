-----------------------------------------------------------------
File name     : test.e
Developers    : 
Created       : Tue Jul 27 13:52:04 2008
Description   : Testcase for standalone APB UVC
Notes         : Simple demo testcase
-------------------------------------------------------------------
Copyright 1999-2010 Cadence Design Systems, Inc.
All Rights Reserved Worldwide

Licensed under the Apache License, Version 2.0 (the
"License"); you may not use this file except in
compliance with the License.  You may obtain a copy of
the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in
writing, software distributed under the License is
distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See
the License for the specific language governing
permissions and limitations under the License.
-------------------------------------------------------------------

<'

import apb_demo_config.e;

extend apb::apb_master_sequence_kind_t: [UART_DR_WRITE];
extend UART_DR_WRITE'kind apb::apb_master_sequence {

  !uart_dr_write: WRITE apb::apb_master_transaction;
   
  base_address   : uint(bits:32);
  keep soft base_address == 0x00;

  body() @driver.clock is {
    do uart_dr_write keeping {
      it.addr == base_address + 0x04;
    };
  };
};

// Define the main test scenario. TestWriter can extend body() and also
// create a RANDOM scenario.
extend MAIN MAIN_TEST apb_master_sequence {

  !write_dut : UART_DR_WRITE apb_master_sequence;

  body() @driver.clock is only {
    for i from 1 to 5 do {
      do write_dut;
    };
  };
};

'>
