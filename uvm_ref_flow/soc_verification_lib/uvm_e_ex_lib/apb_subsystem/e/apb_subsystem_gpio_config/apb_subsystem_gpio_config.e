/*-------------------------------------------------------------------------
File name   : apb_subsystem_gpio_config.e  
Title       : GPIO UVC configuration
Project     :
Created     : November 2010
Description : This file contains the configuration of the GPIO UVC

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

// Importing the GPIO top file
import gpio/e/gpio_top;

extend  gpio_env {
    keep soft smp.sig_clk.hdl_path() == "specman_hclk";
    keep soft smp.sig_reset.hdl_path() == "hresetn";
};


extend  gpio_env {
  keep soft smp.sig_data_oe.hdl_path()  == "n_gpio_pin_oe";
  keep soft smp.sig_data_out.hdl_path() == "gpio_pin_in";
  keep soft smp.sig_data_in.hdl_path()  == "gpio_pin_out";
};

'>
