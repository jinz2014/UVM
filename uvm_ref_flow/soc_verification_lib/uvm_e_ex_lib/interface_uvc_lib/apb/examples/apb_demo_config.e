-----------------------------------------------------------------
File name     : apb_demo_config.e
Developers    : 
Created       : Tue Jul 27 13:52:04 2008
Description   : This file configures the UVC.
Notes         :
-------------------------------------------------------------------
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
-------------------------------------------------------------------
<'

import apb/e/apb_memory_map.e;
import apb/e/apb_top.e;

extend apb_env_name_t : [APB];

extend sys { 

  // Instantiate the APB UVC
  apb_if:  apb_env is instance;
  memory_map : apb_memory_map_u is instance;
  keep soft memory_map.slaves_id.size() == 1;
  keep apb_if.p_memory_map ==read_only(memory_map);

  keep apb_if.name == APB;
  keep apb_if.master.name == MASTER;
  keep apb_if.passive_slave_names.size()  == 1;
  keep apb_if.active_slave_names.size()   == 0;

  keep for each (ss) in apb_if.slaves  { 
    soft ss.name ==  SLAVE;
    soft ss.active_passive == PASSIVE;
  };

  keep for each (ps) in apb_if.passive_slave_names  { 
    soft ps == S0;
  };

  post_generate() is also {
    var dmgr_def : tf_domain_manager;
    dmgr_def=sys.tf_get_domain_mgr_of(DEFAULT);
    //dmgr.set_timer_value(RESET,500);
    //dmgr.set_timer_value(MAIN_TEST,2000000);
    dmgr_def.set_timeout_off();
  };

};

extend  apb_env {
  event unqualified_clock_rise is only cycle @sys.any;
};

// APB Signal Map Bindings
extend apb_smp {

  keep APB_PCLK     ==  "~/tb/clk";     // Clock 
  keep APB_PRESETn  ==  "~/tb/presetn"; // Reset (active low)
  keep APB_PWDATA   ==  "~/tb/pwdata"; 	// 32-bit write data bus
  keep APB_PRDATA   ==  "~/tb/prdata"; 	// 32-bit read data bus
  keep APB_PADDR    ==  "~/tb/paddr";  	// 32-bit address	  
  keep APB_PWRITE   ==  "~/tb/pwrite"; 	// transfer direction
  keep APB_PENABLE  ==  "~/tb/penable"; // Enable
  keep APB_PREADY   ==  "~/tb/pready";  // Ready
  keep APB_PSEL     ==  "~/tb/psel";    // Psel

  keep soft sig_paddr.verilog_wire()   == TRUE; 
  keep sig_paddr.declared_range()      == "[31:0]";

  keep soft sig_penable.verilog_wire() == TRUE;

  keep soft sig_pwdata.verilog_wire()  == TRUE; 
  keep sig_pwdata.declared_range()     == "[31:0]";

  keep soft sig_prdata.verilog_wire()  == TRUE; 
  keep sig_prdata.declared_range()     == "[31:0]";

  keep soft sig_pwrite.verilog_wire()  == TRUE; 
  keep soft sig_pready.verilog_wire()  == TRUE;

};

extend apb_slave_signal_map_u {
  keep APB_PSEL ==  "~/tb/psel";
  keep sig_psel.verilog_wire() == TRUE;
};


'>
