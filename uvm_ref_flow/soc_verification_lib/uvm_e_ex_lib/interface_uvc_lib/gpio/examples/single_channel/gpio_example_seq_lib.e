---------------------------------------------------------------
File name   : gpio_example_seq_lib.e
Created     : Tue Jun 17 13:52:04 2008
Description : This file implements several sequence kinds
Notes       : Each sequence implements a typical scenario or a
            : combination of existing scenarios. Cadence recommends
            : defining the sequence library in a separate file or
            : files that can be loaded on top of the environment.
            : This lets you include or exclude some sequence kinds
            : according to the requirement of specific tests. 
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

package gpio;

-- Step 1 - Add new type to the sequence kind
extend gpio_sequence_kind_t : [BASE_INTERFACE_EXAMPLE_SEQ];

-- Step 2 - Implement the new sequence 
extend BASE_INTERFACE_EXAMPLE_SEQ gpio_sequence_q {
    
  itr  : uint;
  keep itr in [1..8];
  
  body() @driver.clock is only {

    message(MEDIUM, "Starting basic Interface example sequence");
    for i from 0 to itr {
      all of {
        do transfer;
        do transfer;
      }; 
    };
  };
};

'>
