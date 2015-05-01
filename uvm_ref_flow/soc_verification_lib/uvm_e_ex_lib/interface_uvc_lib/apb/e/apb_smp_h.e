---------------------------------------------------------------
File name   :  apb_smp_h.e
Title       :  Signal map declaration
Project     :  APB UVC
Developers  :  
Created     :  Tue Mar 11 10:56:54 2008
Description :  This file declares the signal map of the UVC.
Notes       :  The signal map is a unit that contains external ports
            :  for each of the HW signals that the agent must access 
            :  as it interacts with the DUT.
---------------------------------------------------------------
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
---------------------------------------------------------------

<'

package apb;

//=========================================================================
// General bus signal map. Contains the names of the general bus signals
//=========================================================================

// APB Signal Map unit inherited from uvm_signal_map
unit apb_smp like uvm_signal_map  {
    APB_PCLK: 		string;                 // clock
    APB_PRESETn: 	string;                 // reset (active low)
    APB_PADDR: 	        string;                 // 32-bit address bus
    APB_PENABLE:	string;			// enable
    APB_PWDATA: 	string;                 // 32-bit write data bus
    APB_PRDATA: 	string;                 // read data bus
    APB_PWRITE: 	string;                 // transfer direction
    APB_PREADY:  	string;
    APB_PSEL:     	string;
    APB_PSLVERR:	string;
};


extend apb_smp {
   
       
  // This field is the logical name of the env associated with this
  // signal map. This field is automatically constrained by the UVC. Do
  // constrain it manually.
  env_name   : apb_env_name_t;

  amba3      : bool;
  keep soft amba3 == FALSE;

  sig_pclk    : inout simple_port of bit is instance; 
  sig_presetn : inout simple_port of bit is instance; 
  sig_paddr   : inout simple_port of uint(bits:32) is instance; 
  sig_penable : inout simple_port of bit is instance; 
  sig_pwdata  : inout simple_port of uint(bits:32) is instance; 
  sig_prdata  : inout simple_port of uint(bits:32) is instance; 
  sig_pwrite  : inout simple_port of apb_command_t is instance; 
  sig_pready  : inout simple_port of bit is instance; 
  sig_pslverr : inout simple_port of bit is instance; 

  keep bind(sig_pclk 	,external);
  keep bind(sig_presetn ,external);
  keep bind(sig_paddr	,external);
  keep bind(sig_penable ,external);
  keep bind(sig_pwdata  ,external);
  keep bind(sig_prdata  ,external);
  keep bind(sig_pwrite  ,external);
  keep bind(sig_pready  ,empty);
  keep bind(sig_pslverr ,empty);
	
  when amba3 apb_smp {
    keep bind(sig_pready  ,empty);
    keep bind(sig_pslverr ,empty);
  };
	
  keep soft sig_pclk.hdl_path()    ==  APB_PCLK;
  keep soft sig_presetn.hdl_path() ==  APB_PRESETn; 
  keep soft sig_paddr.hdl_path()   ==  APB_PADDR; 
  keep soft sig_penable.hdl_path() ==  APB_PENABLE;
  keep soft sig_pwdata.hdl_path()  ==  APB_PWDATA; 
  keep soft sig_prdata.hdl_path()  ==  APB_PRDATA; 
  keep soft sig_pwrite.hdl_path()  ==  APB_PWRITE; 
  keep soft sig_pready.hdl_path()  ==  APB_PREADY;
        
}; 

unit apb_slave_signal_map_u {
  name: apb_env_name_t;
  id: apb_slave_id_t;
  APB_PSEL:string;     
};

extend apb_slave_signal_map_u {

  sig_psel: inout simple_port of bit is instance; 
  keep soft sig_psel.hdl_path() == APB_PSEL;
  keep bind(sig_psel,external);

};


'>
