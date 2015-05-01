-----------------------------------------------------------------
File name   : test_multi_reset.e
Title       : APB UVC demo - example of multiple reset handling
Developers  : 
Created     : 2011
Description : Example testcase file for demo purposes
Notes       : This file demonstrates the ability of the UVC to cope with
            : multiple resets. Master performs 5 resets 
            :
            : For seeing messages from the Testflow utilitiy(note - there 
            : are many of them) issue in Specman prompt:
            :     trace testflow
-------------------------------------------------------------------
Copyright 1999-2011 Cadence Design Systems, Inc.
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

-- import the APB UVC configuration File
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


-- APB master will do between 30 and 50 transfers
extend MAIN MAIN_TEST apb_master_sequence {

  !write_dut : UART_DR_WRITE apb_master_sequence;
  
  packet_count : uint;
  keep soft packet_count in [30..50];

  body() @driver.clock is only {
    for i from 1 to packet_count do {
      do write_dut;
    };
  };
}; -- extend MAIN MAIN_TEST apb_master_sequence

-- Issue extra reset's , call tf_get_domain_mgr().rerun_phase(RESET)
extend apb_master_driver_u {

  do_multiple_reset() @sys.any is {
    
    // Will Generate Reset for 5 Times
    if tf_get_domain_mgr().get_invocation_count(MAIN_TEST) < 5 then {
      var delay : uint;
      gen delay keeping {it in [1..200]};
      wait [delay];
      message(LOW, "Calling rerun_phase(RESET)");
      tf_get_domain_mgr().rerun_phase(RESET);
    };
  }; -- do_multiple_reset()
    
  tf_main_test() @tf_phase_clock is also {
    do_multiple_reset();
  }; -- tf_main_test()

}; -- extend sys

'>

