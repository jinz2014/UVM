class fpu_monitor extends uvm_threaded_component;
`uvm_component_utils(fpu_monitor)
   
fpu_request m_req_in_process; 
                                
virtual fpu_pin_if m_fpu_pins;
fpu_vif_object fpu_vif_cfg;
  
uvm_analysis_port #(fpu_request)  request_ap;
uvm_analysis_port #(fpu_response) response_ap;
  
local int monitor_stream, request_handle, response_handle;
local time request_time;

function new(string name, uvm_component parent=null);
      super.new(name, parent);

      request_ap = new("request_ap",this);
      response_ap = new("response_ap",this);
      m_req_in_process = new();
endfunction // new


function void build();
      int verbosity_level = UVM_HIGH;
      uvm_object tmp;

      no_virtual_interface: assert(get_config_object("fpu_vif", tmp));
      $cast(fpu_vif_cfg, tmp);
      m_fpu_pins = fpu_vif_cfg.get_vif();

      void'( get_config_int("verbosity_level", verbosity_level) );
      set_report_verbosity_level(verbosity_level);
endfunction


task run();
      monitor_stream = $create_transaction_stream("Monitor_Stream");

      forever 
        @(posedge m_fpu_pins.clk) begin
	// If the FPU_TB_BUG compiler directive is defined, then request handling will take priority on response handling,
	// This could result in mismatches in some cases of pipeline, i.e. when a response and a new request are available at the same time
        // This can be considered as a conditionally introduced bug in the testbench
	`ifndef FPU_TB_BUG
            if(m_fpu_pins.ready == 1'b1) begin
               monitor_response();
            end
            if(m_fpu_pins.start == 1'b1) begin
	       request_time = $time+5;
               monitor_request();
            end
	`else 
            if(m_fpu_pins.start == 1'b1) begin
	       request_time = $time+5;
               monitor_request();
	    end
            if(m_fpu_pins.ready == 1'b1) begin
               monitor_response();
            end
	`endif

      end //  @(posedge m_fpu_pins.clk)
endtask // run



task monitor_request();
      fpu_request req;
      string s;
      int i;
      
    
      req = new();

      if(m_fpu_pins.start != 1'b1) begin
	      $sformat(s,"monitor_request called incorrectly: start=%b", m_fpu_pins.start);
	      uvm_report_error("monitor", s, UVM_LOW ,`__FILE__,`__LINE__);
	      return;
      end

      request_handle = $begin_transaction(monitor_stream, "Request");
      req.a.operand = m_fpu_pins.opa;
      req.b.operand = m_fpu_pins.opb;
      req.op = op_t'(m_fpu_pins.fpu_op);
      req.round = round_t'(m_fpu_pins.rmode);
      
      $cast(m_req_in_process, req.clone); // cast the base class returned and copied to our type.

      uvm_report_info("request", m_req_in_process.convert2string(), UVM_MEDIUM ,`__FILE__,`__LINE__);
      request_ap.write(m_req_in_process);
      #5;
      
      req.add2tr(request_handle);
      
      // note this transaction happent in zero time.
      $end_transaction(request_handle);

endtask // monitor_request



  
task monitor_response();
      fpu_response rsp;

      string s;
    
      if(m_fpu_pins.ready != 1'b1) begin
	      $sformat(s,"monitor_response called incorrectly: ready=%b", m_fpu_pins.ready);
	      uvm_report_error("monitor",s,UVM_LOW ,`__FILE__,`__LINE__);
      return;
      end
    
      rsp = new();
      response_handle = $begin_transaction(monitor_stream, "Response", request_time+5);

      rsp.a.operand = m_req_in_process.a.operand;
      rsp.b.operand = m_req_in_process.b.operand;
      rsp.op = m_req_in_process.op;
      rsp.round = m_req_in_process.round;
      rsp.result.operand = m_fpu_pins.outp;
    
      // collect up status information
      rsp.status[STATUS_INEXACT] = m_fpu_pins.ine;
      rsp.status[STATUS_OVERFLOW] = m_fpu_pins.overflow;
      rsp.status[STATUS_UNDERFLOW] = m_fpu_pins.underflow;
      rsp.status[STATUS_DIV_ZERO] = m_fpu_pins.div_zero;
      rsp.status[STATUS_INFINITY] = m_fpu_pins.inf;
      rsp.status[STATUS_ZERO] = m_fpu_pins.zero;
      rsp.status[STATUS_QNAN] = m_fpu_pins.qnan;
      rsp.status[STATUS_SNAN] = m_fpu_pins.snan;

      rsp.add2tr(response_handle);
      $end_transaction(response_handle);
      $add_relation(request_handle, response_handle, "Compute" );

      response_ap.write(rsp);

      uvm_report_info("response", rsp.convert2string(), UVM_MEDIUM ,`__FILE__,`__LINE__);
endtask // monitor_response

endclass // fpu_uvm_tlm
