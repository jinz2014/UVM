// The environment class is top container to reusable components. 
// User instantiates an env class (in the testbench)  and configure it and its agent for specifc verification task

class base_env extends uvm_env;
   int num_masters;
   base_agent masters[];
   
  `uvm_component_utils_begin(base_env)
    `uvm_field_int(num_masters, UVM_ALL_ON)
  `uvm_component_utils_end

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  virtual function void build_phase(uvm_phase phase);
    string inst_name;
    super.build_phase(phase);

    // Build masters
    masters = new[num_masters];
    for(int i = 0; i < num_masters; i++) begin
      $sformat(inst_name, "masters[%0d]", i);
      masters[i] = base_agent::type_id::create(inst_name,this);
    end

    // Build slaves and other components.
  endfunction



endclass : base_env
