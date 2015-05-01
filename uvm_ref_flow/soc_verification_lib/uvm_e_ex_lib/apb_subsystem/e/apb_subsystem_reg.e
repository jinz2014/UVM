/*-------------------------------------------------------------------------
File name   : apb_subsystem_reg.e
Title       : SPI Register File
Project     :
Created     : November 2010
Description : This file contains the registers for SPI
              
Notes       : SPI register declartion with vr_ad macro 
                            
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

// SPI Register File
extend vr_ad_reg_file_kind : [SPI_CORE];

extend SPI_CORE vr_ad_reg_file {
  
  keep addressing_width_in_bytes == 4;
  keep size == 32'h0000_0100;
  keep packing_mode == packing.low;
  
  run() is {
    reset();
  };

};

// ------------------------------------------------------------
//
// DUT Shadow Register Definations
//
// reg_def <register_name> <reg_file name> <address> {
//   reg_fld <field_name> : <size> : <attribute> : <default_value>
// };
//
// -------------------------------------------------------------

reg_def  SPI_CONTROL_REGISTER   SPI_CORE   0x0000_0010 { 
  reg_fld charlen   : uint(bits:7)  : RW : 0;
  reg_fld rsvd1     : uint(bits:1)  : RW : 0;
  reg_fld busy      : uint(bits:1)  : RW : 0;
  reg_fld rxneg     : uint(bits:1)  : RW : 0;
  reg_fld txneg     : uint(bits:1)  : RW : 0;
  reg_fld lsb       : uint(bits:1)  : RW : 0;
  reg_fld ie        : uint(bits:1)  : RW : 0;
  reg_fld ass       : uint(bits:1)  : RW : 0;
  reg_fld rsvd      : uint(bits:18) : R  : 0;
};

reg_def  SPI_DIVISOR_REGISTER     SPI_CORE   0x0000_0014 { 
  reg_fld divisor   : uint(bits:16) : RW : 0 : cov;
  reg_fld rsvd      : uint(bits:16) : R  : 0 ;
};


reg_def  SPI_SLAVESEL_REGISTER     SPI_CORE   0x0000_0018 { 
  reg_fld slavesel  : uint(bits:8)  : RW : 0;
  reg_fld rsvd      : uint(bits:24) : R  : 0;
};


'>

