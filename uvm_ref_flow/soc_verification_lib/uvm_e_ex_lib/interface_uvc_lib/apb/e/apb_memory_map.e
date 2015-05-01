Title        : APB Memory Map
Project      : APB UVC
File name    : apb_memory_map.e
Created On   : April 2002
Developers   : 
Purpose      : 
Description  : 
Notes        : 

----------------------------------------------------------------------------
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
----------------------------------------------------------------------------

<'

package apb;

import apb_env;

// ------------------------------
// shr_apb_map_address_s
// ------------------------------
struct shr_apb_map_address_s {
  id : apb_slave_id_t;
  start_address	: apb_addr_t;
  end_address	: apb_addr_t;
};

// ******************************
// shr_apb_memory_segment_s
// ******************************
struct shr_apb_memory_segment_s {

  num:	uint;
  slave_id:   apb_slave_id_t;		// slave ID
  size:     	uint(bits:33);
  start_ad: 	apb_addr_t;
  end_ad:   	apb_addr_t;
  keep end_ad == (start_ad + size - 1);		
  keep gen (size) before (start_ad, end_ad);
    
  // belong() -- return TRUE if 'ad' belongs to the segment
  belong(ad: apb_addr_t): bool is {
    result = (ad >= start_ad and ad <= end_ad);    
  };
};

struct apb_reserved_space_s {
  name: apb_env_name_t;
  !map_addrs: list of shr_apb_map_address_s;
};

