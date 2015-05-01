---------------------------------------------------------------
File name   : gpio_env.e
Created     : Tue Jun 17 13:52:03 2008
Description : This file implements the UVC env 
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

package gpio;

// GPIO Environment inherited from uvm_env
unit gpio_env like uvm_env {
       
  // This field holds the logical name of this env. This field must be
  // constrained by the user in the config file.
  name  : gpio_env_name_t;
    
  // Signal map instances
  smp   : gpio_smp is instance;
  keep smp.env_name == read_only(name);
    
  // Field to enable the protocol checks
  has_checks   : bool;
  keep soft has_checks == TRUE;

  // Field to enable the coverage
  has_coverage : bool;
  keep soft has_coverage == TRUE;
    
  // GPIO Agent instance , default agent is instantiated as ACTIVE
  agent : gpio_agent is instance;
  keep soft agent.active_passive == ACTIVE;
  keep agent.monitor.has_checks  == read_only(has_checks);
  keep agent.monitor.has_coverage == read_only(has_coverage);
    
  // connect_pointers() is called after post_generate() to create unit
  // references between sibling units.
  connect_pointers() is also {
    agent.p_smp = smp;
  };
    
  // Report the final status at the end of the test.
  finalize() is also {
    message(LOW, "Test done:");
    show_status();
  }; 
    
  // Print a banner for each UVC instance at the start of the test.
  show_banner() is also {
    out("(c)  2008");
    out("Env : ", name);
  };
}; 

'>
