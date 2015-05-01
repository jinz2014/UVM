/*-------------------------------------------------------------------------
File name   : apb_subsystem_apb_config.e  
Title       : APB to UART signal map bindings
Project     :
Created     : November 2010
Description : This file contains the port binding of APB eVC ports to UART DUT 

Notes       : APB UVC to UART dut port bindings
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

import uart/e/uart_top;
import apb/e/apb_top; 

// -----------------------------------------------------------------------------
// CONFIGURATION FOR THE APB AGENTS
// -----------------------------------------------------------------------------
extend apb_env_name_t     : [apb_cluster];
extend apb_cluster apb_smp {  
   keep soft APB_PCLK 	   == "pclk";      // clock 
   keep soft APB_PRESETn   ==  "n_preset"; // reset (active low)
   keep soft APB_PWDATA	   ==  "pwdata";   // 32-bit write data bus
   keep soft APB_PRDATA	  ==  "i_ahb2apb.prdata_muxed";	// 32-bit read data bus
   keep soft APB_PADDR 	  ==  "paddr"; // Address 		  
   keep soft APB_PWRITE	  ==  "pwrite"; // transfer direction
   keep soft APB_PENABLE  ==  "penable"; // enable
   keep soft APB_PREADY     ==  "pready"; // Ready
   keep soft APB_PSEL ==  "psel_uart0"; // Select

};

// Psel for UART 0
extend apb_cluster S0 apb_slave_signal_map_u {
   keep soft APB_PSEL ==  "psel_uart0";
};

// PORT attributes for hdl simulator
extend apb_cluster apb_smp { 

  keep soft  sig_paddr.declared_range()  == "[31:0]"; 
  keep soft  sig_prdata.declared_range() == "[7:0]";
  keep soft  sig_pwdata.declared_range() == "[7:0]";

};

// Psel for UART 1
extend apb_cluster S1 apb_slave_signal_map_u {
  keep soft APB_PSEL ==  "psel_uart1";
};

// Psel for SPI slave
extend apb_cluster S2 apb_slave_signal_map_u {
   keep soft APB_PSEL ==  "psel_spi"; //spi
};

// Psel for GPIO slave
extend apb_cluster S3 apb_slave_signal_map_u {
   keep soft APB_PSEL ==  "psel_gpio"; //gpio
};


extend apb_cluster S4 apb_slave_signal_map_u {
   keep soft APB_PSEL ==  "psel_pmc"; //pcm
};

extend has_coverage apb_bus_monitor {
  cover tr_ended_bus_cover is also {
    item all_slave_addr :  apb_addr_t = cur_transfer.addr using
      text="all peripheral slave ranges",
      ranges = {
        range([0x00800000..0x00800000],""); // spi 
        range([0x00810000..0x008100ff],""); // uart0 
        range([0x00820000..0x008200ff],""); // gpio 
        range([0x008d0000..0x008d00ff],""); // pcm 
        range([0x008f0000..0x008f00ff],""); // uart1 
      }; // ranges =
  };
};

'>

