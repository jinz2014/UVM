/*-------------------------------------------------------------------------
File name   : apb_subsystem_monitor.e
Title       : APB Subsystem Monitor 
Project     :
Created     : November 2010
Description : APB Subsystem Monitor with scoreboard instances
              
Notes       : APB Subsystem Monitor unit is derived from uvm_monitor and 
              UVM scoreboards are used for scoreboarding at different
	      interfaces
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

// ------------------------------------------------------------
// APB-Subsystem Monitor unit which is derived from uvm_monitor
// ------------------------------------------------------------
unit apb_subsystem_monitor_u like uvm_monitor {

  has_scbd : bool;
  keep soft has_scbd;

  -- Collect coverage
  has_coverage: bool;
  keep soft has_coverage == TRUE;

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

  p_env : apb_subsystem_env_u;

};

// -------------------------------------------------------------
// Instantiating all the UVM Scoreboards inside the Monitor unit
// -------------------------------------------------------------
extend has_uart0 has_scbd apb_subsystem_monitor_u {
  uart_ahb_scoreboard : apb_subsystem_ahb_uart_uvm_scoreboard_u is instance;
};

extend has_uart1 has_scbd apb_subsystem_monitor_u {
  uart_ahb_lp_scoreboard : apb_subsystem_ahb_uart_uvm_scoreboard_u is instance;
};

extend has_spi has_scbd apb_subsystem_monitor_u {
  spi_ahb_scoreboard : apb_subsystem_ahb_spi_uvm_scoreboard_u is instance;
};

// --------------------------------------------------------
//  Add the DUT coverage unit to verification environment
// --------------------------------------------------------
extend has_coverage apb_subsystem_monitor_u {
  apb_subsystem_cov : apb_subsystem_cover_u is instance;
};

'>
