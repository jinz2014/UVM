-----------------------------------------------------------------
File name     : ahb_types.e
Developers    : vishwana
Created       : Tue Mar 30 14:29:27 2010
Description   : This file declares common types used throughout the UVC.
Notes         :
-------------------------------------------------------------------
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
-------------------------------------------------------------------
 
<'
package ahb;

--=========================================================================
-- General UVC Types
--========================================================================= 


#ifndef  AHB_DATA_WIDTH {
    define AHB_DATA_WIDTH           32;     // AHB data bus width
};

#ifndef AHB_ADDR_WIDTH {
    define AHB_ADDR_WIDTH           32;     // AHB address bus width
};


#ifndef AHB_MAX_MASTERS_NUM {
    define AHB_MAX_MASTERS_NUM           16;     // AHB address bus width
};

#ifndef AHB_UVM_ACCEL {
  type uvm_abstraction_level_t  : [UVM_SIGNAL, UVM_TLM, UVM_SIGNAL_SC](bits : 2);
};


-- global types

-- Enum type to uniquely identify all AHB envs instances
type ahb_env_name_t: [EVC_DEFAULT = UNDEF];

-- Endianness kind
type ahb_address: uint(bits: AHB_ADDR_WIDTH);   -- A uint type for the AHB address
type ahb_data: uint(bits: AHB_DATA_WIDTH);      -- A uint type for the AHB data

-- Unique names for AHB masters
type ahb_master_name: [
   M0, M1, M2,  M3,  M4,  M5,  M6,  M7,
   M8, M9, M10, M11, M12, M13, M14, M15
] ;

-- Unique names for AHB slaves
type ahb_slave_name: [
   S0, S1, S2,  S3,  S4,  S5,  S6,  S7,
   S8, S9, S10, S11, S12, S13, S14, S15, UNDEFINED
]; 


-- HWRITE - values enumeration
type ahb_direction:	[
   READ,
   WRITE
](bits:1);

-- HRESP[1:0] - values enumeration
type ahb_response_kind: [
   OKAY,       -- normal transfer
   ERROR,      -- transfer error
   RETRY,      -- transfer cannot complete immediately
   SPLIT       --   - "" -
](bits: 2);

-- HTRANS[1:0] - values enumeration
type ahb_transfer_kind:	[
   IDLE,       -- no data transfer required
   BUSY,       -- allow idle cycles by master
   NONSEQ,     -- first trnasfer in burst
   SEQ         -- sequential transfer
](bits: 2);


-- HBURST[2:0] - values enumeration
type ahb_burst_kind: [
   SINGLE,     -- single transfer
   INCR,       -- incrementing with unspecified length
   WRAP4,      -- 4-beat wrapping burst
   INCR4,      -- 4-beat incrementing burst
   WRAP8,      -- 8-beat wrapping burst
   INCR8,      -- 8-beat incrementing burst
   WRAP16,     -- 16-beat wrapping burst
   INCR16      -- 16-beat incrementing burst
](bits: 3);

-- HSIZE[2:0] - values enumeration
type ahb_transfer_size: [
   BYTE,             -- 8 bits
   HALFWORD,         -- 16 bits
   WORD,             -- 32 bits
   TWO_WORDS,        -- 64 bits
   FOUR_WORDS,       -- 128 bits
   EIGHT_WORDS,      -- 256 bits
   SIXTEEN_WORDS,    -- 512 bits
   K_BITS            -- 1024 bits
](bits: 3);

-- HPROT[0]
type ahb_io_mode:	[
   OPCODE,  -- opcode fetch
   DATA		-- data access
](bits:1);

-- HPROT[1]
type ahb_priv_mode: [
   USER,       -- user access
   PRIVILEGED	-- privileged access
](bits:1);

-- HPROT[2]
type ahb_buffer_mode: [
   NO_BUFF,    -- not bufferable
   BUFF		   -- bufferable
](bits:1);  

-- HPROT[3]
type ahb_cache_mode: [
   NO_CACHE,   -- not cacheable
   CACHE       -- cacheable
](bits:1);


-- Agent kind, or env. Used for subtyping according to agents
type ahb_agent_kind:[ENV,MASTER,SLAVE,ARBITER,DECODER];


'>
