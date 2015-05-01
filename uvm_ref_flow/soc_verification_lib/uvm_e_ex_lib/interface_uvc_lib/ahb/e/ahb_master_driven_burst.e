--------------------------------------------------------------------------------
File name   :  ahb_master_driven_burst.e
Title       :  The burst sequence item driven by the master onto the bus
Project     :  AHB UVC
Developers  :  Ory Tal, Yuval Dinari
Created     :  29-Jan-2003
Description :  The ahb_master_driven_burst inherits from ahb_burst.
               In addition to the basic burst fields it has fields 
      	       determining the way the master will send this 
      	       burst (e.g. request/transmit delay) and a pointer to a 
      	       ahb_master_transaction struct, containing all the burst 
      	       originating from the same original burst.
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

// AHB Master Driven Burst derived from ahb_burst
struct ahb_master_driven_burst like ahb_burst {
   
  // List of data of all transfers in the burst.
  data: list of ahb_data;
  
  // List of all transfers in the burst.
  transfers: list of ahb_master_driven_transfer;
  
  // The address of the first transfer in this burst.
  // (Should not be constrained if 'slave_name' is constrained.)
  first_address: ahb_address;
    
  // (Default: 0)
  // Number of IDLE transfers executed by the master after getting the 
  // bus and before sending the NONSEQ transfer of this burst.
  transmit_delay: uint;
  keep soft kind == SINGLE;  

  keep (kind == SINGLE) => (data.size() == 1);
  keep (kind == SINGLE) => (transfers.size() == 1);
  keep addr == first_address ;
  keep data_val == data[0] ;
    
  ended : bool; 
  keep ended == FALSE;

  end() is {
    ended = TRUE;
  }
};

'>
