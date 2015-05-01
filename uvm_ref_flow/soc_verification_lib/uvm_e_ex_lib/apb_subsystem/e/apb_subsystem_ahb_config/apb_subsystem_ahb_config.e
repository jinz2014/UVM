/*-------------------------------------------------------------------------
File name   : apb_subsystem_ahb_config.e
Title       : Flat environment instantiation and configuration
Project     : AHB uVC
Created     : November 2010
Description : 
              
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

package apb_subsystem_pkg;

#ifndef AHB_USING_PORTS {
    #define AHB_USING_PORTS;
 };

#ifndef AHB_STANDARD_E {
   #define AHB_STANDARD_E;
};

import ahb/e/ahb_top;

#ifndef AHB_SET_ERROR_WARNINGS {
  #define AHB_SET_ERROR_WARNINGS;
  extend sys {
    setup() is also {
      // make these checks warnings:
      set_check("/un-mapped address/",WARNING);
      set_check("...ERR_VR_AHB168...",WARNING);
      set_check("...ERR_VR_AHB320...",WARNING);
      set_check("...ERR_VR_AHB331...",WARNING);
    };
  };
};

-- =============================================================================
-- Define the new env unit
-- =============================================================================
extend ahb_evc_name : [AHB0];
extend AHB0 ahb_env {
    keep soft stop_condition == CYCLES;
    keep soft test_time == 300;
   
    keep soft not has_passive_masters;
    keep soft has_active_masters;
    keep soft has_passive_slaves;
    keep soft has_active_slaves;
    keep soft has_active_arbiter;
    keep soft not has_passive_arbiter;
    keep soft has_active_decoder;
    keep soft not has_passive_decoder;
    keep soft not has_monitor;
    keep soft not has_dummy_master;

 
};

extend AHB0 ahb_env_config {
    keep soft num_of_passive_masters == 0;
    keep soft num_of_active_masters == 1;
    keep soft num_of_passive_slaves == 1;
    keep soft num_of_active_slaves == 1;
    keep soft active_master_names == {M0};
    keep soft passive_slave_names == {S0};
    keep soft active_slave_names == {S1};    
};
-- =============================================================================
-- Instantiate and configure the new my_ahb_env unit
-- =============================================================================


-- -----------------------------------------------------------------------------
-- Configure active masters behaviour
-- -----------------------------------------------------------------------------
extend AHB0 ahb_master {
   keep soft config.all_slaves_name == {S0;S1};
   keep soft config.all_masters_name == {M0} ;
   keep soft config.data_width == 32 ;
   keep soft config.addr_width == 32 ;
   keep soft agents_short_name == "M0"; 
   keep soft agent() == "verilog";
   keep soft randomize_idle == FALSE;
};

-- -----------------------------------------------------------------------------
-- Signal mapping
-- -----------------------------------------------------------------------------
// bus signals
extend AHB0 ahb_signal_map {
     keep soft AHB_HTRANS.hdl_path() == "htrans";
     keep bind(AHB_HTRANS,external);
     keep soft AHB_HADDR.hdl_path() == "haddr";
     keep bind(AHB_HADDR,external);               
     keep soft AHB_HWRITE.hdl_path() == "hwrite"; --direction
     keep soft AHB_HSIZE.hdl_path() == "hsize"; --transfer size
     keep soft AHB_HBURST.hdl_path() == "hburst"; --burst kind
     keep soft AHB_HPROT.hdl_path() == "hprot";
     keep bind(AHB_HPROT,external);
     keep soft AHB_HWDATA.hdl_path() == "hwdata";
     keep bind(AHB_HWDATA,external);
     keep soft AHB_HREADY.hdl_path() == "hready";
     keep bind(AHB_HREADY,external);
     keep soft AHB_HRESP.hdl_path() == "hresp"; --response kind
     keep soft AHB_HRESET.hdl_path() == "hresetn";
     keep bind(AHB_HRESET,external);
     keep soft AHB_HCLK.hdl_path() == "specman_hclk";
     keep bind(AHB_HCLK,external);
     keep soft AHB_HRDATA.hdl_path() == "hrdata";
     keep bind(AHB_HRDATA,external);
     keep soft AHB_HMASTLOCK.hdl_path() == "hmastlock";
     keep bind(AHB_HMASTLOCK,external);
     keep soft AHB_HMASTER.hdl_path() == "hmaster";
     keep bind(AHB_HMASTER,external);
     keep bind(AHB_HSPLIT, empty);               
     keep bind(AHB_HWRITE, external);
     keep bind(AHB_HSIZE, external);
     keep bind(AHB_HBURST, external);
     keep bind(AHB_HRESP, external);
};

extend AHB0 ahb_master_signal_map {
  keep soft agent() == "verilog";  
  -- Master specific signals
  keep soft AHB_HBUSREQ.hdl_path() == "hbusreq0";
  keep bind(AHB_HBUSREQ,external);
  keep soft AHB_HGRANT.hdl_path() == "hgrant0";
  keep bind(AHB_HGRANT,external);
  keep soft AHB_HLOCK.hdl_path() == "hlock0";
  keep bind(AHB_HLOCK,external);
  keep soft AHB_HTRANS_out.hdl_path() == "htrans0";
  keep bind(AHB_HTRANS_out,external);
  keep soft AHB_HADDR_out.hdl_path() == "haddr0";
  keep bind(AHB_HADDR_out,external);
  keep soft AHB_HWRITE_out.hdl_path() == "hwrite0";   
  keep soft AHB_HSIZE_out.hdl_path() == "hsize0";   
  keep soft AHB_HBURST_out.hdl_path() == "hburst0";  
  keep soft AHB_HPROT_out.hdl_path() == "hprot0";
  keep bind(AHB_HPROT_out,external);
  keep soft AHB_HWDATA_out.hdl_path() == "hwdata0";
  keep bind(AHB_HWDATA_out,external);           
  -- Global signals  
  keep soft AHB_HRESP.hdl_path() == "hresp"; 
  keep soft AHB_HREADY.hdl_path() == "hready";
  keep bind(AHB_HREADY,external);
  keep soft AHB_HRESET.hdl_path() == "hresetn";
  keep bind(AHB_HRESET,external);
  keep soft AHB_HCLK.hdl_path() == "specman_hclk";
  keep bind(AHB_HCLK,external);
  keep soft AHB_HRDATA.hdl_path() == "hrdata";
  keep bind(AHB_HRDATA,external);
                 
  keep bind(AHB_HWRITE_out, external);
  keep bind(AHB_HSIZE_out, external);
  keep bind(AHB_HBURST_out, external);
  keep bind(AHB_HRESP, external);
};

// S0 signals
extend AHB0 S0 ahb_slave_signal_map {

  keep soft agent() == "verilog";   
  -- Slave specific signals
  keep soft AHB_HSEL.hdl_path() == "hsel0";
  keep bind(AHB_HSEL,external);      -- Select signal(from decoder)
  keep soft AHB_HREADY_out.hdl_path() == "hready0";
  keep bind(AHB_HREADY_out,external);    -- Slave ready
  keep soft AHB_HRESP_out.hdl_path() == "hresp0"; --Slave Response
  keep soft AHB_HRDATA_out.hdl_path() == "hrdata0";
  keep bind(AHB_HRDATA_out,external);    -- Read data
          
  -- Global signals
  keep soft AHB_HADDR.hdl_path() == "haddr";
  keep bind(AHB_HADDR,external);    -- Address
  keep soft AHB_HWRITE.hdl_path() == "hwrite"; --direction
  keep soft AHB_HSIZE.hdl_path() == "hsize"; --transfer size
  keep soft AHB_HBURST.hdl_path() == "hburst"; --burst kind
  keep soft AHB_HTRANS.hdl_path() == "htrans";
  keep bind(AHB_HTRANS,external); -- Transfer kind
  keep soft AHB_HWDATA.hdl_path() == "hwdata";
  keep bind(AHB_HWDATA,external); -- Write data
  keep soft AHB_HRESET.hdl_path() == "hresetn";
  keep bind(AHB_HRESET,external); -- Reset
  keep soft AHB_HCLK.hdl_path() == "specman_hclk";
  keep bind(AHB_HCLK,external);       -- Clock
  keep soft AHB_HMASTLOCK.hdl_path() == "hmastlock";
  keep bind(AHB_HMASTLOCK,external);  -- Locked transfer
  keep soft AHB_HPROT.hdl_path() == "hprot";
  keep bind(AHB_HPROT,external);    -- Protec6.0i26_opttion control
  keep soft AHB_HREADY.hdl_path() == "hready";
  keep bind(AHB_HREADY,external); -- Bus ready

  --SPLIT signals
  keep soft AHB_HMASTER.hdl_path() == "hmaster";
  keep bind(AHB_HMASTER,external); -- Bus master
  keep bind(AHB_HSPLIT_out, empty);
    
  keep bind(AHB_HWRITE, external);
  keep bind(AHB_HSIZE, external);
  keep bind(AHB_HBURST, external);
  keep bind(AHB_HRESP_out, external);
--act_coverage extra HRESP signal
  when has_act_coverage vr_ahb_slave_signal_map {
    keep soft AHB_HRESP.hdl_path() == "hresp";
    keep bind(AHB_HRESP, external);
  };
};

// S1 signals
extend AHB0 S1 ahb_slave_signal_map {

  keep soft agent() == "verilog";   
  -- Slave specific signals
  keep soft AHB_HSEL.hdl_path() == "hsel1";
  keep bind(AHB_HSEL,external);      -- Select signal(from decoder)
  keep soft AHB_HREADY_out.hdl_path() == "hready1";
  keep bind(AHB_HREADY_out,external);    -- Slave ready
  keep soft AHB_HRESP_out.hdl_path() == "hresp1"; --Slave Response
  keep soft AHB_HRDATA_out.hdl_path() == "hrdata1";
  keep bind(AHB_HRDATA_out,external);    -- Read data
            
  -- Global signals
  keep soft AHB_HADDR.hdl_path() == "haddr";
  keep bind(AHB_HADDR,external);    -- Address
  keep soft AHB_HWRITE.hdl_path() == "hwrite"; --direction
  keep soft AHB_HSIZE.hdl_path() == "hsize"; --transfer size
  keep soft AHB_HBURST.hdl_path() == "hburst"; --burst kind
  keep soft AHB_HTRANS.hdl_path() == "htrans";
  keep bind(AHB_HTRANS,external); -- Transfer kind
  keep soft AHB_HWDATA.hdl_path() == "hwdata";
  keep bind(AHB_HWDATA,external); -- Write data
  keep soft AHB_HRESET.hdl_path() == "hresetn";
  keep bind(AHB_HRESET,external); -- Reset
  keep soft AHB_HCLK.hdl_path() == "specman_hclk";
  keep bind(AHB_HCLK,external);       -- Clock
  keep soft AHB_HMASTLOCK.hdl_path() == "hmastlock";
  keep bind(AHB_HMASTLOCK,external);  -- Locked transfer
  keep soft AHB_HPROT.hdl_path() == "hprot";
  keep bind(AHB_HPROT,external);    -- Protec6.0i26_opttion control
  keep soft AHB_HREADY.hdl_path() == "hready";
  keep bind(AHB_HREADY,external); -- Bus ready

  --SPLIT signals
  keep soft AHB_HMASTER.hdl_path() == "hmaster";
  keep bind(AHB_HMASTER,external); -- Bus master
  keep bind(AHB_HSPLIT_out, empty);
    
  keep bind(AHB_HWRITE, external);
  keep bind(AHB_HSIZE, external);
  keep bind(AHB_HBURST, external);
  keep bind(AHB_HRESP_out, external);
--act_coverage extra HRESP signal
  when has_act_coverage vr_ahb_slave_signal_map {
    keep soft AHB_HRESP.hdl_path() == "hresp";
    keep bind(AHB_HRESP, external);
  };
};

extend AHB0 ahb_arbiter_signal_map {
  keep soft AHB_HADDR.hdl_path() == "haddr";
  keep bind(AHB_HADDR,external); 
  keep soft AHB_HTRANS.hdl_path() == "htrans";
  keep bind(AHB_HTRANS,external); 
  keep soft AHB_HBURST.hdl_path() == "hburst"; --burst kind
  keep soft AHB_HRESP.hdl_path() == "hresp"; --slave response
  keep soft AHB_HREADY.hdl_path() == "hready";
  keep bind(AHB_HREADY,external); 
  keep soft AHB_HRESET.hdl_path() == "hresetn";
  keep bind(AHB_HRESET,external); 
  keep soft AHB_HCLK.hdl_path() == "specman_hclk";
  keep bind(AHB_HCLK,external); 
  keep soft AHB_HMASTLOCK.hdl_path() == "hmastlock";
  keep bind(AHB_HMASTLOCK,external); 
  keep soft AHB_HMASTER.hdl_path() == "hmaster";
  keep bind(AHB_HMASTER,external); -- Bus master
  keep bind(AHB_HSPLIT, empty);  
  keep bind(AHB_HBURST, external);
  keep bind(AHB_HRESP, external);
      
  keep for each in AHB_HGRANT {
    index == 0 => soft it.hdl_path() == "hgrant0";
  };

  keep for each in AHB_HBUSREQ {
    index == 0 => soft it.hdl_path() == "hbusreq0";
  }; 

  keep for each in AHB_HLOCK {
    index == 0 => soft it.hdl_path() == "hlock0";
  };

};

extend AHB0 ahb_decoder_signal_map {
  keep soft AHB_HCLK.hdl_path() == "specman_hclk";
  keep bind(AHB_HCLK,external); 
  keep soft AHB_HADDR.hdl_path() == "haddr";
  keep bind(AHB_HADDR,external); 
  keep soft AHB_HRDATA.hdl_path() == "hrdata";
  keep bind(AHB_HRDATA,external); 
  keep soft AHB_HTRANS.hdl_path() == "htrans";
  keep bind(AHB_HTRANS,external); 
    
  keep for each in AHB_HSEL {
    index == 0 => soft it.hdl_path() == "hsel0";
    index == 1 => soft it.hdl_path() == "hsel1";;
  };

// Default Slave signals
  keep soft AHB_HREADY.hdl_path() == "hready2";
  keep bind(AHB_HREADY,external);
  keep soft AHB_HRESP.hdl_path() == "hresp2"; --slave response 
  keep bind(AHB_DEFAULT_SLAVE_HSEL, undefined);
  keep bind(AHB_HREADY_out, undefined); 

  keep bind(AHB_HRESP, external);
};

-- -----------------------------------------------------------------------------
-- Enhancement to enable adding burst limitations
-- -----------------------------------------------------------------------------
#ifndef AHB_BURST_EVC_NAME {
  #define AHB_BURST_EVC_NAME;
  extend ahb_master_driven_burst {
    // Send burst only to existings slaves
    keep driver != NULL => soft slave_name in driver.p_master.config.all_slaves_name;
  }; 
};

-- -----------------------------------------------------------------------------
-- Limitations
-- -----------------------------------------------------------------------------

extend AHB0 ahb_master_driven_burst {
  keep soft kind in [SINGLE,INCR,WRAP4,INCR4,WRAP8,INCR8,WRAP16,INCR16];
  keep soft size in [BYTE,HALFWORD,WORD];
};

extend AHB0 ahb_slave_driven_burst_response {
  keep for each (tr) in transfers_responses {
    soft tr.responses.size() == 1;
    for each (t) in tr.responses {
      soft t.kind not in [RETRY,SPLIT];
    };
  };
};


#ifndef AHB_SLAVE_ACT_COVERAGE {
  #define AHB_SLAVE_ACT_COVERAGE;
  extend ahb_slave {
    keep soft has_act_coverage;
  }; 
};

'>  

