---------------------------------------------------------------
File name   : gpio_config.e
Created     : Tue Jun 17 13:52:04 2008
Description : This file configures the UVC.
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

// Import the gpio UVC
import gpio/e/gpio_top;

// Create a logical name for each UVC instance. 
extend gpio_env_name_t : [ENV_0];


// Instantiate the UVC under sys. Where there is more than one instance
// you can either have multiple instances as below or create a list of
// instances.

extend sys {
  gpio_evc : ENV_0 gpio_env is instance;
  keep gpio_evc.hdl_path() == "dut_dummy";
};


extend ENV_0 gpio_env {
    
  // The agent agent is active
  keep agent is a ACTIVE gpio_agent;
    
  // This instance of the UVC has coverage collection
  keep has_coverage == TRUE;

  // This instance of the UVC has a protocol checker
  keep has_checks == TRUE;

}; 

// Signal map configuration
// Configure the UVC instance. This section sets up how the UVC accesses
// DUT signals.

extend ENV_0 gpio_smp {
    
  keep sig_clk.hdl_path()            == "sig_clock";
  keep sig_reset.hdl_path()          == "sig_reset";
  
  keep sig_data_in.hdl_path()        == "sig_data_in";
  keep sig_data_in.verilog_wire()    == TRUE;
  keep sig_data_in.declared_range()  == "[15:0]";
  
  keep sig_data_out.hdl_path()       == "sig_data_out";
  keep sig_data_out.verilog_wire()   == TRUE;
  keep sig_data_out.declared_range() == "[15:0]";

  keep sig_data_oe.hdl_path()        == "sig_data_oe";
  keep sig_data_oe.verilog_wire()    == TRUE;
  keep sig_data_oe.declared_range()  == "[15:0]";

};

extend sys {
  setup() is also {
    set_config(print, radix, hex);
    set_config(run, tick_max, 10000000);
  };
};


'>
