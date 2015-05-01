-------------------------------------------------------------------------
-- File name   : tb_mirror.vhd
-- Title       : 
-- Project     : APB subsystem
-- Created     : November 2010
-- Description : Signal to link the Power Control Module
-- 
-- Notes       : 
-------------------------------------------------------------------------*/
--   Copyright 1999-2010 Cadence Design Systems, Inc.
--   All Rights Reserved Worldwide
--
--   Licensed under the Apache License, Version 2.0 (the
--   "License"); you may not use this file except in
--   compliance with the License.  You may obtain a copy of
--   the License at
--
--   http://www.apache.org/licenses/LICENSE-2.0
--
--   Unless required by applicable law or agreed to in
--   writing, software distributed under the License is
--   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
--   CONDITIONS OF ANY KIND, either express or implied.  See
--   the License for the specific language governing
--   permissions and limitations under the License.
------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

--Following library required when using nc_mirror

library ncutils;    		 
use ncutils.ncutilities.all;

entity tb_mirror_e is
end tb_mirror_e;

architecture tb_mirror_a of tb_mirror_e is

begin -- architecture

nc_mirror_process:process begin

     nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:L1_ctrl_access",
                destination => "tb_apb_subsystem.L1_ctrl_access",
                verbose =>"verbose"
      );

     nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:L1_status_access",
                destination => "tb_apb_subsystem.L1_status_access",
                verbose =>"verbose"
      );

     nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:L1_ctrl_reg",
                destination => "tb_apb_subsystem.L1_ctrl_reg",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:L1_status_reg",
                destination => "tb_apb_subsystem.L1_ctrl_reg",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:rstn_non_srpg_smc",
                destination => "tb_apb_subsystem.rstn_non_srpg_smc",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:isolate_smc",
                destination => "tb_apb_subsystem.isolate_smc",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:retain_smc",
                destination => "tb_apb_subsystem.retain_smc",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:gate_clk_smc",
                destination => "tb_apb_subsystem.gate_clk_smc",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:pwr1_on_smc",
                destination => "tb_apb_subsystem.pwr1_on_smc",
                verbose =>"verbose"
      );

	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:rstn_non_srpg_urt",
                destination => "tb_apb_subsystem.rstn_non_srpg_urt",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:isolate_urt",
                destination => "tb_apb_subsystem.isolate_urt",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:retain_urt",
                destination => "tb_apb_subsystem.retain_urt",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:gate_clk_urt",
                destination => "tb_apb_subsystem.gate_clk_urt",
                verbose =>"verbose"
      );
    
	 nc_mirror( source => "tb_apb_subsystem.i_apb_subsystem.i_power_ctrl_veneer.i_power_ctrl:pwr1_on_urt",
                destination => "tb_apb_subsystem.pwr1_on_urt",
                verbose =>"verbose"
      );

    wait ; --wait  must for nc_mirror

end process nc_mirror_process;

end tb_mirror_a; -- end architecture

