--------------------------------------------------------------------------------
File name   : ahb_burst.e
Title       : Basic burst struct
Project     : AHB UVC
Developers  : Ory Tal, Yuval Dinari
Created     : 29-Jan-2003
Description : Base for monitor burst (collecting data from the bus) and
              master driven bus (driving data onto the bus).

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

import ahb_transfer;

// AHB Burst sequence item
struct ahb_burst like any_sequence_item {
   
  // Address 
  %addr: ahb_address;

  // Data
  %data_val: ahb_data;
  
  // HSIZE[2:0]
  // Possible values: BYTE, HALFWORD, WORD, TWO_WORDS, 
  //                  FOUR_WORDS, EIGHT_WORDS, SIXTEEN_WORDS, K_BITS.
  %size: ahb_transfer_size;      
     
  // HWRITE<br>
  // Possible values: READ, WRITE.
  %direction: ahb_direction;       
  
  // HBURST[2:0]<br>
  // Possible values: SINGLE, INCR, WRAP4, INCR4, 
  //                  WRAP8, INCR8, WRAP16, INCR16.
  %kind: ahb_burst_kind;      
   
  // HPROT[0]
  %io_mode: ahb_io_mode;  
  
  // HPROT[1]
  %priv_mode: ahb_priv_mode;        
  
  // HPROT[2]
  %buf_mode: ahb_buffer_mode;      
  
  // HPROT[3]
  %cache_mode: ahb_cache_mode;           
  
  // HLOCK
  // When TRUE, this burst will be sent as locked burst.
  // When FALSE, this burst will be sent as unlocked burst.
  %lock: bool;

};

'>
