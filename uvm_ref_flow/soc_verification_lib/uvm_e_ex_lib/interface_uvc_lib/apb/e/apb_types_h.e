---------------------------------------------------------------
File name   :  apb_types_h.e
Title       :  Common type declarations
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file declares common types used throughout the UVC.

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

package apb;

// Define APB Address Width
#ifndef  APB_ADDR_WIDTH {
  define APB_ADDR_WIDTH 32;
};

// Define APB Data Width
#ifndef APB_DATA_WIDTH {
  define APB_DATA_WIDTH 32;
};

define APB_BE_WIDTH 4;

// This type enumerates the logical names of each env.
// Must be extended by the user in the config file.
type apb_env_name_t : [DEFAULT];

// This type enumerates the logical names of each agent (master, or slave)
// in the verification environment. 
// The names must be unique in each UVC instance.
type apb_agent_name_t : [MASTER,SLAVE];

// =============================================================================
// Types Representing apb Signals
// =============================================================================

type apb_addr_t    : uint(bits:APB_ADDR_WIDTH);

type apb_data_t    : uint(bits:APB_DATA_WIDTH);

type apb_command_t : [READ, WRITE, IDLE] ;


// SLAVE identifier 
type apb_slave_id_t: [UNDEFINED,S0,S1,S2,S3,S4,S5,S6,S7,
                      S8,S9,S10,S11,S12,S13,S14,S15];

type apb_phase_t :[IDLE,                 // no trans currently going
                   SETUP,                // first cycle of transaction
                   ENABLE];              // second cycle

// This code provides a message tag that can be used to send certain message
// actions to a log file.
extend message_tag: [APB_FILE];

// TestFlow domain for this UVC
extend tf_domain_t: [APB_TF];

// =============================================================================
// Declaration of all Package Components
// =============================================================================

// APB Bus Monitor like inherited from uvm_monitor
unit apb_bus_monitor like uvm_monitor {

  tf_testflow_unit;

  // This unit and all units under it belong to the APB_TF
  // TestFlow domain
  keep soft tf_domain == APB_TF;

};

// APB Agent Monitor like inherited from uvm_monitor
unit apb_agent_monitor like uvm_monitor {};

// APB Agent unit like inherited from uvm_agent
unit apb_agent like uvm_agent {
 
  tf_testflow_unit;

  // This unit and all units under it belong to the APB_TF
  // TestFlow domain
  keep soft tf_domain == APB_TF;
  
};

// APB Master/Slave like Inherited from apb_agent
unit apb_master like apb_agent {};
unit apb_slave like apb_agent {};

// APB Environment like inherited from uvm_env
unit apb_env like uvm_env {

  tf_testflow_unit;

  // This unit and all units under it belong to the APB_TF
  // TestFlow domain
  keep soft tf_domain == APB_TF;
};


// APB bfm like inherited from uvm_bfm
unit apb_bfm like uvm_bfm {

  tf_testflow_unit;

  // This unit and all units under it belong to the APB_TF
  // TestFlow domain
  keep soft tf_domain == APB_TF;

};

// APB Master/Slave bfm's derived from apb_bfm
unit apb_master_bfm like apb_bfm {};
unit apb_slave_bfm like apb_bfm {};

'>
