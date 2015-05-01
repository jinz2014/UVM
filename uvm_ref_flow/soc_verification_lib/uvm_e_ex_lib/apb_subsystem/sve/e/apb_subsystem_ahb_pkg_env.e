/*-------------------------------------------------------------------------
File name   : apb_subsystem_ahb_pkg_env.e
Title       : Multi Layer environment environment instantiation and configuration
Project     : AHB uVC
Created     : November 2010
Description : APB Subsystem Verification Environment

Notes       : 
-------------------------------------------------------------------------*/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------


<'

package uvc_ahb;

// Imported the Open core AHB UVC 
import ahb/e/ahb_top.e;

//Add Multi Layered Environment's name
extend ahb_env_name_t : [AHB_ENV_0];

// Create an environment with the topology that you want
// The Environment Unit is derived from uvm_env
unit multi_layer_env like uvm_env {

  // AHB UVC Instance with MASTER and SLAVE
  ahb_interfaces : list of TRUE'has_slave TRUE'has_master ahb_env is instance;

  // Environment name
  env_name : ahb_env_name_t;

  // AHB Master Monitor
  !mas_monitor : MASTER ahb_agent_monitor ;

  // Binding the MASTER Monitor using connect_pointers()
  connect_pointers() is also {
    mas_monitor = ahb_interfaces[0].master.monitor;
  };

};

extend AHB_ENV_0 multi_layer_env {

  // Only one master and slave are present
  keep ahb_interfaces.size() == 1;
 
  // ------------------------------------------------------------
  // For each of the ahb_interfaces constrain the active_passive field
  // ------------------------------------------------------------
  keep for each (m) in ahb_interfaces {
    index == 0 =>
    soft m.master.active_passive == ACTIVE and
    soft m.slave.active_passive == PASSIVE and
    soft m.has_checks   == TRUE and
    soft m.has_coverage == TRUE and
    m.master.agent() == "verilog";
  }; 
    
}; // AHB_ENV_0 multi_layer_env 
    

// -----------------------------------------------------------------------------
// Signal mapping - Map the signals of all the agents 
// -----------------------------------------------------------------------------

extend ahb_slave_smp {

  // Protection control
  keep soft AHB_HPROT.hdl_path() == "hprot0";
  keep bind(AHB_HPROT,external);    -- Protec6.0i26_opttion control
  
  // Write data bus
  keep soft AHB_HWDATA.hdl_path() == "hwdata0";
  keep bind(AHB_HWDATA,external); -- Write data
  
  // Read data bus
  keep soft AHB_HRDATA.hdl_path() == "hrdata0";
  keep bind(AHB_HRDATA,external);
  
  -- Address bus
  keep soft AHB_HADDR.hdl_path() == "haddr0";
  keep bind(AHB_HADDR,external);    -- Address
  
  // Transfer direction
  keep soft AHB_HWRITE.hdl_path() == "hwrite0"; --direction
  keep bind(AHB_HWRITE,external);    -- Address
  
  // Transfer size
  keep soft AHB_HSIZE.hdl_path() == "hsize0"; --transfer size
  keep bind(AHB_HSIZE,external);    -- Address
  
  // Burst kind
  keep soft AHB_HBURST.hdl_path() == "hburst0"; --burst kind
  keep bind(AHB_HBURST,external);    -- Address
  
  // Transfer kind
  keep soft AHB_HTRANS.hdl_path() == "htrans0";
  keep bind(AHB_HTRANS,external); -- Transfer kind
  
  // Transfer done
  keep soft AHB_HREADY.hdl_path() == "hready0";
  keep bind(AHB_HREADY,external);
  
  // Transfer response
  keep soft AHB_HRESP.hdl_path() == "hresp0"; 
  keep bind(AHB_HRESP,external);
  
  // Mask split master
  keep bind(AHB_HSPLIT,empty);

  // Locked sequence
  keep soft AHB_HLOCK.hdl_path() == "hlock0";
  keep bind(AHB_HLOCK,external);

};

extend ahb_master_smp {

  // Protection control
  keep soft AHB_HPROT.hdl_path() == "hprot0";
  keep bind(AHB_HPROT,external); 
  
  // Write data bus
  keep soft AHB_HWDATA.hdl_path() == "hwdata0";
  keep bind(AHB_HWDATA,external);
  
  // Read data bus
  keep soft AHB_HRDATA.hdl_path() == "hrdata0";
  keep bind(AHB_HRDATA,external);
  
  // Address bus
  keep soft AHB_HADDR.hdl_path() == "haddr0";
  keep bind(AHB_HADDR,external);
  
  // Transfer direction
  keep soft AHB_HWRITE.hdl_path() == "hwrite0";
  keep bind(AHB_HWRITE,external);
  
  // Transfer size
  keep soft AHB_HSIZE.hdl_path() == "hsize0"; 
  keep bind(AHB_HSIZE,external); 
  
  // Burst kind
  keep soft AHB_HBURST.hdl_path() == "hburst0";
  keep bind(AHB_HBURST,external);
  
  // Transfer kind
  keep soft AHB_HTRANS.hdl_path() == "htrans0";
  keep bind(AHB_HTRANS,external);
  
  // Transfer done
  keep soft AHB_HREADY.hdl_path() == "hready0";
  keep bind(AHB_HREADY,external);
  
  // Transfer response
  keep soft AHB_HRESP.hdl_path() == "hresp0"; 
  keep bind(AHB_HRESP,external);
  
  // Mask split master
  keep bind(AHB_HSPLIT,empty);

  // Locked sequence
  keep soft AHB_HLOCK.hdl_path() == "hlock0";
  keep bind(AHB_HLOCK,external);

};

// Binding the clock and reset of the AHB system signal map
extend ahb_system_smp {

  // Clock
  keep soft clk.hdl_path() == "specman_hclk";
  keep bind(clk,external);
  
  // Reset (active low)   
  keep soft reset.hdl_path() == "hresetn";
  keep bind(reset,external);

};     

'>
