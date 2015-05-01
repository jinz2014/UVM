---------------------------------------------------------------
File name   :  apb_master_sequence_h.e
Title       :  Sequence interface for active master agents
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file declares the sequence interface of the master.
Notes       :  Active master agents have a sequence interface.
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

// This struct is the generic sequence for the master agent sequence
// interface.
sequence apb_master_sequence using 
  testflow = TRUE,
  item = apb_master_transaction,
  created_driver = apb_master_driver_u,
  created_kind = apb_master_sequence_kind_t;

extend apb_master_driver_u {
    
  // Backpointer to the UVC env that contains this driver's agent.
  p_env : apb_env;
  
  // This field is the logical name of the env that contains this 
  // driver's agent. 
  env_name : apb_env_name_t;
  
  // Backpointer to the master that contains this driver.
  p_master : apb_master;

  // This field is the logical name of the master that contains
  // this driver.
  // This field is automatically constrained by the UVC. It should not
  // be constrained by the user.
  master_name : apb_agent_name_t;
  
  // Monitor reference
  p_bus_monitor  : apb_bus_monitor;

  !item_done_not_set: bool;

  // Test Flow Domain type
  keep soft tf_domain == APB_TF;
  
  // tf_phase_clock if the testflow clock and might change according to
  // current test phase. it is recommended to bind driver.clock to this 
  // clock;
  on tf_phase_clock {
    emit clock;
  };

  // environment sequences are influenced by test phases but do not influence
  // the test flow (usually they use while TRUE loops) this behavior is
  // declared by this flag
  keep tf_nonblocking == FALSE;     

}; 

extend MAIN apb_master_sequence {
  keep soft count == 0;
};


extend apb_master_sequence {

  // This field allows to subtype sequences by logical master name.
  master_name : apb_agent_name_t;
  keep master_name == read_only(driver.master_name);
  
  // This is a utility field for basic sequences. This enables
  // "do master_transaction ...".
  !trans : apb_master_transaction;
  
  // WRITE one transfer to the bus
  write(addr : apb_addr_t, 
    data : apb_data_t) @driver.clock is {
    do trans keeping {
      it.addr == addr;
      it.direction == WRITE;
      it.data == data 
    };
  }; // write()

  // READ one transfer from the bus
  read(addr : apb_addr_t) : apb_data_t @driver.clock is {
    do trans keeping {
      it.addr == addr;
      it.direction == READ
    };

    if trans != NULL {
      result = trans.data;
    };
  }; // read()
}; 

'>
