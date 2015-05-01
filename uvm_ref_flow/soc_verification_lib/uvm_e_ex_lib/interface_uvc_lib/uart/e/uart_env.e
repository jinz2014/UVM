/*-----------------------------------------------------------------
File name     : uart_env.e
Title         : UART environment unit
Project       :
Created       : Wed Feb 18 10:46:08 2004
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

// Declare the env unit - the top level of the eVC.
extend uart_env_u {

  // has a tx side
  has_tx : bool;
  keep soft has_tx == TRUE;

  // has rx side
  has_rx : bool;
  keep soft has_rx == TRUE;

  when has_tx uart_env_u {

    // TX Agent Instance
    tx_agent: TX uart_agent_u is instance;
    keep tx_agent.evc_name   == read_only(evc_name);
    keep tx_agent.agent_name == TX_AGENT;    
    keep tx_agent.p_env      == me;
    keep tx_agent.p_sync     == value(p_sync);
  };

  when has_rx uart_env_u {

    // RX Agent Instance
    rx_agent: RX uart_agent_u is instance;
    keep rx_agent.evc_name   == read_only(evc_name); 
    keep rx_agent.agent_name == RX_AGENT;       
    keep rx_agent.p_env      == me;
    keep rx_agent.p_sync     == value(p_sync);
  };

}; // extend uart_env_u..

'>

