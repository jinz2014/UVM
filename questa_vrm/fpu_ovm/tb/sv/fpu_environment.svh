class fpu_environment extends uvm_env; // rename to base

`uvm_component_utils(fpu_environment)

fpu_agent        agent;
fpu_scoreboard   scoreboard;


function new(string name = "", uvm_component parent=null);
  super.new(name, parent);
endfunction // new

function void build_phase();
  int verbosity_level = UVM_HIGH;
  super.build();

  //set_config_int("agent", "is_active", int'(UVM_ACTIVE));      
  uvm_config_db #(int)::set(this, "agent", "is_active", int'(UVM_ACTIVE));      

  agent = fpu_agent::type_id::create("agent", this);

  scoreboard = fpu_scoreboard::type_id::create("scoreboard", this);

  //uvm_config_db #(int)::read_by_name(this, "verbosity_level", verbosity_level) );
  //void'( get_config_int("verbosity_level", verbosity_level) );

  set_report_verbosity_level(verbosity_level);

endfunction // new


function void connect();
      super.connect();
      agent.request_analysis_port.connect(scoreboard.request_analysis_export);
      agent.response_analysis_port.connect(scoreboard.response_analysis_export);
endfunction // void



endclass
