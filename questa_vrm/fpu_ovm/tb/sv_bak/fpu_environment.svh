class fpu_environment extends uvm_env; // rename to base

`uvm_component_utils(fpu_environment)

fpu_agent                     agent;
fpu_scoreboard                scoreboard;


function new(string name = "", uvm_component parent=null);
      super.new(name, parent);
endfunction // new

// Using uvm 2.0 factory
function void build();
      int verbosity_level = UVM_HIGH;
      super.build();

      set_config_int("agent", "is_active", int'(UVM_ACTIVE));      
      agent = fpu_agent::type_id::create("agent", this);
      scoreboard = fpu_scoreboard::type_id::create("scoreboard", this);
      void'( get_config_int("verbosity_level", verbosity_level) );
      set_report_verbosity_level(verbosity_level);
endfunction // new


function void connect();
      super.connect();
      agent.request_analysis_port.connect(scoreboard.request_analysis_export);
      agent.response_analysis_port.connect(scoreboard.response_analysis_export);
endfunction // void



endclass
