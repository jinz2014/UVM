/*---------------------------------------------------------------
File name   :  master_mux.v

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

`define AHB_DATA_WIDTH          32              // AHB bus data width [32/64]
`define AHB_ADDR_WIDTH          32              // AHB bus address width [32/64]
`define AHB_DATA_MAX_BIT        31              // MUST BE: AHB_DATA_WIDTH - 1
`define AHB_ADDRESS_MAX_BIT     31              // MUST BE: AHB_ADDR_WIDTH - 1


`define DEFAULT_HWDATA_VALUE    {`AHB_DATA_WIDTH{1'b0}} // All zeros
`define DEFAULT_HADDR_VALUE     {`AHB_ADDR_WIDTH{1'b0}} // All zeros
`define DEFAULT_HTRANS_VALUE    2'b00                  // IDLE
`define DEFAULT_HWRITE_VALUE    1'b0                    // READ
`define DEFAULT_HBURST_VALUE    3'b000                  // SINGLE
`define DEFAULT_HSIZE_VALUE     3'b010                  // WORD
`define DEFAULT_HPROT_VALUE     4'b0011                 // NON_CACHE, NON_BUFFERABLE, PRIVALIGED, DATA


module master_mux(//Input
                  haddr0  , haddr1  , haddr2  , haddr3  ,
	          haddr4  , haddr5  , haddr6  , haddr7  ,
	          haddr8  , haddr9  , haddr10 , haddr11 ,   
	          haddr12 , haddr13 , haddr14 , haddr15 ,
  
	          htrans0  , htrans1  , htrans2  , htrans3  ,
	          htrans4  , htrans5  , htrans6  , htrans7  ,
	          htrans8  , htrans9  , htrans10 , htrans11 ,   
	          htrans12 , htrans13 , htrans14 , htrans15 ,
	     
	          hwrite0  , hwrite1  , hwrite2  , hwrite3  ,
	          hwrite4  , hwrite5  , hwrite6  , hwrite7  ,
	          hwrite8  , hwrite9  , hwrite10 , hwrite11 ,   
	          hwrite12 , hwrite13 , hwrite14 , hwrite15 ,
	     
	          hburst0  , hburst1  , hburst2  , hburst3  ,
	          hburst4  , hburst5  , hburst6  , hburst7  ,
	          hburst8  , hburst9  , hburst10 , hburst11 ,   
	          hburst12 , hburst13 , hburst14 , hburst15 ,
	     
	          hsize0  , hsize1  , hsize2  , hsize3  ,
	          hsize4  , hsize5  , hsize6  , hsize7  ,
	          hsize8  , hsize9  , hsize10 , hsize11 ,   
	          hsize12 , hsize13 , hsize14 , hsize15 ,
	     
	          hprot0  , hprot1  , hprot2  , hprot3  ,
	          hprot4  , hprot5  , hprot6  , hprot7  ,
	          hprot8  , hprot9  , hprot10 , hprot11 ,   
	          hprot12 , hprot13 , hprot14 , hprot15 ,

	          hmaster,  
                  
                  hwdata0  , hwdata1  , hwdata2  , hwdata3  ,
	          hwdata4  , hwdata5  , hwdata6  , hwdata7  ,
	          hwdata8  , hwdata9  , hwdata10 , hwdata11 ,
	          hwdata12 , hwdata13 , hwdata14 , hwdata15 ,
                
                  specman_hclk, hresetn, hready,
                  
                  //Output
                  haddr , htrans , hwrite , hburst ,
                  hsize , hprot  ,hwdata);

 


input [`AHB_ADDRESS_MAX_BIT : 0]    haddr0  , haddr1  , haddr2  , haddr3;
input [`AHB_ADDRESS_MAX_BIT : 0]    haddr4  , haddr5  , haddr6  , haddr7;
input [`AHB_ADDRESS_MAX_BIT : 0]    haddr8  , haddr9  , haddr10 , haddr11;   
input [`AHB_ADDRESS_MAX_BIT : 0]    haddr12 , haddr13 , haddr14 , haddr15;
  
input [1:0]	  htrans0  , htrans1  , htrans2  , htrans3;
input [1:0]	  htrans4  , htrans5  , htrans6  , htrans7;
input [1:0]	  htrans8  , htrans9  , htrans10 , htrans11;   
input [1:0]	  htrans12 , htrans13 , htrans14 , htrans15;
	     
input	          hwrite0  , hwrite1  , hwrite2  , hwrite3;
input	          hwrite4  , hwrite5  , hwrite6  , hwrite7;
input	          hwrite8  , hwrite9  , hwrite10 , hwrite11;   
input	          hwrite12 , hwrite13 , hwrite14 , hwrite15;
	     
input [2:0]	  hburst0  , hburst1  , hburst2  , hburst3;
input [2:0]	  hburst4  , hburst5  , hburst6  , hburst7;
input [2:0]	  hburst8  , hburst9  , hburst10 , hburst11;   
input [2:0]        hburst12 , hburst13 , hburst14 , hburst15;
	     
input [2:0]        hsize0  , hsize1  , hsize2  , hsize3;
input [2:0]	  hsize4  , hsize5  , hsize6  , hsize7;
input [2:0]	  hsize8  , hsize9  , hsize10 , hsize11;   
input [2:0]	  hsize12 , hsize13 , hsize14 , hsize15;
	     
input [3:0]        hprot0  , hprot1  , hprot2  , hprot3;
input [3:0]        hprot4  , hprot5  , hprot6  , hprot7;
input [3:0]        hprot8  , hprot9  , hprot10 , hprot11;   
input [3:0]        hprot12 , hprot13 , hprot14 , hprot15;

input [3:0]        hmaster;
                  
input [`AHB_DATA_MAX_BIT : 0]  hwdata0  , hwdata1  , hwdata2  , hwdata3;
input [`AHB_DATA_MAX_BIT : 0]  hwdata4  , hwdata5  , hwdata6  , hwdata7;
input [`AHB_DATA_MAX_BIT : 0]  hwdata8  , hwdata9  , hwdata10 , hwdata11;
input [`AHB_DATA_MAX_BIT : 0]  hwdata12 , hwdata13 , hwdata14 , hwdata15;
                
input              specman_hclk;
input              hresetn;
input              hready;

output [`AHB_ADDRESS_MAX_BIT : 0] haddr; 
output [1:0]                      htrans;
output                            hwrite;
output [2:0]                      hburst;
output [2:0]                      hsize; 
output [3:0]                      hprot; 
output [`AHB_DATA_MAX_BIT : 0]    hwdata;




wire [`AHB_ADDRESS_MAX_BIT : 0]    haddr0  , haddr1  , haddr2  , haddr3;
wire [`AHB_ADDRESS_MAX_BIT : 0]    haddr4  , haddr5  , haddr6  , haddr7;
wire [`AHB_ADDRESS_MAX_BIT : 0]    haddr8  , haddr9  , haddr10 , haddr11;   
wire [`AHB_ADDRESS_MAX_BIT : 0]    haddr12 , haddr13 , haddr14 , haddr15;
  
wire [1:0]	  htrans0  , htrans1  , htrans2  , htrans3;
wire [1:0]	  htrans4  , htrans5  , htrans6  , htrans7;
wire [1:0]	  htrans8  , htrans9  , htrans10 , htrans11;   
wire [1:0]	  htrans12 , htrans13 , htrans14 , htrans15;
	     
wire	          hwrite0  , hwrite1  , hwrite2  , hwrite3;
wire	          hwrite4  , hwrite5  , hwrite6  , hwrite7;
wire	          hwrite8  , hwrite9  , hwrite10 , hwrite11;   
wire	          hwrite12 , hwrite13 , hwrite14 , hwrite15;
	     
wire [2:0]	  hburst0  , hburst1  , hburst2  , hburst3;
wire [2:0]	  hburst4  , hburst5  , hburst6  , hburst7;
wire [2:0]	  hburst8  , hburst9  , hburst10 , hburst11;   
wire [2:0]        hburst12 , hburst13 , hburst14 , hburst15;
	     
wire [2:0]        hsize0  , hsize1  , hsize2  , hsize3;
wire [2:0]	  hsize4  , hsize5  , hsize6  , hsize7;
wire [2:0]	  hsize8  , hsize9  , hsize10 , hsize11;   
wire [2:0]	  hsize12 , hsize13 , hsize14 , hsize15;
	     
wire [3:0]        hprot0  , hprot1  , hprot2  , hprot3;
wire [3:0]        hprot4  , hprot5  , hprot6  , hprot7;
wire [3:0]        hprot8  , hprot9  , hprot10 , hprot11;   
wire [3:0]        hprot12 , hprot13 , hprot14 , hprot15;

wire [3:0]        hmaster;
                  
wire [`AHB_DATA_MAX_BIT : 0]  hwdata0  , hwdata1  , hwdata2  , hwdata3;
wire [`AHB_DATA_MAX_BIT : 0]  hwdata4  , hwdata5  , hwdata6  , hwdata7;
wire [`AHB_DATA_MAX_BIT : 0]  hwdata8  , hwdata9  , hwdata10 , hwdata11;
wire [`AHB_DATA_MAX_BIT : 0]  hwdata12 , hwdata13 , hwdata14 , hwdata15;
                
wire              specman_hclk;
wire              hresetn;
wire              hready;


reg [`AHB_ADDRESS_MAX_BIT : 0] haddr; 
reg [1:0]                      htrans;
reg                            hwrite;
reg [2:0]                      hburst;
reg [2:0]                      hsize; 
reg [3:0]                      hprot; 
reg [`AHB_DATA_MAX_BIT : 0]    hwdata;

reg [3:0] hmaster_dly; 




  always @ ( posedge specman_hclk )
  begin : MASTER_DATA_MUX_CONTROL
      
    if ( !hresetn )
    begin
      hmaster_dly <= 4'h0;
    end // if ( !hresetn )
    else
      if ( hready )
      begin
	hmaster_dly <= hmaster;
      end // if ( hready )
  end // block: DATA_MUX_CONTROL



  always @ ( haddr0  or haddr1  or haddr2  or haddr3  or
	     haddr4  or haddr5  or haddr6  or haddr7  or
	     haddr8  or haddr9  or haddr10 or haddr11 or   
	     haddr12 or haddr13 or haddr14 or haddr15 or
  
	     htrans0  or htrans1  or htrans2  or htrans3  or
	     htrans4  or htrans5  or htrans6  or htrans7  or
	     htrans8  or htrans9  or htrans10 or htrans11 or   
	     htrans12 or htrans13 or htrans14 or htrans15 or
	     
	     hwrite0  or hwrite1  or hwrite2  or hwrite3  or
	     hwrite4  or hwrite5  or hwrite6  or hwrite7  or
	     hwrite8  or hwrite9  or hwrite10 or hwrite11 or   
	     hwrite12 or hwrite13 or hwrite14 or hwrite15 or
	     
	     hburst0  or hburst1  or hburst2  or hburst3  or
	     hburst4  or hburst5  or hburst6  or hburst7  or
	     hburst8  or hburst9  or hburst10 or hburst11 or   
	     hburst12 or hburst13 or hburst14 or hburst15 or
	     
	     hsize0  or hsize1  or hsize2  or hsize3  or
	     hsize4  or hsize5  or hsize6  or hsize7  or
	     hsize8  or hsize9  or hsize10 or hsize11 or   
	     hsize12 or hsize13 or hsize14 or hsize15 or
	     
	     hprot0  or hprot1  or hprot2  or hprot3  or
	     hprot4  or hprot5  or hprot6  or hprot7  or
	     hprot8  or hprot9  or hprot10 or hprot11 or   
	     hprot12 or hprot13 or hprot14 or hprot15 or

	     hmaster )
  begin : MASTER_TRANS_MUX

    case ( hmaster )

      4'hf : begin
	
	haddr  <= haddr15;
	htrans <= htrans15;
	hwrite <= hwrite15;
	hburst <= hburst15;
	hsize  <= hsize15;
	hprot  <= hprot15;
	
      end // case: 4'hf

      4'he : begin
	
	haddr  <= haddr14;
	htrans <= htrans14;
	hwrite <= hwrite14;
	hburst <= hburst14;
	hsize  <= hsize14;
	hprot  <= hprot14;

      end // case: 4'he

      4'hd : begin
	
	haddr  <= haddr13;
	htrans <= htrans13;
	hwrite <= hwrite13;
	hburst <= hburst13;
	hsize  <= hsize13;
	hprot  <= hprot13;

      end // case: 4'hd

      4'hc : begin
	
	haddr  <= haddr12;
	htrans <= htrans12;
	hwrite <= hwrite12;
	hburst <= hburst12;
	hsize  <= hsize12;
	hprot  <= hprot12;

      end // case: 4'hc

      4'hb : begin
	
	haddr  <= haddr11;
	htrans <= htrans11;
	hwrite <= hwrite11;
	hburst <= hburst11;
	hsize  <= hsize11;
	hprot  <= hprot11;

      end // case: 4'hb

      4'ha : begin
	
	haddr  <= haddr10;
	htrans <= htrans10;
	hwrite <= hwrite10;
	hburst <= hburst10;
	hsize  <= hsize10;
	hprot  <= hprot10;

      end // case: 4'ha

      4'h9 : begin
	
	haddr  <= haddr9;
	htrans <= htrans9;
	hwrite <= hwrite9;
	hburst <= hburst9;
	hsize  <= hsize9;
	hprot  <= hprot9;

      end // case: 4'h9

      4'h8 : begin
	
	haddr  <= haddr8;
	htrans <= htrans8;
	hwrite <= hwrite8;
	hburst <= hburst8;
	hsize  <= hsize8;
	hprot  <= hprot8;

      end // case: 4'h8

      4'h7 : begin
      	
	haddr  <= haddr7;
	htrans <= htrans7;
	hwrite <= hwrite7;
	hburst <= hburst7;
	hsize  <= hsize7;
	hprot  <= hprot7;

      end // case: 4'h7

      4'h6 : begin
      	
	haddr  <= haddr6;
	htrans <= htrans6;
	hwrite <= hwrite6;
	hburst <= hburst6;
	hsize  <= hsize6;
	hprot  <= hprot6;

      end // case: 4'h6

      4'h5 : begin
      	
	haddr  <= haddr5;
	htrans <= htrans5;
	hwrite <= hwrite5;
	hburst <= hburst5;
	hsize  <= hsize5;
	hprot  <= hprot5;

      end // case: 4'h5

      4'h4 : begin
      	
	haddr  <= haddr4;
	htrans <= htrans4;
	hwrite <= hwrite4;
	hburst <= hburst4;
	hsize  <= hsize4;
	hprot  <= hprot4;

      end // case: 4'h4

      4'h3 : begin
      	
	haddr  <= haddr3;
	htrans <= htrans3;
	hwrite <= hwrite3;
	hburst <= hburst3;
	hsize  <= hsize3;
	hprot  <= hprot3;

      end // case: 4'h3

      4'h2 : begin
      	
	haddr  <= haddr2;
	htrans <= htrans2;
	hwrite <= hwrite2;
	hburst <= hburst2;
	hsize  <= hsize2;
	hprot  <= hprot2;

      end // case: 4'h2

      4'h1 : begin
      	
	haddr  <= haddr1;
	htrans <= htrans1;
	hwrite <= hwrite1;
	hburst <= hburst1;
	hsize  <= hsize1;
	hprot  <= hprot1;

      end // case: 4'h1

      4'h0 : begin
      	
	haddr  <= haddr0;
	htrans <= htrans0;
	hwrite <= hwrite0;
	hburst <= hburst0;
	hsize  <= hsize0;
	hprot  <= hprot0;

      end // case: 4'h0

      default : begin : MUX_IN_MASTER_UNDEFINE
     
	haddr  <= `DEFAULT_HADDR_VALUE;
	htrans <= `DEFAULT_HTRANS_VALUE;
	hwrite <= `DEFAULT_HWRITE_VALUE;
	hburst <= `DEFAULT_HBURST_VALUE;
	hsize  <= `DEFAULT_HSIZE_VALUE;
	hprot  <= `DEFAULT_HPROT_VALUE;
	
      end // block: MUX_IN_MASTER_UNDEFINE
    endcase // case( hmaster )
  end // block: MASTER_TRANS_MUX
       
  // hwdata  multiplexor - See section 3.11.3 for desctiption of the 
  // write data multiplexor.
   
  always @ ( hwdata0  or hwdata1  or hwdata2  or hwdata3  or
	     hwdata4  or hwdata5  or hwdata6  or hwdata7  or
	     hwdata8  or hwdata9  or hwdata10 or hwdata11 or
	     hwdata12 or hwdata13 or hwdata14 or hwdata15 or
             hmaster_dly )

  begin : WRITE_DATA_MUX
      
    case ( hmaster_dly )
        
      4'hf    : hwdata <= hwdata15;
      4'he    : hwdata <= hwdata14;         
      4'hd    : hwdata <= hwdata13;         
      4'hc    : hwdata <= hwdata12;         
      4'hb    : hwdata <= hwdata11;         
      4'ha    : hwdata <= hwdata10;        
      4'h9    : hwdata <= hwdata9;          
      4'h8    : hwdata <= hwdata8;
      4'h7    : hwdata <= hwdata7;          
      4'h6    : hwdata <= hwdata6;
      4'h5    : hwdata <= hwdata5;
      4'h4    : hwdata <= hwdata4;
      4'h3    : hwdata <= hwdata3;
      4'h2    : hwdata <= hwdata2;
      4'h1    : hwdata <= hwdata1;
      4'h0    : hwdata <= hwdata0;
      default  : hwdata  <= `DEFAULT_HWDATA_VALUE;

    endcase // case( hmaster_dly )
  end // block: WRITE_DATA_MUX
  
endmodule