// ******************************
// APB Memory Map Unit
// ******************************
unit apb_memory_map_u {

  name:		apb_env_name_t ;
  !next_id: int (bits: 16);
  pre_generate() is also {
    next_id = 1; 
  };

  reserved_space: apb_reserved_space_s;

  segments: list of shr_apb_memory_segment_s;

  //number of segments = user segments + segments for UVC slaves
  keep soft segments.size() == read_only(slaves_id.size() + reserved_space.map_addrs.size() 
                                   - reserved_space.map_addrs.unique(.id).size());
  first_address:apb_addr_t;
  keep soft first_address == 0;

  last_address: apb_addr_t;
  keep soft last_address == -1;

  slaves_id:list of apb_slave_id_t;
  keep gen (slaves_id) before (segments);
  keep for each  in slaves_id { 
    soft it == (index+1).as_a(apb_slave_id_t);
  };	

  default_seg_size: uint(bits:33);
  keep default_seg_size == calc_default_size(first_address,last_address,slaves_id,reserved_space_copy);
   
  reserved_space_copy: list of shr_apb_map_address_s;
  keep gen(reserved_space) before (reserved_space_copy);
  keep gen(reserved_space_copy) before (segments);
  keep reserved_space_copy.size() == read_only(reserved_space.map_addrs.size());
  keep for each in reserved_space_copy {
    it == read_only(reserved_space.map_addrs[index]);
  };

  //The memory is carefull to the user constraints set using macros
  keep for each (seg) in segments {
    seg.num == index;
    seg.slave_id == get_id(index,reserved_space_copy);
    index > read_only(reserved_space_copy.size()-1) and read_only(reserved_space_copy.size() > 0) =>
      for each (rs) in reserved_space_copy {
       ((seg.start_ad < read_only(rs.start_address)  and seg.end_ad < read_only(rs.start_address))
        or (seg.start_ad > read_only(rs.end_address) and seg.end_ad > read_only(rs.end_address)));
    };
    index <= read_only(reserved_space_copy.size()-1) and read_only(reserved_space_copy.size()>0)  =>  
      seg.start_ad   == read_only(reserved_space_copy[index]).start_address 
      and seg.end_ad == read_only(reserved_space_copy[index]).end_address;
    
    soft seg.size == default_seg_size; 
    index > read_only(reserved_space_copy.size()) => seg.start_ad > prev.end_ad;
    index == 0 => soft seg.start_ad == 0;
    index >  0 => soft seg.start_ad == prev.end_ad + 1;
  };

  get_id(ind : int,reserved_space_copy:list of shr_apb_map_address_s):apb_slave_id_t is {
    if reserved_space_copy.size() <= ind {
      gen result keeping {
         it == get_unique_evc_slave_id(reserved_space_copy);  
      };
    } else {
      return reserved_space_copy[ind].id;
    };
  };
       
  get_unique_evc_slave_id(reserved_space_copy:list of shr_apb_map_address_s): apb_slave_id_t is {
    while next_id.as_a(apb_slave_id_t) in reserved_space_copy.id {
       next_id += 1;
    };
    result = next_id.as_a(apb_slave_id_t);
    next_id += 1;	
  };
   
  // --------------------------------------------------------------
  // calc_default_size()
  // calculate the default size of a segment in an 
  // evenly destributed memory map,
  // the size is a multiplicity of 1k
  // --------------------------------------------------------------
  calc_default_size(first_addr: apb_addr_t,last_addr: apb_addr_t,
    slaves: list of apb_slave_id_t,reserved_space_copy:list of shr_apb_map_address_s): uint(bits:33) is {
    var raw_size: uint(bits:33);
    raw_size =0;
    for each (rs) in reserved_space_copy {
       raw_size += (rs.end_address - rs.start_address);
    };
    raw_size = (last_addr.as_a(uint(bits: 33)) - first_addr.as_a(uint(bits: 33)) + 1 - raw_size) / (2 *slaves.size());
    result = raw_size - ( raw_size % 1k);
  };
   
  create_undef_seg(start_addr: apb_addr_t,end_addr: apb_addr_t) is {
    var seg: shr_apb_memory_segment_s = new shr_apb_memory_segment_s with {
      it.num       = segments.size();
      it.slave_id  = UNDEFINED;  
      it.size      = end_addr - start_addr + 1;
      it.start_ad  = start_addr;
      it.end_ad    = end_addr;
    };
    segments.add(seg);
  };	 

  post_generate() is also {
    var sorted_mem : list of shr_apb_memory_segment_s = segments.sort(.start_ad);
    for each (seg) in sorted_mem {
       if index != 0 {
          if (sorted_mem[index - 1].end_ad + 1) < seg.start_ad {
             create_undef_seg(sorted_mem[index - 1].end_ad + 1,
              seg.start_ad - 1);
          };
       } else {
          if seg.start_ad != 0x00000000 {
             create_undef_seg(0x00000000,seg.start_ad - 1);
          };
       };
    };
    
    if not segments.is_empty() {
       var end_addr: apb_addr_t = segments.sort(.start_ad).last(TRUE).end_ad;
       if  end_addr != 0xffffffff {
          create_undef_seg(end_addr + 1,0xffffffff);
       };
    };
    //active_slaves_id = segments.slave_id.sort(it).unique(it);
  };

  post_generate() is also {
    var sorted_mem : list of shr_apb_memory_segment_s = segments.sort(.start_ad);
    for each (seg) in sorted_mem {
      if index > 0 and seg.start_ad <= sorted_mem[index-1].end_ad {
         error(
          appendf("%s%s%s\n%s%s%s%s\n %s%s0x%-8.8x%s0x%-8.8x\n %s%s0x%-8.8x%s0x%-8.8x%s%s%s%s%s%s%s\n",
           "\n*********************************************",
           "**********",
           "\nCONFIGURATION ERROR:",
           "\ncollision between slave ",
           sorted_mem[index - 1].slave_id,
           " and slave ",seg.slave_id,
           sorted_mem[index - 1].slave_id,
           " start addr: ",sorted_mem[index - 1].start_ad,
           " end addr: ",sorted_mem[index - 1].end_ad,
           seg.slave_id,
           " start addr: ",seg.start_ad,
           " end addr: ",seg.end_ad,
           "\n\n address space ",seg.start_ad," to ",
           sorted_mem[index - 1].end_ad," is overlapping.",
           "\n*********************************************",
           "**********"));
      };
    };
  };
	
  post_generate() is also {
    for each (slave) in slaves_id {
      if not segments.has(.slave_id == slave) {
         error(
          appendf("%s%s%s%s%s%s%s%s",
           "\n*********************************************",
           "**********",
           "\nCONFIGURATION ERROR:",
           "\n\nslave id ",slave,
           " was not configured any memory space",
           "\n*********************************************",
           "**********"));
      };
    };
  };
   
  // ------------------------------------------------------------
  // get_segment(ad: apb_address): apb_memory_segment
  // return the segment in 'segments' that contain 'ad'
  // ------------------------------------------------------------
  get_segment(ad: apb_addr_t): shr_apb_memory_segment_s is {
    result = segments.first(.belong(ad));
  };
  
  // ------------------------------------------------------------
  // get_slave_id()
  // returns the correct slave id according to the address
  // ------------------------------------------------------------
  get_id_from_idx(num : uint): apb_slave_id_t is {
     if (num == 0){ return  UNDEFINED};
     result = segments[num].slave_id
  };
  
  get_slave_id(ad : apb_addr_t): apb_slave_id_t is {
     result = segments.first(.belong(ad)).slave_id;
  };
  
  get_slave_number(ad : apb_addr_t): uint(bits:4) is {
     result = get_slave_id(ad).as_a(int) - 1; 
  };
};

define <apb_set_slave_addr_with_size'statement> "apb_set <env'name> <slave'name> slave address space: start at <start'num> size <size'num>" as {
   extend <env'name> apb_reserved_space_s {
      post_generate() is also {
         var newmap : shr_apb_map_address_s = new shr_apb_map_address_s;
         newmap.start_address = <start'num>;
         newmap.end_address = <start'num> + <size'num> - 1;
         newmap.id = <slave'name>;
         map_addrs.add(newmap);
         map_addrs = map_addrs.sort(.start_address);
      };
   };
};

define <apb_set_slave_addr_with_end'statement> "apb_set <env'name> <slave'name> slave address space: start at <start'num> end at <end'num>" as {
   extend <env'name> apb_reserved_space_s {
      post_generate() is also {			
         var newmap : shr_apb_map_address_s = new shr_apb_map_address_s;
         newmap.start_address = <start'num>;
         newmap.end_address = <end'num>;
         newmap.id = <slave'name>;
         map_addrs.add(newmap);
         map_addrs = map_addrs.sort(.start_address);
      };
   };
};

'>
