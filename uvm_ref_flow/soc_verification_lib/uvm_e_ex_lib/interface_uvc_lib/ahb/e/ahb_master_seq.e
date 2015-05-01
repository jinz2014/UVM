--------------------------------------------------------------------------------
File name   :  ahb_master_seq.e
Title       :  Master sequence and driver definition
Project     :  AHB UVC
Developers  :  Ory Tal, Yuval Dinari
Created     :  29-Jan-2003

Description :  Sequence name - ahb_master_seq
               Driver name   - ahb_master_seq_driver
               Sequence item - ahb_master_driven_burst
Notes       :
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
   
<'

package ahb;

import ahb_master_driven_burst;

-- =============================================================================
-- Master sequence.
-- Item: ahb_master_driven_burst
-- =============================================================================
sequence ahb_master_seq using  
  item = ahb_master_driven_burst,
  created_driver = ahb_master_seq_driver;

-- =============================================================================
-- Add utility fields and methods.
-- =============================================================================
extend ahb_master_seq {

  -- (Default: in [10..100])
  -- Controls the number of sequences/items generated. 
  -- In MAIN and RANDOM sequences it is recommended to use the 
  -- predefined field 'count' instead.
  num_of_items: uint;
  keep soft num_of_items in [10..100];
   
  -- The sequence item. 
  -- In SIMPLE sequences it is recommended to use the predefined field 'item' instead.
  !burst: ahb_master_driven_burst;

  -- ==========================================================================
  -- Reads data from 'address' using a burst of kind 'b_kind'.
  -- Loses one IDLE cycle after burst.
  -- Use this TCM within the 'body' TCM.
  -- ==========================================================================
  read(address: ahb_address, 
    b_kind: ahb_burst_kind,
    size: ahb_transfer_size): list of ahb_data @driver.clock is {
      do burst keeping {		-- create a READ burst
        it.kind == b_kind;
        it.direction == READ;
        it.first_address == address;
        it.size == size;
      };
  }; -- read()
   
  -- ==========================================================================
  -- Writes 'data' to 'address' using a 'b_kind' burst.
  -- Use this TCM within the 'body' TCM
  -- ==========================================================================
  write(address: ahb_address, 
    data: list of ahb_data, 
    b_kind: ahb_burst_kind,
    size: ahb_transfer_size) @driver.clock is {
      do burst keeping {
        it.kind == b_kind;
        it.direction == WRITE;
        it.first_address == address;
        it.data == data;
        it.size == size;
      };
  };-- write()
}; -- extend ahb_master_seq

'>
