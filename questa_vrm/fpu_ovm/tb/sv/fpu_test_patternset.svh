import fpu_agent_pkg::*;

class fpu_test_patternset extends fpu_test_base;
	`uvm_component_utils(fpu_test_patternset)

	fpu_sequence_patternset s_seq;

	function new(string name = "fpu_test_patternset", uvm_component parent=null);
		super.new(name, parent);
	endfunction // 
	
	function void build();	
		string patternset_filename;
    int patternset_maxcount;

    if($test$plusargs ("PATTERNSET_FILENAME")) begin
            void'($value$plusargs ("PATTERNSET_FILENAME=%s", patternset_filename));
            uvm_config_db #(string)::set("*sequencer", "patternset_filename", patternset_filename);
    end

    if($test$plusargs ("PATTERNSET_MAXCOUNT")) begin
            void'($value$plusargs ("PATTERNSET_MAXCOUNT=%d", patternset_maxcount));
            //set_config_int("*sequencer", "patternset_maxcount", patternset_maxcount);
            uvm_config_db #(int)::set("*sequencer", "patternset_maxcount", patternset_maxcount);
    end

		s_seq = fpu_sequence_patternset::type_id::create("s_seq");
		super.build();
	endfunction // new

	virtual task run;
		int timeout = `TIMEOUT;
		fork : thread_fpu_simple_sanity
			s_seq.start(seqr_handle, null);
			#timeout;
		join_any
		`uvm_info(get_type_name(), "Stopping test...", UVM_LOW )
		global_stop_request();
	endtask
endclass
