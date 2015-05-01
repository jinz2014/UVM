/*-------------------------------------------------------------------------
File name   : uart_ctrl_apb_config.e
Title       : APB to uart signal map
Project     : Module UART
Created     :
Description : This file contains the port binding of APB eVC ports to UART DUT 

Notes       : Port mapping of APB eVC to uart dut
            :
-------------------------------------------------------------------------*/
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
// ----------------------------------------------------------------------

<'

package uart_ctrl_pkg;


// environment name
extend apb_env_name_t     : [uart];

// Configuration of the uVC instance and signal map bindings
#ifdef FV_KIT_NO_AHB_UVC {

  extend uart apb_smp {  
     keep APB_PCLK     == "specman_hclk";// clock 
     keep APB_PRESETn  == "hresetn";  	 // reset (active low)
     keep APB_PWDATA   == "apb_wdata"; 	 // 32-bit write data bus
     keep APB_PRDATA   == "apb_rdata"; 	 // 32-bit read data bus
     keep APB_PADDR    == "apb_addr";  	 // address	  
     keep APB_PWRITE   == "apb_rwd"; 	 // transfer direction
     keep APB_PENABLE  == "apb_enable";  // enable
     keep APB_PREADY   == "apb_ready";   // ready
     keep APB_PSEL     == "apb_sel";     // select
  
  };

  extend uart  apb_slave_signal_map_u {
    keep APB_PSEL ==  "apb_sel";
  };
  
  // PORT attributes for hdl simulator
  extend uart apb_smp { 
    keep soft sig_prdata.verilog_wire()   ==  TRUE    ; 
    keep soft sig_pready.verilog_wire()   ==  TRUE    ;
    keep soft sig_paddr.declared_range()  == "[4:0]"  ; 
    keep soft sig_prdata.declared_range() == "[31:0]" ;
    keep soft sig_pwdata.declared_range() == "[31:0]" ;
  };
  
}; // #ifdef

extend apb_env {
  // Pointer to uart env
  !uart_if : uart_env_u;
};



'>

