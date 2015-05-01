/*-------------------------------------------------------------------------
File name   : apb_subsystem_env_h.e
Title       : APB Subsystem Environment
Project     :
Created     : November 2010
Description : APB Subsystem environment , containing pointers to 
              several peripheral eVC's like spi,gpio,uart etc. 
Notes       : 
-------------------------------------------------------------------------*/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

<'

package apb_subsystem_pkg;

unit apb_subsystem_env_u like uvm_env {};

extend apb_subsystem_env_u {

  -- Pointer to the ahb_bridge environmant
  !ahb_if: multi_layer_env ;

  has_apb: bool;
  keep soft has_apb == TRUE;

  has_uart0: bool;
  keep soft has_uart0 == TRUE;

  has_uart1: bool;
  keep soft has_uart1 == TRUE;

  has_spi: bool;
  keep soft has_spi == TRUE;

  has_gpio: bool;
  keep soft has_gpio == TRUE;

  has_vr_ad: bool;
  keep soft has_vr_ad == TRUE;

  when has_uart0 apb_subsystem_env_u {
    -- Point to the UART synchronizer
    !fp_uart_sync: uart_sync ;
  
    -- Pointer uart env
    !fp_uart_if: uart_env_u ;
  };
  
  when has_uart1 apb_subsystem_env_u {
    -- Point to the UART synchronizer
    !lp_uart_sync: uart_sync ;
   
    -- Pointer uart env
    !lp_uart_if: uart_env_u ;
  };

  when has_gpio apb_subsystem_env_u {
    -- Pointer gpio env
    !gpio_if: gpio_env ;
  }; 
  
  when has_spi apb_subsystem_env_u {
    -- Pointer spi env
    !spi_if:  spi_env_u;
  }; 
  
  when has_vr_ad apb_subsystem_env_u {
    -- Poiner to vr_ad Address map
    !p_addr_map : vr_ad_map;
  }; 
  
  has_monitor: bool;
  keep soft has_monitor == TRUE;
   
  has_scbd : bool;
  keep soft has_scbd;

  has_ahb0 : bool;
  keep soft has_ahb0 == FALSE; 
  -- Message screen logger for thisagent
  logger: message_logger is instance;

  -- Message file logger for this agent
  file_logger: message_logger is instance;
  keep soft file_logger.to_screen == FALSE;
  keep soft file_logger.to_file == "apb_subsystem_mod.elog";


  -- Use agent's short name in message
  short_name(): string is {
    return env_short_name;
  }; 
   
  -- Use env_vt_style in message
  short_name_style() : vt_style is {
    return env_vt_style;
  };
  
  -- Agents short name to be used in messages
  env_short_name: string;

  -- Agent color to be used in messages
  env_vt_style: vt_style;
  
};

'>

