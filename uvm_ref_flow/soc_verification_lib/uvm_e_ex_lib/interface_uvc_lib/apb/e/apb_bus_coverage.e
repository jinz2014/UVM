---------------------------------------------------------------
File name    : apb_bus_coverage.e
Title        : coverage for APB UVC
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008

---------------------------------------------------------------------------
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
---------------------------------------------------------------------------------


<'

package apb;

// Set the has_coverage flag to TRUE
extend  apb_bus_monitor {
  keep has_coverage == TRUE;
  event tr_ended_bus_cover;
}; // extend  apb...
'>

<'
extend has_coverage apb_bus_monitor {
  on tr_ended {
    emit tr_ended_bus_cover;
  }; // on tr_ended
}; // extend apb_...
'>


<'

extend apb_bus_monitor {

  //defines if transfer is ongoing
  !start_trans: bool;

  //measured in clock cycles
  !transfer_length: uint;

  //measured using sys.time
  !transfer_time: uint;
   
  on tr_ended {
    start_trans = FALSE;
    cur_transfer.end_transaction();
    transfer_time = cur_transfer.end_time - cur_transfer.start_time;
  }; // on transfer_end...   
   
  on tr_started {
    start_trans = TRUE;
    start clock_cntr();
  }; // on transfer_sta...
   
  //count the clocks between transfer_start and transfer_end
  clock_cntr()@pclk_f is {
    transfer_length=0;
    while(start_trans){
      transfer_length=transfer_length+1;
      wait;
    }; // while(start_tra...
  }; // clock_cntr()@en...

  cover tr_ended_bus_cover using text = "generic transfer info" is {

    item bus_addr : apb_addr_t = cur_transfer.addr using
      text="all addresses",
      ranges = {
       range([0],"");         
       range([1..0x7f],"");
      }; // ranges =

    item bus_direction : apb_command_t = cur_transfer.direction using
      text="transfer direction";

    cross bus_addr, bus_direction using name = addresses_with_RW;
   
    item slave_device :apb_slave_id_t=cur_transfer.slave_number
      using per_instance; // Collect separately for each master
    
    item transfer_length using 
      text="transfer clk cycles from start to finish",
      ranges = {
       range([0],"");
       range([1..15],"",1);
       range([16..32],"",4);
       range([32..0xFFFFFFFF],"");
    };
    item transfer_time using 
      text="transfer time from start to finish",
      ranges = {
       range([0],"");
       range([1..32],"",2);
       range([32..128],"",4);
       range([129..0xFFFFFFFF],"");
    };
          
    item bus_data : apb_data_t =cur_transfer.data using 
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
  }; // cover

}; // extend has_cove...

'>
