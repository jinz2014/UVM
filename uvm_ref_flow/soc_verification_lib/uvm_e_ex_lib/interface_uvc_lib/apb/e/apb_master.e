---------------------------------------------------------------
File name   : apb_master.e
Title       : The MASTER implementation.
Project     : APB UVC
Developers  : 
Created     : Tue Mar 11 10:56:54 2008
Description : This file implements the master unit.
Notes       : This file contains master agent with monitor and 
              signal map binding
---------------------------------------------------------------
Copyright 1999-2011 Cadence Design Systems, Inc.
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

package apb;

// Signal Map and Monitor bindings are done here
extend apb_master {
    
  // Reference to the bus monitor for this env
  keep p_bus_monitor == p_env.bus_monitor;

  // reference to signal map
  keep p_smp == p_env.smp;

};

'>
