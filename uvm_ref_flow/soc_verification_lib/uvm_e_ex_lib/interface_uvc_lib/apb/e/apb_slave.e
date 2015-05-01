---------------------------------------------------------------
File name   :  apb_slave.e
Title       :  The SLAVE unit implementation.
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file implements the slave unit.

Notes       :  SLAVE agent has reset method which is used when the 
               slave is in active mode. The purpose is used to rerun
	       bfm when reset is asserted

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

//========================================================================
// The slave agents are reactive agents. Reactive agents only respond to 
// requests. The following code customizes slave agent.
//========================================================================
extend apb_slave {

  keep p_bus_monitor == p_env.bus_monitor;

  // This event is the rising edge of the clock
  event clk is rise(p_env.smp.sig_pclk$)@sim;

  keep p_bus_monitor == p_env.bus_monitor; 

  keep p_ssmp == p_env.ssmp.first(.id== me.id);

  when ACTIVE apb_slave {
   
    // Emit the driver clock
    on tf_phase_clock {
      emit driver.clock;
    };
  };

};

'>
