/*-------------------------------------------------------------------------
File name   : apb_coverage.e
Title       : APB coverage 
Project     : APB UVC
Developers  : 
Created     :
Description : This file implements apb coverage functionality.
Notes       : Coverage model for apb interface 

---------------------------------------------------------------------------
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

-------------------------------------------------------------------------*/


<'

package apb;

extend has_coverage apb_bus_monitor {
 
  cover tr_ended is {
      
    item transaction_delay : uint = transaction.transaction_delay using 
      ranges = { 
        range([0], "[0] - No Delay"); range([1..2], "[1..2] - Short");  
        range([3..10], "[3..10] - Medium"); range([11..100], "[11..100] - Long")
    }; 
    item response_delay    : uint = transaction.response_delay using 
      ranges = { 
        range([0], "[0] - No Delay"); range([1..2], "[1..2] - Short");  
        range([3..10], "[3..10] - Medium"); range([11..100], "[11..100] - Long")
    };
  }; // cover..
}; // extend has_coverage apb_bus_monitor..


extend has_coverage apb_bus_monitor {

  cover tr_ended is also {
    item direction :apb_command_t = transaction.direction;
  };
};

'>
