import mti_fli::*;

class fpu_test_base extends uvm_test;

int verbosity_level = UVM_MEDIUM;
int m_logfile_handle;
      
`uvm_component_utils(fpu_test_base)

  
fpu_environment environment;

// Handle to sequencer down in the test environment
 uvm_sequencer #(fpu_request, fpu_response) seqr_handle;
 

function new(string name = "fpu_test_base", uvm_component parent=null);
      super.new(name, parent);
endfunction // new


function string send2vsim(string cmd = "" );
      string result;
      chandle interp;

      interp = mti_Interp();
      uvm_report_info( get_type_name(), $psprintf( "Sending \"%s\" to Questa", cmd), UVM_FULL ); 
      assert (! mti_Cmd(cmd));
      result = Tcl_GetStringResult(interp);
      Tcl_ResetResult(interp);
      uvm_report_info( get_type_name(), $psprintf( "Received \"%s\" from Questa", result), UVM_FULL );       
      return result;
endfunction


function void build();
      string result;
      string verbosity_level_s;
      
      if ( $value$plusargs("UVM_VERBOSITY_LEVEL=%s",verbosity_level_s)) begin
          case (verbosity_level_s)
          "UVM_NONE"   : verbosity_level = UVM_NONE;
          "UVM_LOW"    : verbosity_level = UVM_LOW;
          "UVM_MEDIUM" : verbosity_level = UVM_MEDIUM;
          "UVM_HIGH"   : verbosity_level = UVM_HIGH;
          "UVM_FULL"   : verbosity_level = UVM_FULL;
          "UVM_DEBUG"  : verbosity_level = UVM_DEBUG;
          default: verbosity_level = UVM_MEDIUM;
          endcase // case(verbosity_level_s)
      end 
      else begin
        verbosity_level = UVM_MEDIUM;
      end
      
      `uvm_info( get_type_name(), $psprintf("Setting verbosity_level: %0d", verbosity_level), UVM_FULL )
      //set_config_int("*", "verbosity_level", verbosity_level);
      uvm_config_db(this, "*", "verbosity_level", verbosity_level);

      m_rh.set_verbosity_level(verbosity_level);
      set_report_verbosity_level_hier(verbosity_level); // default

      // define default log file
      //m_logfile_handle = $fopen( $psprintf("%s.log", get_type_name() ), "w");
      //set_report_default_file(m_logfile_handle);

      // log to display (std out) and file
      set_report_severity_action(MESSAGE, DISPLAY | LOG);
      set_report_severity_action(ERROR,   DISPLAY | LOG | COUNT );
      set_report_severity_action(FATAL,   DISPLAY | LOG | EXIT );

      super.build();
      
      
      //First we set the name of the sequencer
      //set_config_string("environment.*", "SEQR_NAME", "main_sequencer");
      uvm_config_db #(string)::set(this, "environment.*", "SEQR_NAME", "main_sequencer");

      environment = fpu_environment::type_id::create("environment", this);

      `uvm_info( get_type_name(), $psprintf("Master random number generator seeded with: %0d", get_seed()), UVM_LOW )
endfunction


virtual function void end_of_elaboration();
      if (verbosity_level == UVM_FULL) begin
         print_config_settings("*",,1);
      end

      if (verbosity_level == UVM_HIGH) begin
         uvm_top.print_topology();
         uvm_factory::print_all_overrides(1);
      end

      //find the sequencer in the testbench
      assert($cast(seqr_handle, uvm_top.find("*main_sequencer")));  
endfunction // end_of_elaboration


virtual task run;
      //int runtime = $urandom_range(2,6)*1000;
      int runtime = `TIMEOUT;
      `uvm_info(get_type_name(), "No Sequences started ...", UVM_LOW)
      #runtime;
      `uvm_info(get_type_name(), "Stopping test...", UVM_LOW )
      global_stop_request();
endtask


function int get_seed();
      string result;
      result = send2vsim("lindex $Sv_Seed 0");
      return result.atoi();
endfunction


function int get_teststatus();
      string cmd = "lindex [coverage attr -name TESTSTATUS -concise] 0";
      string result, msg;

      result = send2vsim(cmd);
      // OK = "0", Warning = "1", Error = "2", or Fatal ="3"
      $sformat(msg, "vsim reported %0d as the teststatus", result);
      uvm_report_info( get_type_name(), msg, UVM_FULL ); 
      return result.atoi();
endfunction

      
virtual function void report;     // report
      string cmd,msg, result;
      uvm_report_server rs; 
      
      int fatal_count;
      int error_count;
      int warning_count;
      int message_count;

      int teststatus;
      
      rs = m_rh.m_glob.get_server();

      fatal_count = rs.get_severity_count(FATAL);
      error_count = rs.get_severity_count(ERROR);
      warning_count = rs.get_severity_count(WARNING);
      message_count = rs.get_severity_count(MESSAGE);

      teststatus = get_teststatus();
      
      super.report();
      
      Results_for_testcase: assert ( (warning_count==0) && (error_count==0) && (fatal_count==0) && ( teststatus==0 || teststatus==1) )  
      begin
         if (teststatus == 0) 
           `uvm_info( get_type_name(),$psprintf("Test Results: Passed with no errors"), UVM_LOW)
         else
           `uvm_info( get_type_name(),$psprintf("Test Results: Passed with no errors but with DUT warning(s)"), UVM_LOW)
      end
      else begin
         $sformat(msg, "Test Results: Failed with %0d error(s)", error_count);
         `uvm_error(get_type_name(), msg, UVM_LOW)
         $error(""); // signal to vsim
      end
endfunction // void

endclass
