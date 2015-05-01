-----------------------------------------------------------------
File name     : spi_sequence_lib.e
Created       : Tue Jul 27 13:52:04 2008
Description   : This file declares a sequence.
Notes         :
-----------------------------------------------------------------
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
-------------------------------------------------------------------


<'

package spi;


type spi_sensor_cmd_t : [WRITE=0, READ=1](bits:1);

// Transaction struct
struct spi_sensor_transact_s {

  %cmd    : spi_sensor_cmd_t;
  %addr   : uint(bits:4);
  %length : uint(bits:3);
  
  %data   : list of  uint(bits:8);
  keep soft data.size() == value(length);

};

// Sequence Declaration
extend spi_sequence_kind_t: [SENSOR_ACCESS];
extend SENSOR_ACCESS spi_sequence {

  sensor_trans : spi_sensor_transact_s;

  body() @driver.clock is only {

    var tmp_byte  : uint(bits:8);
    var tmp_bytes : list of uint(bits:8);
    var tmp_bits  : list of uint(bits:1);
    
    tmp_bytes = pack(packing.high, sensor_trans);
    for each (entry) in tmp_bytes do {
      tmp_bits = pack(packing.high, entry);
      do this_item keeping {
        it.data_out == tmp_bits;
      };
      // skip command phase and store data in case of an read command
      if ((index>0) and (sensor_trans.cmd==READ)) {  
        unpack(packing.high, tmp_byte, this_item.data_in);  
        sensor_trans.data[(index-1)] = tmp_byte;
      };
    };
  }; // body()..
}; // extend SENSOR_ACCESS..


'>
