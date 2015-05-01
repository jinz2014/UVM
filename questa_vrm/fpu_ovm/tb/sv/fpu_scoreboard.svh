class fpu_scoreboard extends uvm_component;

`uvm_component_utils(fpu_scoreboard)

fpu_comparator       #(fpu_response) comparator;
fpu_reference_model  reference_model;


uvm_tlm_analysis_fifo    #(fpu_request)  m_request_fifo;

uvm_analysis_export  #(fpu_request)  request_analysis_export;  // input stimuli 
uvm_analysis_export  #(fpu_response) response_analysis_export; // from DUT


function new(string name = "", uvm_component parent=null);
      super.new(name, parent);
endfunction // new


function void build_phase();
      int verbosity_level = UVM_HIGH;
      //super.build();
      
      m_request_fifo  = new("m_request_fifo", this);

      request_analysis_export = new("request_analysis_export",  this);
      response_analysis_export = new("response_analysis_export",  this);

      assert( $cast( comparator, create_component("fpu_comparator", "comparator") ));

      assert( $cast( reference_model, create_component("fpu_reference_model", "reference_model") ));

      void'( get_config_int("verbosity_level", verbosity_level) );
      set_report_verbosity_level(verbosity_level);
endfunction // new


function void connect_phase ();
      super.connect_phase();

      request_analysis_export.connect(m_request_fifo.analysis_export);
      reference_model.get_port.connect(m_request_fifo.get_export); 

      reference_model.response_analysis_port.connect(comparator.before_export);

      response_analysis_export.connect(comparator.after_export);

endfunction // void

endclass
