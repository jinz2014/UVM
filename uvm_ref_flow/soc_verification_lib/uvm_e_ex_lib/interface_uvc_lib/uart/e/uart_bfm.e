/*-----------------------------------------------------------------
File name     : uart_bfm.e
Title         : UART Bus Functional Model
Project       :
Created       : Wed Feb 18 10:46:07 2004
Description   : uart bfm unit is like inherited from uvm_bfm
Notes         : 
-------------------------------------------------------------------*/
//  Copyright 1999-2010 Cadence Design Systems, Inc.
//  All Rights Reserved Worldwide
//
//  Licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in
//  compliance with the License.  You may obtain a copy of
//  the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in
//  writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//  CONDITIONS OF ANY KIND, either express or implied.  See
//  the License for the specific language governing
//  permissions and limitations under the License.
//----------------------------------------------------------------------

<'

package uart;

// Add BFM only for an agent with a tx path
extend ACTIVE TX uart_agent_u {

  // TX BFM instance
  bfm: TX uart_bfm_u is instance;

  keep bfm.p_agent    == me;
  keep bfm.agent_name == read_only(agent_name);
  keep bfm.evc_name   == read_only(evc_name);
  keep bfm.p_sync     == value(p_sync);
  keep bfm.ssmp       ==  value(ssmp);

  connect_pointers() is also {
    bfm.config = p_env.config;
  };
};

// Add BFM only for an agent with a rx path
extend ACTIVE RX uart_agent_u {

  // RX BFM instance
  bfm: RX uart_bfm_u is instance;

  keep bfm.p_agent    == me;
  keep bfm.agent_name == read_only(agent_name);
  keep bfm.evc_name   == read_only(evc_name);
  keep bfm.p_sync     == value(p_sync);
  keep bfm.ssmp       ==  value(ssmp);

  connect_pointers() is also {
    bfm.config = p_env.config;
  };
};

// BFM unit like inherited from uvm_bfm
unit uart_bfm_u like uvm_bfm {

  // Enviroment name
  evc_name : uart_env_name_t;
  
  // Agent name
  agent_name: uart_agent_name_t;

  // A pointer to the synchronizer
  p_sync: uart_sync;

  // A configuration unit for the environment
  config: uart_env_config;

  // define TX or RX
  direction: uart_agent_dir_kind_t;
    
  // On the start of reset, reset the internal vars
  // and set the signals to their init values
  reset_started() is empty; 

  event bfm_reset_started is @p_sync.reset_started;
  on bfm_reset_started {
    reset_started();
  };
   
  // Called when the reset is ended
  reset_ended() is empty;
   
  // Method to predict size of frame
  bit_size() : uint is {

    result = 1; // for start bit
    if config.parity_type != NONE then {
      result += 1;
    };

    case config.databit_type {
      FIVE  { result += 5; };
      SIX   { result += 6; };
      SEVEN { result += 7; };
      EIGHT { result += 8; };
    };

    if config.stopbit_type == TWO then {
      result += 2;
    } else {
      result += 1;
    };
  };
};    

// TX BFM
extend TX uart_bfm_u {

  // Reference to parent agent
  p_agent : TX ACTIVE uart_agent_u;

  // TX signal Map
  ssmp: uart_tx_signal_map_u;

  // Events related to transfers
  event bfm_trans_started;
  event bfm_trans_ended;
      
  !cur_frame: uart_frame_s;

  execute_items() @p_sync.clk_r is empty; 
  
  drive_frame(cur_frame : uart_frame_s) @p_sync.clk_r is  empty;
  
  init_signals() is {
    ssmp.sig_sec_cdma_tx_data$ = 1;
  };
  
  reset_started() is {
    reset_vars();
    init_signals();
  }; 

  // init values of the env 
  reset_vars() is {
    cur_frame = NULL; 
  };
	  
  run() is also {
    init_signals();
    start execute_items();
  };

}; // end TX bfm

// RX bfm
extend RX uart_bfm_u {

  // reference to parent agent
  p_agent : RX ACTIVE uart_agent_u;

  // RX signal Map
  ssmp: uart_rx_signal_map_u;

  // Events related to transfers
  event bfm_trans_started;
  event bfm_trans_ended;

  // num of frames that the rfrb assert low
  !num_of_frame:uint;
  keep soft num_of_frame in [20 ..100];

  // num of cycle that the rfrb assert high
  !delay_between_frames:uint;
  keep soft delay_between_frames in [20 ..100];
	
  execute_items() @p_sync.clk_r is empty;
    
  drive_frame(num : uint, delay_between_frames:uint) @p_sync.clk_r is  empty;
	
  init_signals() is {
    ssmp.sig_sec_cdma_rfrb$ = 1;
  };
    
  // On the start of reset, reset the internal vars
  // and set the signals to their init values
  reset_started() is {
    reset_vars();
    init_signals();
  }; 

  // init values of the env 
  reset_vars() is empty; 
   
	  
  run() is also {
    init_signals();
    start execute_items();
  };

}; //end RX bfm

'>


