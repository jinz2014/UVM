---------------------------------------------------------------
File name   :  apb_master_seq_lib.e
Title       :  Sequence library for the master agent
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file implements several sequence kinds
Notes       :  Each sequence implements a typical scenario or a
            :  combination of existing scenarios. Cadence recommends
            :  defining the sequence library in a separate file or
            :  files that can be loaded on top of the environment.
            :  This lets you include or exclude some sequence kinds
            :  according to the requirement of specific tests.
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

package apb;

// Add new type to the sequence kind
extend apb_master_sequence_kind_t : [READ_AFTER_WRITE];

// Implement the new sequence 
extend READ_AFTER_WRITE apb_master_sequence {
    
  start_address : apb_addr_t;

  // Use to collect read and write data.
  !w_data  : apb_data_t;
  !r_data  : apb_data_t;
  
  body() @driver.clock is only{

    message(MEDIUM, "Starting Read After Write Seq for address :",start_address);
    do my_transaction keeping {
      it.direction == WRITE;
      it.addr == start_address;
    };
    
    // Get all write data.
    w_data = my_transaction.get_data();
    do my_transaction keeping {
      it.direction == READ;
      it.addr == start_address;
    };

    // Get all write data.
    r_data = my_transaction.get_data();  

    // Checks if read & write data are the same (this
    // check ignore the use_mem flag --> if the flag
    // is off then the check will print an error message).
    if  w_data != r_data then {
      message(MEDIUM, "Read data ",r_data," are not equal to write data : ",w_data);
      dut_error("Data Mismatch Observed");
    };
    message(MEDIUM, "Ending Read After Write to address ",start_address);  
  };
};



'>

