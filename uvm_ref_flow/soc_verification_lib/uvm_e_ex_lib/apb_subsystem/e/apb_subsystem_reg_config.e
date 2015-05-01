/*-------------------------------------------------------------------------
File name   : apb_subsystem_reg_config.e
Title       : vr_ad macro integration
Project     :
Created     : November 2010
Description : This file contains the vr_ad pacakage integration
              
Notes       : vr_ad integration
                            
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

extend ahb::ahb_master_seq_kind : [VR_AD_REG_SEQ_APBS];

extend ahb_master_seq_driver {

  apbs_reg_seq : VR_AD_REG_SEQ_APBS ahb::ahb_master_seq;
  keep apbs_reg_seq.driver == me;

  vr_ad_execute_op(op_item : vr_ad_operation) : list of byte @clock is {   

    var data_tow : list of ahb_data;
    data_tow.clear();
    data_tow.add(op_item.get_data().as_a(ahb_data));

    if op_item.direction == WRITE {
      if((op_item.address[1:0] !=  0)) {
        apbs_reg_seq.write(op_item.address,data_tow, SINGLE,BYTE);
      } else {
          apbs_reg_seq.write(op_item.address,data_tow, SINGLE,WORD);
      };
    } else {
      if((op_item.address[1:0] ==  0)) {
        result = pack(packing.low,apbs_reg_seq.read(op_item.address,SINGLE,WORD));   
      } else {
        result = pack(packing.low,apbs_reg_seq.read(op_item.address,SINGLE,BYTE));   
      };
    };
  };
};


extend has_vr_ad has_scbd apb_subsystem_monitor_u {

  reg_apb_subsystem_in: in interface_port of tlm_analysis of ahb_env_monitor_transfer 
                                                       using prefix=reg_ is instance;
  keep bind(reg_apb_subsystem_in, empty);

  !lmap_base_addr : vr_ad_addr_t; // Copy of the agent base address value

  reg_write(cur_transfer : ahb_env_monitor_transfer) is  {

    if((cur_transfer.direction in [READ,WRITE]) && (cur_transfer.kind != IDLE)) {
      var current_data : uint(bits : 32 ) = cur_transfer.data.as_a(uint);
      var current_addr : uint(bits : 32 ) = cur_transfer.address.as_a(uint);
      var valid_data : int (bits: 8);
      case current_addr[1:0] {
        0 : {valid_data = current_data[7:0]};
        1 : {valid_data = current_data[15:8]};
        2 : {valid_data = current_data[23:16]};
        3 : {valid_data = current_data[31:24]};
      };

      if (cur_transfer.direction == WRITE) {
        p_env.as_a(has_vr_ad apb_subsystem_env_u).p_addr_map.update(current_addr - lmap_base_addr,%{current_data},{});
      } else {
        if(((current_addr-lmap_base_addr)[31:16] == 0x0081) || 
	  ((current_addr-lmap_base_addr)[31:16] == 0x0088)) {
          compute p_env.as_a(has_vr_ad apb_subsystem_env_u).p_addr_map.fetch_and_compare(current_addr - 
           lmap_base_addr,%{valid_data});
        } else {
          compute p_env.as_a(has_vr_ad apb_subsystem_env_u).p_addr_map.fetch_and_compare(current_addr - 
           lmap_base_addr,%{current_data});
        };
      }; 
    }; // if..
  }; // reg_write()..
}; // extend has_vr_ad ..

'>

