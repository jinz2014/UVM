import fpu_agent_pkg::*;

class fpu_test_random_sequence extends fpu_test_base;
`uvm_component_utils(fpu_test_random_sequence)
 
 fpu_sequence_random  s_seq; // Sequence to execute

function new(string name = "fpu_test_random_sequence", uvm_component parent=null);
      super.new(name, parent);
endfunction // new


function void build();
      //set_config_int("*sequencer", "count", 0);
      s_seq = fpu_sequence_random::type_id::create("s_seq");
      super.build();
endfunction // new

virtual task run;
      int timeout = `TIMEOUT;
      fork : thread_fpu_sequence_rand
      	s_seq.start(seqr_handle, null);
      	#timeout;
      join_any
     
      uvm_report_info(get_type_name(), "Stopping test...", UVM_LOW );      
      global_stop_request();
endtask

endclass
