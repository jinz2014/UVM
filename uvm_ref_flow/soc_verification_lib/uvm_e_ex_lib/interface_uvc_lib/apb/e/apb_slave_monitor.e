---------------------------------------------------------------
File name   :  apb_slave_monitor.e
Title       :  Bus and agent monitors implementation.
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file implements the bus monitor and agent monitor 
               units.
Notes       :  This files contains monitor hooked to apb slave and provides 
               inputs to scoreboard
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

package apb;

extend apb_slave_monitor {
  event tr_ended is true(p_bus_monitor.cur_transfer.slave_number == p_agent.as_a(apb_slave).id)@p_bus_monitor.tr_ended;
};

extend  apb_slave_monitor {
  keep soft has_coverage == TRUE;
}; // extend  apb...

extend has_coverage apb_slave_monitor {

  event tr_ended_slave_cover;

  on tr_ended {
    emit tr_ended_slave_cover;
  }; // on tr_ended

}; // extend apb_...

'>


