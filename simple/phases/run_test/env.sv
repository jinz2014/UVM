  //Top level contains two A components
  class env extends uvm_env;
    rand A a1;
    rand A a2;
    function new (string name, uvm_component parent);
      super.new(name,parent);
      a1 = new("a1", this);
      a2 = new("a2", this);
    endfunction
    function void build_phase(uvm_phase phase);
      $display("%0t: %0s:  build", $time, get_full_name());
    endfunction
    function void end_of_elaboration_phase(uvm_phase phase);
      $display("%0t: %0s:  end_of_elaboration", $time, get_full_name());
    endfunction
    function void start_of_simulation_phase(uvm_phase phase);
      $display("%0t: %0s:  start_of_simulation", $time, get_full_name());
    endfunction
    function void extract_phase(uvm_phase phase);
      $display("%0t: %0s:  extract", $time, get_full_name());
    endfunction
    function void check_phase(uvm_phase phase);
      $display("%0t: %0s:  check", $time, get_full_name());
    endfunction
    function void report_phase(uvm_phase phase);
      $display("%0t: %0s:  report", $time, get_full_name());
    endfunction

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      $display("%0t: %0s:  start run phase", $time, get_full_name());
      #500;
      $display("%0t: %0s:  end run phase", $time, get_full_name());
      phase.drop_objection(this);
    endtask

  endclass


