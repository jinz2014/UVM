--------------------------------------------------------------------------------
File name   :  ahb_slave_driven_burst.e
Title       :  The burst sequence item driven by the slave onto the bus
Project     :  AHB UVC
Developers  :  Ory Tal, Yuval Dinari
Created     :  29-Jan-2003

Description :  The ahb_slave_driven_burst inherits from ahb_burst. In
addition to the basic burst fields it has fields determining the
way the slave will send this burst (e.g. request/transmit delay)
and a pointer to a ahb_slave_transaction struct, containing
all the burst originating from the same original burst.

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

import ahb_burst;

// AHB Slave driven burst derived from ahb_burst
struct ahb_slave_driven_burst like ahb_burst {
   
  // List of data of all transfers in the burst.
  data: list of ahb_data;
  
  // List of all transfers in the burst.
  transfers: list of ahb_slave_driven_transfer;
 
  // Response delay
  response_delay : uint; 

};

extend WRITE ahb_slave_driven_burst {

  // Clear the 'data' list at the beginning of transaction
  keep data.size() == 0;
  
  // When this burst ended, fill the 'data' list with the data of 'transfers'.
  end() is {
    for each (t) in transfers {
      data.add(t.data);
    };
  };         
};

'>
