---------------------------------------------------------------
File name   :  apb_slave_sequence_h.e
Title       :  Sequence interface for active slave agents
Project     :  APB UVC
Developers  : 
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file declares the sequence interface of the slave.
Notes       :  Active slave agents have a sequence interface.
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

// This struct is the generic sequence for the slave agent sequence
// interface.
sequence apb_slave_sequence using
  item = apb_slave_transaction,
  created_driver = apb_slave_driver_u,
  created_kind = apb_slave_sequence_kind_t;

extend apb_slave_driver_u {
    
  // Backpointer to the UVC env that contains this 
  // driver's agent.
  p_env : apb_env;
  
  // This field is the logical name of the env that contains this
  // driver's agent 
  env_name : apb_env_name_t;
  
  // Backpointer to the slave that contains this driver.
  p_slave : apb_slave;
  
  // This field is the logical name of the slave that contains
  // this driver.
  // This field is automatically constrained by the UVC. It should not be
  // constrained by the user.
  slave_name : apb_agent_name_t;
  
  // Monitor reference
  p_bus_monitor  : apb_bus_monitor;
    
}; 

extend apb_slave_sequence {

  // This field allows to subtype sequences by logical slave name.
  slave_name : apb_agent_name_t;
  keep slave_name == read_only(driver.slave_name);

  // This is a utility field for basic sequences. This enables
  // "do response ...".
  !response: apb_slave_transaction;

}; 

// This constrain slave transaction fields to appropriate
// signals written by the master. 
extend apb_slave_transaction {
    
  keep addr == get_address(driver);
  keep direction == get_direction(driver);
  keep gen (driver) before (addr,data,direction);
  
  get_my_driver() : apb_slave_driver_u is {
    result = driver;
  };
  
  get_address(driver :apb_slave_driver_u) : apb_addr_t is {
    result = driver.p_bus_monitor.transaction.addr;
  };
  
  
  get_direction(driver :apb_slave_driver_u) : apb_command_t is {
    result = driver.p_bus_monitor.transaction.direction;
  };
}; 

extend MAIN apb_slave_sequence {
  // The slave sequence driver is a reactive sequence driver. This sets
  // its default to never runs out of sequence items.
  keep soft count == MAX_UINT;
}; 

'>

