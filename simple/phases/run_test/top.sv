  //Create a topology
  //            top
  //       |            |
  //     u1(A)         u2(A)
  //    |     |      |        |
  //   b1(B) d1(D)  b1(B)    d1(D)

  //No run phase
  class D extends uvm_component;
    function new (string name, uvm_component parent);
      super.new(name,parent);
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
  endclass

  //Has run phase
  class B extends uvm_component;
    rand logic [7:0] delay;
    function new (string name, uvm_component parent);
      super.new(name,parent);
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
      $display("%0t: %0s:  start run phase", $time, get_full_name());
      #delay;
      $display("%0t: %0s:  end run phase", $time, get_full_name());
    endtask
  endclass
  
  //Has run phase and contains subcomponents
  class A extends uvm_component;
    rand B b1;
    rand D d1;
    rand logic [7:0] delay;
    function new (string name, uvm_component parent);
      super.new(name,parent);
      b1 = new("b1", this);
      d1 = new("d1", this);
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
      $display("%0t: %0s:  start run phase", $time, get_full_name());
      #delay;
      $display("%0t: %0s:  end run phase", $time, get_full_name());
    endtask
  endclass

