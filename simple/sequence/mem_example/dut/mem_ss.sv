//------------------------------------------------------------
//   Copyright 2010-2011 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------
//
// This module models a memory sub-system
// containing 3 memory regions and mapping
// registers that can relocate the memories
// in the address space
//
// The bus interface used is AHB
//
module mem_ss(input HCLK,
              input HRESETn,
              input[30:0] HADDR,
              input HWRITE,
              input[1:0] HTRANS,
              input[2:0] HSIZE,
              input[2:0] HBURST,
              input[3:0] HPROT,
              input[31:0] HWDATA,
              input HSEL,
              output logic HREADY,
              output logic[31:0] HRDATA,
              output logic[1:0] HRESP
             );

// Memory arrays modelled using associative arrays
typedef bit[31:0] mem_data_t;
typedef bit[31:0] mem_addr_t;

mem_data_t mem_array_1[bit[30:0]];
mem_data_t mem_array_2[bit[30:0]];
mem_data_t mem_array_3[bit[30:0]];

// Memory offset registers - One per memory array
//
// 0h - Offset for mem_array_1;
// 4h - Range for mem_array_1;
// 8h - Offset for mem_array_2;
// ch - Range for mem_array_2;
// 10h - Offset for mem_array_3;
// 14h - Range for mem_array_3;
// 18h - Status - whether mapped or not
bit[30:0] ma_1_offset;
bit[15:0] ma_1_range;
bit[30:0] ma_2_offset;
bit[15:0] ma_2_range;
bit[30:0] ma_3_offset;
bit[15:0] ma_3_range;
bit[2:0] ma_status;

bit[30:0] addr;
bit addr_valid;
bit write;

`include "reg_defs.sv"

//
// Simplified assumption is that all AHB accesses are linear
// and are byte aligned
// This design assumes that the pipelined address is valid for
// all beats in a burst, so it doesn't care what type of burst
// is going on. PROT etc are ignored
//
always @(negedge HCLK) begin
  if(HRESETn == 0) begin
    HREADY <= 0;
    HRDATA <= 0;
    HRESP <= 0;
    ma_1_offset <= 0;
    ma_1_range <= 0;
    ma_2_offset <= 0;
    ma_2_range <= 0;
    ma_3_offset <= 0;
    ma_3_range <= 0;
    addr_valid <= 0;
  end
  else begin
    HREADY <= 0;
    if(HTRANS[1] == 1) begin // Valid transfer taking place
      addr_valid <= 1;
      write <= HWRITE; // Pipeline for write & address
      addr <= HADDR;
      if(addr_valid == 0) begin
        HREADY <= 1;
      end
    end
    else begin // Transfer not in progress
      addr_valid <= 0;
    end
    if(addr_valid == 1) begin // Control phase pipelined
      if(write == 1) begin // Write cycle in progress
        case(addr)
          `ma_1_off: ma_1_offset <= HWDATA[30:0];
          `ma_1_rng: ma_1_range <= HWDATA[15:0];
          `ma_2_off: ma_2_offset <= HWDATA[30:0];
          `ma_2_rng: ma_2_range <= HWDATA[15:0];
          `ma_3_off: ma_3_offset <= HWDATA[30:0];
          `ma_3_rng: ma_3_range <= HWDATA[15:0];
          default: begin // This is the memory region
                     if((addr >= ma_1_offset) && (addr <= (ma_1_offset + ma_1_range))) begin
                       mem_array_1[(addr - ma_1_offset)] = HWDATA;
                     end
                     if((addr >= ma_2_offset) && (addr <= (ma_2_offset + ma_2_range))) begin
                       mem_array_2[(addr - ma_2_offset)] = HWDATA;
                     end
                     if((addr >= ma_3_offset) && (addr <= (ma_3_offset + ma_3_range))) begin
                       mem_array_3[(addr - ma_3_offset)] = HWDATA;
                     end
                   end
        endcase
      end
      else begin // Read cycle in progress
        case(addr)
          `ma_1_off: HRDATA <= {1'b0, ma_1_offset};
          `ma_1_rng: HRDATA <= {16'h0, ma_1_range};
          `ma_2_off: HRDATA <= {1'b0, ma_2_offset};
          `ma_2_rng: HRDATA <= {16'h0, ma_2_range};
          `ma_3_off: HRDATA <= {1'b0,ma_3_offset};
          `ma_3_rng: HRDATA <= {16'h0, ma_3_range};
          `ma_st:    HRDATA <= {29'h0, ma_status};
          default: begin
                     if((addr >= ma_1_offset) && (addr <= (ma_1_offset + ma_1_range)) && (ma_status[0] == 0)) begin
                       HRDATA <= mem_array_1[(addr - ma_1_offset)];
                     end
                     if((addr >= ma_2_offset) && (addr <= (ma_2_offset + ma_2_range)) && (ma_status[1] == 0)) begin
                       HRDATA <= mem_array_2[(addr - ma_2_offset)];
                     end
                     if((addr >= ma_3_offset) && (addr <= (ma_3_offset + ma_3_range)) && (ma_status[2] == 0)) begin
                       HRDATA <= mem_array_3[(addr - ma_3_offset)];
                     end
                   end
        endcase
      end
      HREADY <= 1;
      HRESP <= 0;
    end
  end
end

// ma_status will be reset as soon as the offset and range are non-zero
always_comb
  begin
    ma_status[2] =~(|(ma_3_offset) & |(ma_3_range));
    ma_status[1] = ~(|(ma_2_offset) & |(ma_2_range));
    ma_status[0] = ~(|(ma_1_offset) & |(ma_1_range));
  end

endmodule: mem_ss