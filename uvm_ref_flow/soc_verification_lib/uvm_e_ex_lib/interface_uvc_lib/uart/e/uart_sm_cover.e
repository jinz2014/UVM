/*-----------------------------------------------------------------
File name     : uart_sm_cover.e
Title         : state machine coverage
Project       :
Created       : Wed Feb 18 10:46:07 2004
Description   : 
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

type uart_xmt_state_t : [ x_IDLE  = 3'b000, 
			  x_START = 3'b010,
			  x_WAIT  = 3'b011,
			  x_SHIFT = 3'b100,
			  x_STOP  = 3'b101](bits:3);

type uart_rcv_state_t : [ r_START  = 3'b001, 
			  r_CENTER = 3'b010,
			  r_WAIT   = 3'b011,
			  r_SAMPLE = 3'b100,
		 	  r_STOP   = 3'b101](bits:3);


extend  uart_monitor_u {
  event xmt_state_e;
  event rcv_state_e;
};

extend RX uart_monitor_u {
   
  event xmt_state_e is only change('(ssmp.XMT_STATE_SIG)') @p_sync.clk_r;
  
  !xmt_state : uart_xmt_state_t;
  
  on xmt_state_e {
    xmt_state = '(ssmp.XMT_STATE_SIG)';
  };
   
  cover xmt_state_e is {
    item xmt_state;
    
    transition xmt_state using ignore = ( 
      (xmt_state == x_IDLE and prev_xmt_state not in [x_IDLE, x_STOP]) or
      (xmt_state == x_START and prev_xmt_state != x_IDLE) or
      (xmt_state == x_WAIT and prev_xmt_state in [x_IDLE, x_STOP]) or
      (xmt_state == x_SHIFT and prev_xmt_state != x_WAIT) or
      (xmt_state == x_STOP and prev_xmt_state not in [x_WAIT, x_STOP])
    );      
  };  
};

extend TX uart_monitor_u {

  event rcv_state_e is only change('(ssmp.RCV_STATE_SIG)') @p_sync.clk_r;

  !rcv_state : uart_rcv_state_t;
  
  on rcv_state_e {
    rcv_state = '(ssmp.RCV_STATE_SIG)';
  };
  
  cover rcv_state_e is {
    item rcv_state;      
  };
};

'>
