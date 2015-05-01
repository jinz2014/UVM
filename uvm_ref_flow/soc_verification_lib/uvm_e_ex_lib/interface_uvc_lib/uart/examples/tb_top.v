/*-----------------------------------------------------------------
File name     : tb_top.v
Title         : uart tb top file
Project       :
Created       : Wed Feb 18 10:46:07 2004
Description   : 
Notes         : 
-------------------------------------------------------------------*/
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
//----------------------------------------------------------------------

`timescale 1ns/10ps


module tb_uart;

   // clock and reset
   reg specman_hclk;
   reg hresetn;

   reg rxd;
   reg txd;

   reg rts_n;
   reg cts_n;

   
   initial
     begin
	// Simulation Clock Initialization
	specman_hclk = 0;

	// Reset Initialization
	hresetn = 1;
	#100 hresetn = 0;
	#500 hresetn = 1;
     end  

   always #50 specman_hclk = ~specman_hclk;

endmodule
