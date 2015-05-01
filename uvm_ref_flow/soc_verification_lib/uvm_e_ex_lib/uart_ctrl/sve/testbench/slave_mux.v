/*---------------------------------------------------------------
File name   :  slave_mux.v

Title       :   

Project     :  Module UART

Developers  :  

Created     :  November 2010

Description : 

Notes       :  
---------------------------------------------------------------

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
 
---------------------------------------------------------------*/


`timescale 1ns/10ps

// ahb_verilog.v

`define AHB_DATA_WIDTH          32              // AHB bus data width [32/64]
`define AHB_ADDR_WIDTH          32              // AHB bus address width [32/64]
`define AHB_DATA_MAX_BIT        31              // MUST BE: AHB_DATA_WIDTH - 1
`define AHB_ADDRESS_MAX_BIT     31              // MUST BE: AHB_ADDR_WIDTH - 1


`define DEFAULT_HREADY_VALUE    1'b1                    // Ready Asserted
`define DEFAULT_HRESP_VALUE     2'b00                   // OKAY Response
`define DEFAULT_HRDATA_VALUE    {`AHB_DATA_WIDTH{1'b0}} // All zeros




module slave_mux(//output
           hready,hresp,hrdata,
           //input
           hready0,hready1,hready2,hready3,hready4, 
           hready5,hready6,hready7,hready8, 
           hready9,hready10,hready11,hready12, 
           hready13,hready14,hready15,
           hresp0,hresp1,hresp2,hresp3,hresp4,hresp5, 
           hresp6,hresp7,hresp8,hresp9,hresp10, 
           hresp11,hresp12,hresp13,hresp14,hresp15,
           hrdata0,hrdata1,hrdata2,hrdata3,hrdata4,hrdata5, 
           hrdata6,hrdata7,hrdata8,hrdata9,hrdata10, 
           hrdata11,hrdata12,hrdata13,hrdata14,hrdata15,
           hsel0,hsel1,hsel2,hsel3,hsel4,
           hsel5,hsel6,hsel7,hsel8,hsel9,
           hsel10,hsel11,hsel12,hsel13,hsel14,hsel15,specman_hclk,hresetn );

   
        
   // AHB Slave Pre-Multiplexed Signals

  input  hready0 , hready1 , hready2 , hready3 ;
  input  hready4 , hready5 , hready6 , hready7 ;
  input  hready8 , hready9 , hready10, hready11;   
  input  hready12, hready13, hready14, hready15;

  input  [1:0] hresp0 , hresp1 , hresp2 , hresp3 ;
  input  [1:0] hresp4 , hresp5 , hresp6 , hresp7 ;
  input  [1:0] hresp8 , hresp9 , hresp10, hresp11;   
  input  [1:0] hresp12, hresp13, hresp14, hresp15;
  
  input  [`AHB_DATA_MAX_BIT:0] hrdata0 , hrdata1 , hrdata2 , hrdata3 ;
  input  [`AHB_DATA_MAX_BIT:0] hrdata4 , hrdata5 , hrdata6 , hrdata7 ;
  input  [`AHB_DATA_MAX_BIT:0] hrdata8 , hrdata9 , hrdata10, hrdata11;   
  input  [`AHB_DATA_MAX_BIT:0] hrdata12, hrdata13, hrdata14, hrdata15;

  //input  [15:0]  sel_reg;

  input hsel0 , hsel1 , hsel2 , hsel3;
  input hsel4 , hsel5 , hsel6 , hsel7;
  input hsel8 , hsel9 , hsel10 , hsel11;
  input hsel12 , hsel13 , hsel14 , hsel15;
 
  input specman_hclk;
  input hresetn;

  output       hready; 
  output [1:0] hresp;
  output [`AHB_DATA_MAX_BIT:0] hrdata;


  wire   hready0 , hready1 , hready2 , hready3 ;
  wire   hready4 , hready5 , hready6 , hready7 ;
  wire   hready8 , hready9 , hready10, hready11;   
  wire   hready12, hready13, hready14, hready15;

  wire   [1:0] hresp0 , hresp1 , hresp2 , hresp3 ;
  wire   [1:0] hresp4 , hresp5 , hresp6 , hresp7 ;
  wire   [1:0] hresp8 , hresp9 , hresp10, hresp11;   
  wire   [1:0] hresp12, hresp13, hresp14, hresp15;
  
  wire   [`AHB_DATA_MAX_BIT:0] hrdata0 , hrdata1 , hrdata2 , hrdata3 ;
  wire   [`AHB_DATA_MAX_BIT:0] hrdata4 , hrdata5 , hrdata6 , hrdata7 ;
  wire   [`AHB_DATA_MAX_BIT:0] hrdata8 , hrdata9 , hrdata10, hrdata11;   
  wire   [`AHB_DATA_MAX_BIT:0] hrdata12, hrdata13, hrdata14, hrdata15;

  wire   specman_hclk;
  wire   hresetn;
  
  reg       hready;
  reg [1:0] hresp; 
  reg [`AHB_DATA_MAX_BIT:0]  hrdata;

  reg [15:0] sel_reg;

  
  always @ ( posedge specman_hclk )
    begin : DATA_MUX_CONTROL
      
      if ( hresetn == 1'b0 )
      begin
        sel_reg     <= 16'h0000;
      end // if ( !hreset_n )
     else
      if ( hready == 1'b1 )
      begin
	sel_reg <= { hsel15, hsel14, hsel13, hsel12,
                     hsel11, hsel10, hsel9,  hsel8,
                     hsel7,  hsel6,  hsel5,  hsel4,
                     hsel3,  hsel2,  hsel1,  hsel0 };
      end // if ( hready )
    end // block: DATA_MUX_CONTROL



 // Slave response multiplexor
  
  always @ ( hready0  or hready1  or hready2  or hready3  or
	     hready4  or hready5  or hready6  or hready7  or
	     hready8  or hready9  or hready10 or hready11 or
	     hready12 or hready13 or hready14 or hready15 or

	     hresp0  or hresp1  or hresp2  or hresp3  or
	     hresp4  or hresp5  or hresp6  or hresp7  or
	     hresp8  or hresp9  or hresp10 or hresp11 or
	     hresp12 or hresp13 or hresp14 or hresp15 or

	     hrdata0  or hrdata1  or hrdata2  or hrdata3  or
	     hrdata4  or hrdata5  or hrdata6  or hrdata7  or
	     hrdata8  or hrdata9  or hrdata10 or hrdata11 or
	     hrdata12 or hrdata13 or hrdata14 or hrdata15 or
	     
             sel_reg )
    
  begin : SLAVE_RESPONSE_MUX
	
    case ( sel_reg )
      
      16'h8000 : begin
	
	hready <= hready15; 
	hresp  <= hresp15;
	hrdata <= hrdata15;

      end // case: 16'h8000
      
      16'h4000 : begin
	
	hready <= hready14;
	hresp  <= hresp14;
     	hrdata <= hrdata14;

      end // case: 16'h4000
      
      16'h2000 : begin
	
	hready <= hready13;
	hresp  <= hresp13;
      	hrdata <= hrdata13;

      end // case: 16'h2000
      
      16'h1000 : begin
	
	hready <= hready12;
	hresp  <= hresp12;
      	hrdata <= hrdata12;

      end // case: 16'h1000
      
      16'h0800 : begin 
	
	hready <= hready11;
	hresp  <= hresp11;
      	hrdata <= hrdata11;

      end // case: 16'h0800
      
      16'h0400 : begin
	
	hready <= hready10;
	hresp  <= hresp10;
	hrdata <= hrdata10;

      end // case: 16'h0400
      
      16'h0200 : begin
	
	hready <= hready9;
	hresp  <= hresp9;
      	hrdata <= hrdata9;

      end // case: 16'h0200
      
      16'h0100 : begin
	
	hready <= hready8;
	hresp  <= hresp8;
	hrdata <= hrdata8;

      end // case: 16'h0100
      
      16'h0080 : begin
	
	hready <= hready7;
	hresp  <= hresp7;
	hrdata <= hrdata7;

      end // case: 16'h0080
      
      16'h0040 : begin
	
	hready <= hready6;
	hresp  <= hresp6;
	hrdata <= hrdata6;

      end // case: 16'h0040
      
      16'h0020 : begin 
	
	hready <= hready5;
	hresp  <= hresp5;
	hrdata <= hrdata5;
      
      end // case: 16'h0020
      
      16'h0010 : begin

	hready <= hready4;
	hresp  <= hresp4;
	hrdata <= hrdata4;

      end // case: 16'h0010
      
      16'h0008 : begin 
	
	hready <= hready3;
	hresp  <= hresp3;
	hrdata <= hrdata3;
	
      end // case: 16'h0008
      
      16'h0004 : begin

	hready <= hready2;
	hresp  <= hresp2;
	hrdata <= hrdata2;
	
      end // case: 16'h0004
      
      16'h0002 : begin 
	
	hready <= hready1;
	hresp  <= hresp1;
	hrdata <= hrdata1;

      end // case: 16'h0002
      
      16'h0001 : begin
	
	hready <= hready0;
	hresp  <= hresp0;
     	hrdata <= hrdata0;

      end // case: 16'h0001
      
      default  : begin
	
	hready <= `DEFAULT_HREADY_VALUE;
	hresp  <= `DEFAULT_HRESP_VALUE;
	hrdata <= `DEFAULT_HRDATA_VALUE;
	
      end // case: default
      
    endcase // case( sel_reg )
  end // block: RESPONSE_MUX
endmodule
