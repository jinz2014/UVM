---------------------------------------------------------------
File name   : test.e
Created     : Tue Jun 17 13:52:04 2008
Description : This file implements one kind of test in the testbench. 
Notes       : A test file verifies one or more cases in the test plan. 
---------------------------------------------------------------
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
---------------------------------------------------------------

<'

import gpio_config;
import gpio_example_seq_lib;

-- Create a sequence for the Interface
extend MAIN gpio_sequence_q {
    
  !seq : BASE_INTERFACE_EXAMPLE_SEQ gpio_sequence_q;
  keep prevent_test_done == TRUE;

  body() @driver.clock is only {
    do seq;
  }; 
}; 

'>
