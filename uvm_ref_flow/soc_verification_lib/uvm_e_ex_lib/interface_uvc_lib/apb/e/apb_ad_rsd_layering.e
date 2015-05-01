/*-------------------------------------------------------------------------
File name   : apb_ad_rsd_layering.e
Title       : vr_ad_execute method implementation
Project     : APB UVC
Developers  : 
Created     : 14 Feb 2008

Description : This file contains the method for vr_ad implementation

Notes       : The implemention of vr_ad_execute_op method which maps 
              vr_ad_operation to APB protocol

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
-------------------------------------------------------------------------*/

<'

package apb;

// ------------------------------------------------------------------
// Implementation of the vr_ad_execute_op() method in the BFM driver.
// This maps the vr_ad operation to the APB protocol.
// ------------------------------------------------------------------
extend apb_master_driver_u {
    
  vr_ad_execute_op(op_item : vr_ad_operation) : list of byte  @clock is {
    if op_item.direction == WRITE {
      var lu : list of apb_data_t = pack(packing.low, op_item.get_lob_data());
      sequence.write(op_item.address,lu);
    } else {
      var size : uint = op_item.get_num_of_bytes()/(SHR_APB_DATA_WIDTH/8);
      result = pack(packing.low,sequence.read(op_item.address,size));
    };
  }; // vr_ad_execute_op()..
};

'>
