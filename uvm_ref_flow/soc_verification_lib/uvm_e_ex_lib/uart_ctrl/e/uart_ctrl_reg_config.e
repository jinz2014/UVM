/*-------------------------------------------------------------------------
File name   : uart_ctrl_reg_config.e
Title       : vr_ad macro integration
Project     : Module UART
Developers  : 
Created     :
Description : This file contains the vr_ad pacakage integration 

Notes       : vr_ad integration
            :
-------------------------------------------------------------------------*/
//  Copyright 1999-2010 Cadence Design Systems, Inc.
//  All Rights Reserved Worldwide
// 
//  Licensed under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in
//  compliance with the License.  You may obtain a copy of
//  the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in
//  writing, software distributed under the License is
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//  CONDITIONS OF ANY KIND, either express or implied.  See
//  the License for the specific language governing
//  permissions and limitations under the License.
// ----------------------------------------------------------------------


<'

package uart_ctrl_pkg;

extend apb::apb_master_sequence_kind_t : [VR_AD_REG_SEQ_UARTAPB];
extend apb_master_driver_u {

  reg_seq : VR_AD_REG_SEQ_UARTAPB apb::apb_master_sequence;
  keep reg_seq.driver == me;

  vr_ad_execute_op(op_item : vr_ad_operation) : list of byte @clock is {   

    var data : uint (bits :32);  
    if op_item.direction == WRITE {
      case op_item.address[1:0] {
        0 : {data = pack(packing.high,24'b0,op_item.get_data())};
        1 : {data = pack(packing.high,16'b0,op_item.get_data(),8'b0)};
        2 : {data = pack(packing.high,8'b0,op_item.get_data(),16'b0)};
        3 : {data = pack(packing.high,op_item.get_data(),24'b0)};
      };
      reg_seq.write(op_item.address, data);
    } else {
      result = pack(packing.low,reg_seq.read(op_item.address));   
    };
  };
};

extend has_vr_ad has_scbd uart_ctrl_monitor_u {

  reg_uart_ctrl_in  : in interface_port of tlm_analysis of apb_trans_s using prefix=reg_ is instance;
  keep bind(reg_uart_ctrl_in  , empty);

  !lmap_base_addr : vr_ad_addr_t; // Base address

  reg_write(cur_transfer : apb_trans_s) is  {

    if((cur_transfer.direction in [READ,WRITE])) {
      var current_data : apb_data_t = cur_transfer.data;
      var current_addr : apb_addr_t = cur_transfer.addr;
      var valid_data : int (bits: 8);
      case current_addr[1:0] {
        0 : {valid_data = current_data[7:0]};
        1 : {valid_data = current_data[15:8]};
        2 : {valid_data = current_data[23:16]};
        3 : {valid_data = current_data[31:24]};
      };
      if (cur_transfer.direction == WRITE) {
        p_env.as_a(has_vr_ad uart_ctrl_env_u).p_addr_map.update(current_addr - lmap_base_addr,%{valid_data},{});
      } else {
        compute p_env.as_a(has_vr_ad uart_ctrl_env_u).p_addr_map.fetch_and_compare(current_addr - 
        lmap_base_addr,%{valid_data});
      }; 
    };
  };
};

'>





 

 


   



