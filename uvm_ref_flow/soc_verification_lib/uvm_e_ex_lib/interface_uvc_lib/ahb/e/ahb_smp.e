-----------------------------------------------------------------
File name     : ahb_smp.e
Developers    : vishwana
Created       : Tue Mar 30 14:29:27 2010
Description   : This file declares the signal map of the UVC.
Notes         : The signal map is a unit that contains external ports
              : for each of the HW signals that each agent must access 
              : as it interacts with the DUT.
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
package ahb;

--=========================================================================
-- UVC Signal Map. Contains the names of the general signals
-- AHB Signal Map like inherited from uvm_signal_map
--========================================================================= 
unit ahb_smp like uvm_signal_map {
  
  -- Environment Name
  env_name : ahb_env_name_t;
  
  -- Ports :
   
  -- Protection control
  AHB_HPROT: inout simple_port of uint(bits:4) is instance;
  keep bind(AHB_HPROT,empty);
  
  -- Write data bus
  AHB_HWDATA: inout simple_port of ahb_data is instance;
  keep bind(AHB_HWDATA,empty);
  
  -- Read data bus
  AHB_HRDATA: inout simple_port of ahb_data is instance;
  keep bind(AHB_HRDATA,empty);
  
  -- Address bus
  AHB_HADDR: inout simple_port of ahb_address is instance;
  keep bind(AHB_HADDR,empty);
  
  -- Transfer direction
  AHB_HWRITE: inout simple_port of ahb_direction is instance;
  keep bind(AHB_HWRITE,empty);
  
  -- Transfer size
  AHB_HSIZE: inout simple_port of ahb_transfer_size is instance;
  keep bind(AHB_HSIZE,empty);
  
  -- Burst kind
  AHB_HBURST: inout simple_port of ahb_burst_kind is instance;
  keep bind(AHB_HBURST,empty);
  
  -- Transfer kind
  AHB_HTRANS: inout simple_port of ahb_transfer_kind is instance;
  keep bind(AHB_HTRANS,empty);
  
  -- Transfer done
  AHB_HREADY: inout simple_port of bit is instance;
  keep bind(AHB_HREADY,empty);
  
  -- Transfer response
  AHB_HRESP: inout simple_port of ahb_response_kind is instance;
  keep bind(AHB_HRESP,empty);
  
  -- Mask split master
  AHB_HSPLIT: inout simple_port of uint(bits:AHB_MAX_MASTERS_NUM) is instance;
  keep bind(AHB_HSPLIT,empty);

  -- Locked sequence
  AHB_HLOCK: inout simple_port of bit is instance;
  keep bind(AHB_HLOCK,empty);
   
   
};

-- AHB Slave Signal Map like inherited from AHB Signal Map
unit ahb_slave_smp like ahb_smp {};

-- AHB Master Signal Map like inherited from AHB Signal Map
unit ahb_master_smp like ahb_smp {}; 

'>
