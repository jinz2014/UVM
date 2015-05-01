/*-------------------------------------------------------------------------
File name   : apb_subsystem_spi_config.e  
Title       : SPI UVC configuration
Project     :
Created     : November 2010
Description : This file contains the configuration of the SPI UVC

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

// Importing the SPI top file
import spi/e/spi_top;

// SPI environment name
extend spi_env_name_t: [APBS_ENV_MASTER,APBS_ENV_SLAVE];

// getting the clock connections right
extend  APBS_ENV_MASTER spi_env_u {
  event clk_e is only cycle @sys.any;
};

extend  APBS_ENV_SLAVE spi_env_u {
  event clk_e is only cycle @sys.any;
};

extend spi_item_s {

  keep soft op_mode        == PIN3;
  keep soft clock_polarity == NEGEDGE;
  keep soft clock_phase    != ALIGNED;
  
  keep soft data_out.size() == 8;
  keep soft driving_mode == SLAVE;

  read_write_n_bl : bool;
  keep soft read_write_n_bl == TRUE;
   
};

extend  spi_agent_config_s {
  keep soft half_clock_period == 4000000 fs;
};

extend spi_agent_u {
  keep soft active_passive == ACTIVE;
};

extend spi_sequence {
  keep my_agent == read_only(driver.my_agent);
};


extend APBS_ENV_MASTER  spi_agent_u {

  keep soft spi_cs_p.hdl_path() == "n_ss_in";
  keep bind(spi_cs_p,external);

  keep soft clk_p.hdl_path() == "sclk_in";
  keep bind(clk_p,external);

  keep soft spi_simo_p.hdl_path() == "si";
  keep bind(spi_simo_p,external);

  keep soft spi_somi_p.hdl_path() == "so";
  keep bind(spi_somi_p,external);
  keep soft spi_cs_p.declared_range() == "[3:0]";

}; // extend APBS_ENV_MASTER...

extend APBS_ENV_SLAVE  spi_agent_u {

  keep soft spi_cs_p.hdl_path() == "n_ss_out";
  keep bind(spi_cs_p,external);

  keep soft clk_p.hdl_path() == "sclk_out";
  keep bind(clk_p,external);

  keep soft spi_simo_p.hdl_path() == "mo";
  keep bind(spi_simo_p,external);
  
  keep soft spi_somi_p.hdl_path() == "mi";
  keep bind(spi_somi_p,external);
  keep soft spi_cs_p.declared_range() == "[3:0]";

}; // extend APBS_ENV_SLAVE...

extend spi_bfm_u {

  spi_write_in: out interface_port of tlm_analysis of spi_item_s is instance;
  keep bind(spi_write_in, empty);

  spi_read_in: out interface_port of tlm_analysis of spi_item_s is instance;
  keep bind(spi_read_in, empty);

  receive_data(data : spi_item_s) @sample_clock_ev is also  {
    if (my_agent.spi_cs_p$ == 0x0) {
      data.read_write_n_bl = TRUE;
      spi_write_in$.write(data);
    };
  }; //receive_data()..

  drive_data(data : spi_item_s) @drive_clock_ev is also  {
    if (my_agent.spi_cs_p$ == 0x0) {
      data.read_write_n_bl = FALSE;
      spi_read_in$.write(data);
    };
  }; //drive_data()..
}; // extend spi_bfm_u..
'>

