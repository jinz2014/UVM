---------------------------------------------------------------
File name   :  apb_slave_coverage.e
Title       :  SLAVE Coverage.
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file implements the slave coverage .
Notes       :  This files contains monitor hooked to apb slave
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
extend has_coverage apb_slave_monitor {
   cover tr_ended_slave_cover using per_unit_instance, text = "generic slave transfer info" is {

      item bus_addr : apb_addr_t = p_bus_monitor.cur_transfer.addr using
        text="all addresses",
        ranges = {
         range([0..0x1F],"");         
         range([0x20..0xFFFFFFFF],""); 
        }; // ranges =

      item bus_direction : apb_command_t = p_bus_monitor.cur_transfer.direction using
        text="transfer direction";
      cross bus_addr, bus_direction using name = addresses_with_RW;
    
      item transfer_time : uint = p_bus_monitor.transfer_time using 
        text="transfer time from start to finish",
        ranges = {
         range([0],"");
         range([1..32],"",2);
         range([32..128],"",4);
         range([129..0xFFFFFFFF],"");
      };

     
    item transfer_length : uint = p_bus_monitor.transfer_length  using 
      text="transfer clk cycles from start to finish",
      ranges = {
       range([0],"");
       range([1..15],"",1);
       range([16..32],"",4);
       range([32..0xFFFFFFFF],"");
    };
            
      item bus_data : apb_data_t =p_bus_monitor.cur_transfer.data using 
        text="Transfer data (DATA)",
        ranges = {
         range([0],"");         
         range([1..0xff],"");
         range([0x100..0xFFFF-1],"");
         range([0xFFFF],"");
      }; //

      transition bus_addr using 
        name = transition__bus_addr;
      transition bus_direction using 
        name = transition__bus_direction;
      cross transition__bus_direction, transfer_length using 
        name = clk_latency_vs_direction;
      cross transition__bus_direction, transfer_time using 
        name = time_latency_vs_direction;
      cross transition__bus_direction,transition__bus_addr using 
        name = direction_vs_addr;
      cross clk_latency_vs_direction,direction_vs_addr using 
        name=clk_latency_vs_direction_vs_addr;
      cross time_latency_vs_direction,direction_vs_addr using 
        name=time_latency_vs_direction_vs_addr;
      cross bus_direction,bus_addr,bus_data using 
        name =cross_all_apb_slave_transfe;

	  
   };
}; // extend apb_...
'>


