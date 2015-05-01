---------------------------------------------------------------
File name   : apb_env_h.e
Title       : Env unit declaration
Project     : APB UVC
Developers  : 
Created     : Tue Mar 11 10:56:54 2008
Description : This file declares the env unit.
Notes       : This files contains the instance of master,slave agent 
              and  message loggers
---------------------------------------------------------------
Copyright 1999-2011 Cadence Design Systems, Inc.
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

import apb_memory_map.e;

extend sys {

  post_generate() is also {
    var user_domain_manager: tf_domain_manager;
    user_domain_manager = sys.tf_get_domain_mgr_of(APB_TF);
    user_domain_manager.set_timeout_on();
  };
};

 
extend apb_env  {

  logger  : message_logger is instance;
  keep soft logger.verbosity == NONE;
    
  file_logger: message_logger is instance; 
  keep soft file_logger.verbosity == LOW; 
  keep soft file_logger.tags == {NORMAL}; 
  keep soft file_logger.to_file == "apb.elog"; 
  keep soft file_logger.to_screen == FALSE; 
    
  // next slave id 
  next_id : int (bits: 16);
  keep soft next_id == 0; 
  
  // list of active slave names
  active_slave_names     : list of apb_slave_id_t;

  //list of passive slave names
  passive_slave_names  : list of apb_slave_id_t;

  // list of all slave names 
  all_slave_names  : list of apb_slave_id_t;
  keep all_slave_names == {passive_slave_names;active_slave_names};
  
  // Signal map instance
  smp  : apb_smp is instance;
  keep smp.env_name == read_only(name);
  
  ssmp : list of apb_slave_signal_map_u is instance;
  keep ssmp.size() == read_only(all_slave_names.size());
  keep for each (map) in ssmp {
    map.name == read_only(name);
    map.id   == read_only(all_slave_names[index]);
  };

  // Slave memory address map
  addr_map : vr_ad_map;
  
  // Bus monitor instance
  bus_monitor : apb_bus_monitor is instance;
  keep bus_monitor.p_env             == me;
  keep bus_monitor.p_smp             == smp;
  keep bus_monitor.env_name          == name;
  keep soft bus_monitor.has_checks   == has_checks;
  keep soft bus_monitor.has_coverage == has_coverage;

  // List of all ACTIVE SLAVE agents
  active_slaves : list of ACTIVE SLAVE apb_slave is instance;
  keep soft active_slaves.size() == read_only(active_slave_names.size());
  keep for each (slave) in active_slaves {
    slave.id == active_slave_names[index];
    slave.p_env == me;
    slave.bfm.p_env == me;
  };

  // List of all PASSIVE SLAVE agents
  passive_slaves : list of PASSIVE SLAVE apb_slave is instance;
  keep soft passive_slaves.size() == read_only(passive_slave_names.size());
  keep for each (slave) in passive_slaves {
    slave.id == passive_slave_names[index];
    slave.p_env == me;
  };
  
  // APB MASTER instance. By default, the master is constrained to be active,
  // but you can override that in the config file.
  master : apb_master is instance;
  keep soft master.active_passive == ACTIVE;
  keep master.p_env               == me;
  keep master.env_name            == name;
  keep master.p_bus_monitor       == bus_monitor;
  keep master.p_smp               == smp;

  // APB SLAVE instance. By default, the slave is constrained to be active,
  // but you can override that in the config file.
  slaves  : list of apb_slave is instance;
  keep slaves == {passive_slaves; active_slaves};

  // By default, protocol checking is disabled. This field can be used to
  // enable protocol checking by setting the field to TRUE and constraining
  // other has_checks flags to this field.
  has_checks : bool;
  keep soft has_checks == FALSE;
   
  log_enable : bool;
  keep soft log_enable == FALSE; 

  // By default, coverage collection is disabled. This field can be used to
  // enable coverage collection by setting the field to TRUE and constraining
  // other has_coverage flags to this field.
  has_coverage : bool;
  keep soft has_coverage == FALSE;
   
  // Color used in messages for this unit
  env_vt_style: vt_style;
  keep soft env_vt_style == DARK_RED;
    
  // Unit name used in messages
  env_message_name : string;
  keep soft env_message_name == append("apb_",name.as_a(string));

  // This field determines what reset state the UVC starts in at the
  // beginning of a test. By default, the UVC assumes that reset is
  // asserted at the start of a test. The reset_asserted field goes to 
  // FALSE at the first de-assertion of the reset signal.
  !reset_asserted : bool;
    
  // This event gets emitted each time the reset signal changes state. Note
  // that, depending on how reset is generated, it is possible that this
  // event will be emitted at time zero.
  event reset_change is change(smp.sig_presetn$) @sim;
    
  // This event gets emitted when reset is asserted.
  event reset_start is 
        true((not reset_asserted) and
             (smp.sig_presetn$ == 0)) @reset_change;
  
  // This event gets emitted when reset is de-asserted.
  event reset_end  is 
        true(reset_asserted and
             (smp.sig_presetn$ != 0)) @reset_change;


  // Ensure that the reset_asserted field is kept up-to-date.
  on reset_start { 
    reset_asserted = TRUE; 
    message(LOW, "Reset was asserted");
    raise_objection(TEST_DONE);
  };

  on reset_end { 
    reset_asserted = FALSE;
    message(LOW, "Reset was de-asserted");
    drop_objection(TEST_DONE);
  };

  // The short_name() method returns the name of this UVC instance.
  short_name(): string is {
    result = env_message_name;
  };

  // This event is the rising edge of the bus clock, unqualified by reset.
  event unqualified_clock_rise is rise(smp.sig_pclk$) @sim;

  // This event is the falling edge of the bus clock, unqualified by reset.
  event unqualified_clock_fall is fall(smp.sig_pclk$) @sim;

  // This event is the rising edge of the bus clock, qualified by reset.
  event clock_rise is true(not reset_asserted) @unqualified_clock_rise;

  // This event is the falling edge of the bus clock, qualified by reset.
  event clock_fall is true(not reset_asserted) @unqualified_clock_fall;
  
  // This method controls the color of the short name.
  short_name_style(): vt_style is {
    result = env_vt_style;
  };

  get_next_slave_id():apb_slave_id_t is{
    while next_id.as_a(apb_slave_id_t) in active_slave_names {
      next_id += 1;
    };
    result = next_id.as_a(apb_slave_id_t);
    next_id += 1;	
  };    
    
  // Print a banner for each UVC instance at the start of the test.
  show_banner() is also {
    out ("****************************************************************");
    out ("(c) Cadence Design Systems, Inc  2011");
    out ("Bus : \t ", name);
    out ("****************************************************************");
    if master.active_passive == ACTIVE {
      message(LOW,"Bridge is  ACTIVE master");
    } else {
      message(LOW,"Bridge is  PASSIVE master");
    };

    for each (slave) in slaves {
      if slave.active_passive == ACTIVE {
        out("UVC Supplied slave ", "\t ACTIVE slave");
      } else {
        out("shadowed DUT slaves", "\t PASSIVE slave");
      };
    };
  }; 
}; 



// CONFIGURATION using uvm_build_config utility:
uvm_build_config env apb_env apb_env_config_u apb_env_config_params_s;
uvm_build_config agent apb_slave apb_slave_config_u apb_slave_config_params_s;

// parameters to user, for changing configuration during the run
extend apb_env_config_params_s {
  env_name : apb_env_name_t;
  slave_id : apb_slave_id_t;
  active_passive_slave  : list of uvm_active_passive_t;
};


extend apb_slave_config_params_s {
  active_passive_slave  : list of uvm_active_passive_t;
};


extend apb_env {

  // Configure
  configure( ctr    : uint,
    new_params : apb_env_config_params_s) is {

    // Propagate values to agent
    for each (slave) in slaves {
      slave.env_name = new_params.env_name;
      uvm_configure ctr slave {id} {new_params.slave_id};
      uvm_configure ctr slave {active_passive} {new_params.active_passive_slave};
    };
    config.params = new_params.copy();
  }; -- configure
}; -- apb_env

extend apb_env {
  show_config() is {
    message(LOW,"Printing the Config Parameters : ") {
      print config.params;
    };
  };
};

'>
