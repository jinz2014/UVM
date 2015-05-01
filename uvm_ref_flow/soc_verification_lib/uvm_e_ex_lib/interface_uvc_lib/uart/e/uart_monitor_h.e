/*-----------------------------------------------------------------
File name     : uart_monitor_h.e
Title         : UART Monitor defination
Project       :
Created       : Wed Feb 18 10:46:08 2004
Description   : uart monitor unit is derived from uvm_monitor
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

extend RX uart_agent_u {

  keep soft agents_short_name == dec(agent_name);
  keep soft agents_vt_style == BLUE;   

  // RX Signal map
  ssmp: uart_rx_signal_map_u is instance;
  keep ssmp.evc_name   == read_only(evc_name);
  keep ssmp.agent_name == read_only(agent_name);
    
  when has_monitor uart_agent_u {
    // RX Monitor unit
    monitor: RX uart_monitor_u is instance;
    keep monitor.p_agent    == me;
    keep monitor.evc_name   == read_only(evc_name);
    keep monitor.agent_name == read_only(agent_name);
    keep monitor.p_sync == value(p_sync);
    keep monitor.ssmp == value(ssmp);
    keep monitor.has_checker == value(has_checks);
    keep monitor.has_coverage == value(has_coverage);
    keep soft monitor.do_check == TRUE;
  }; // when..

}; // extend RX uart_agent_u..


extend TX uart_agent_u {

  keep soft agents_short_name == dec(agent_name);
  keep soft agents_vt_style == RED;   
  
  // TX Signal map
  ssmp: uart_tx_signal_map_u is instance;
  keep ssmp.evc_name   == read_only(evc_name);
  keep ssmp.agent_name == read_only(agent_name);
  
  when has_monitor uart_agent_u {
    // TX Monitor unit
    monitor: TX uart_monitor_u is instance;
    keep monitor.p_agent == me;
    keep monitor.evc_name   == read_only(evc_name);
    keep monitor.agent_name == read_only(agent_name);
    keep monitor.p_sync == value(p_sync);
    keep monitor.ssmp   == value(ssmp);
    keep monitor.has_checker == value(has_checks);
    keep monitor.has_coverage == value(has_coverage);
    keep soft monitor.do_check == FALSE;
  }; // when..

}; // extend TX uart_agent_u..


// Add an event for coverage of frame
extend uart_frame_s {
  event frame_done;
};

// uart monitor unit derived from uvm_monitor
unit uart_monitor_u like uvm_monitor {

  // Env name
  evc_name : uart_env_name_t;

  // Agent name
  agent_name : uart_agent_name_t;

  // A pointer to the synchronizer
  p_sync : uart_sync;

  // define TX or RX
  direction: uart_agent_dir_kind_t;
	
  // A configuration unit for the environment
  !config: uart_env_config;

  // extra checker in a passive mode
  has_checker: bool;
  keep soft has_checker;

  do_check: bool;
  keep soft do_check == FALSE;

  // extra coverage in passive mode
  has_coverage:   bool;
  keep soft has_coverage;

  // current frame field	
  !current_frame: uart_frame_s; 

  //---------------------------
  // Monitor event definitions
  //---------------------------

  // monitor receive all the bit stream of a frame
  event mon_receive_done;
  event mon_frame_done;
  
  // monitor start receive the first valid data of the frame
  event mon_frame_started; 

  // ready frame structure in the end of data receive and analysis
  event mon_frame_ended;

  // the recived clk - sample the data change on line 
  event mon_clk;


  //--------------------
  // MONITOR FSM
  //--------------------
  mon_state : uart_mon_state_t;
   
  // Message screen logger for this monitor
  logger: message_logger is instance;

  // Message file logger for this agent
  file_logger: message_logger is instance;

  keep soft file_logger.to_screen == FALSE;
  keep soft file_logger.to_file == "uart.elog";

  // Agent short name to be used in message
  short_name(): string is only {
    return "MONITOR";
  }; 
   
  // Use agents_vt_style in message
  short_name_style() : vt_style is {
    return monitor_vt_style;
  };
   
  // Color of unit's name to be used in messages
  monitor_vt_style: vt_style;
  keep soft monitor_vt_style == DARK_GREEN;
    
  // method to record the data from the signals and define sertain value collected
  record_data() @p_sync.clk_r is empty;

  // method of  monitor state machine  
  monitor_fsm() @mon_clk is empty; 
    
  // Hook for later usage by scoreboards
  frame_done(frame: uart_frame_s) is empty;
   	
  on mon_frame_ended {
    frame_done(current_frame);
    emit current_frame.frame_done;
    emit mon_frame_done;
  };
  
  
  run() is also {
    // starting the TCM's
    start record_data();
    start monitor_fsm();
  };

  // Reset the internal vars
  reset_vars() is empty;
     
  reset_started() is empty;
  
  // check the signal value 
  perform_protocol_checking() is empty;
  
  // check the signal value 
  perform_reset_protocol_checking() is empty; 
  
  // On the start of reset reset the internal vars
  reset_started() is {
    reset_vars();
  }; 
   
  event reset_ended is @p_sync.reset_ended;
  on reset_ended {
    perform_reset_protocol_checking();
  };

};

// Declare the RX monitor unit 
extend  RX uart_monitor_u  {

  // reference to parent agent
  p_agent: has_monitor RX uart_agent_u;

  // Pointer to RX Signal Map
  ssmp: uart_rx_signal_map_u;
}; 



// Declare the TX monitor unit 
extend  TX uart_monitor_u  {

  // reference to parent agent
  p_agent:  has_monitor TX uart_agent_u;
  
  // Pointer to TX Signal Map
  ssmp: uart_tx_signal_map_u;

}; 


extend has_tx uart_env_u { 

  // Binding the pointers through connect_pointers()..
  connect_pointers() is also { 
    if tx_agent is a has_monitor TX uart_agent_u (mon_agent) then {
      mon_agent.monitor.config = config;
    };
  }; // connect_pointers()..
};


extend has_rx uart_env_u { 

  // Binding the pointers through connect_pointers()..
  connect_pointers() is also { 
    if rx_agent is a has_monitor RX uart_agent_u (mon_agent) then {
      mon_agent.monitor.config = config;
    };
  }; // connect_pointers()..
};

'>

