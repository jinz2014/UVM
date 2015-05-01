---------------------------------------------------------------
File name   : ahb_slave_seq.e
Developers  : vishwana
Created     : Tue Mar 30 14:29:27 2010
Description : This file declares the sequence interface of the slave.
Notes       :  
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

package ahb;


-- The generic sequence for the slave agent sequence
sequence ahb_slave_sequence using
  item = ahb_slave_driven_burst,
  created_driver = ahb_slave_driver_u,
  created_kind = ahb_slave_sequence_kind_t;

extend ahb_slave_sequence {
  -- This is a utility field for basic sequences.
  -- This enables -- "do response ...".
  !response: ahb_slave_driven_burst;
}; 

extend MAIN ahb_slave_sequence {
  -- The slave sequence driver is a reactive sequence driver. This sets
  -- its default to never run out of sequence items.
  keep soft count == MAX_UINT;
}; 

'>

