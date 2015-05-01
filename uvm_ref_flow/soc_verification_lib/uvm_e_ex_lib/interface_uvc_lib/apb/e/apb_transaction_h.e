---------------------------------------------------------------
File name   :  apb_trans_s_h.e
Title       :  Transaction struct declaration
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file declares the base transaction struct that
            :  represents a single transaction on the bus.
            :  and also the master and slave items which 
            :  inherit from the base struct.

Notes       :  This file declares the transcation struct used to represent apb transaction 
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

// =============================================================================
// Bus transaction. Serves as a base struct to more complex
// transaction structs.
// =============================================================================
struct apb_trans_s like any_sequence_item {
       
  %addr : apb_addr_t;
  
  %data : apb_data_t;
  
  %direction  : apb_command_t;
  keep direction in [READ, WRITE];

  !err : bool;

  slave_number : apb_slave_id_t; 
  keep soft slave_number == S0;

  transaction_delay: uint;
  keep soft transaction_delay in [0..10];
  
  // This field will be updated by the driver or the monitor
  !start_time : time;
  !end_time   : time;
  
  event started;
  event ended;
  
  // --------------------------------------------------------------------------
  // Called when the transaction has started.
  // --------------------------------------------------------------------------
  start_transaction() is {
    start_time = sys.time;
    emit started;
  }; 
  
  // --------------------------------------------------------------------------
  // Called when the transaction has ended.
  // --------------------------------------------------------------------------
  end_transaction() is {
    end_time = sys.time;
    emit ended;
  };
  
  // -----------------------------------------------------------------------
  // Return a string describing the transaction
  // -----------------------------------------------------------------------
  transaction_str() : string is {
    result = append(direction,", Addr: ",hex(addr),", Data: ",hex(data));
  };
  
  // --------------------------------------------------------------------------
  // return the transaction data
  // --------------------------------------------------------------------------
  get_data() : apb_data_t is {
    result = data;
  };
}; 

'>

<'

// The master driven transaction, part of the master sequence item
struct apb_master_transaction like apb_trans_s {
       
  keep soft direction in [READ,WRITE];
  // The delay until driving the req channel
  keep soft transaction_delay == 5;

};

'>

<'

// The slave driven transaction. Part of the slave sequence item.
struct apb_slave_transaction like apb_trans_s {
         
  // The delay until driving the req channel
  transaction_resp_delay: uint;
  keep soft transaction_resp_delay == select {
    40 : 0;
    30 : [1..2];
    15 : [3..10];
    5  : [11..100];
  };
};


'>
