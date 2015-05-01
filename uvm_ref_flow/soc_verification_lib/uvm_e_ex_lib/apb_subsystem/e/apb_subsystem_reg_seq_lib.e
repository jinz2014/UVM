/*-------------------------------------------------------------------------
File name   : apb_subsystem_reg_seq_lib.e
Title       : Sequence library 
Project     :
Created     : November 2010
Description : This file contains the library of sequence for SPI registers
              using vr_ad relevant to UART

Notes       : Library of vr_ad sequence
                            
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

// SPI Configuration Sequence using vr_ad Sequence
extend vr_ad_sequence_kind : [SPI_CONFIG];

extend SPI_CONFIG'kind vr_ad_sequence {

  !ctrl_reg  : SPI_CONTROL_REGISTER  vr_ad_reg;
  !div_reg   : SPI_DIVISOR_REGISTER  vr_ad_reg;
  !slv_reg   : SPI_SLAVESEL_REGISTER vr_ad_reg;

  !p_vr_ad_seq_dri : vr_ad_sequence_driver; 

  CHARLEN : uint(bits :7);
  keep soft CHARLEN == 7'b0001000;

  BUSY : uint(bits :1);
  keep soft BUSY == 1'b0;

  NEG: uint(bits :1);
  keep soft NEG== 1'b1;

  LSB: uint(bits :1);
  keep soft LSB== 1'b0;

  IE: uint(bits :1);
  keep soft IE== 1'b1;

  ASS : uint(bits : 1) ;
  keep soft ASS == 0;

  DIV : uint(bits : 32) ;
  keep soft DIV == 1;

  SS : uint(bits : 32) ;
  keep soft SS == 0xf;

  body() @driver.clock is only {

    // Writing into the SPI Register's

    write_reg  ctrl_reg { 
      it.charlen   == CHARLEN ;
      it.busy      == BUSY ;
      it.rxneg     == NEG; 
      it.txneg     == NEG; 
      it.lsb       == LSB;
      it.ie        == IE ;
      it.ass       == ASS;
      it.rsvd1     == 1'b0;
      it.rsvd      == 18'b0;
    };             


    write_reg div_reg value DIV ;
    write_reg slv_reg value SS  ;

  }; //body()..
}; // extend SPI_CONFIG..




'>
