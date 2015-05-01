--------------------------------------------------------------------------------
File name   :  ahb_transfer.e
Title       :  Transfer struct.
Project     :  AHB UVC
Developers  :  Ory Tal, Yuval Dinari
Created     :  29-Jan-2003
Description :  Base for monitor transfer(collecting data from the bus) and
               master driven transfer(driving data onto the bus).
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

-- =============================================================================
-- Bus transfer. Serves as a base struct to more complex transfer structs.
-- =============================================================================
struct ahb_transfer  {

  // Transfer size.
  // Possible values: BYTE, HALFWORD, WORD, TWO_WORDS, 
  //                  FOUR_WORDS, EIGHT_WORDS, SIXTEEN_WORDS, K_BITS
  %size: ahb_transfer_size;
  
  // Transfer direction
  // Possible values: READ, WRITE
  %direction: ahb_direction;
  
  // Transfer kind
  // Possible values: NONSEQ, SEQ, IDLE, BUSY
  %kind: ahb_transfer_kind;
  
  // Transfer address.
  %address: ahb_address;
  
  // Transfer data.
  %data: ahb_data;

  // Slave response to the transfer
  !response:ahb_response_kind;
  
  // Transfer started (address phase)
  event tr_started;			
  
  // Transfer ended (data phase)
  event tr_ended;
};

// AHB Master Driven Transfer struct
struct ahb_master_driven_transfer like ahb_transfer {};

// AHB Slave Driven Transfer struct
struct ahb_slave_driven_transfer  like ahb_transfer {};

// AHB Monitor Transfer struct
struct ahb_env_monitor_transfer   like ahb_transfer {};

'>
