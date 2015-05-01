class fpu_sequence_driver extends uvm_driver #(fpu_request, fpu_response);
`uvm_component_utils(fpu_sequence_driver)

uvm_analysis_port       #(fpu_request) analysis_port;

virtual fpu_pin_if m_fpu_pins;
fpu_vif_object fpu_vif_cfg;


function new(string name, uvm_component parent=null);
      super.new(name, parent);
endfunction // new


function void build();
      int verbosity_level = UVM_HIGH;
      uvm_object tmp;

      super.build();

      analysis_port = new("analysis_port",  this);
      
      no_virtual_interface: assert(get_config_object("fpu_vif", tmp));
      $cast(fpu_vif_cfg, tmp);
      m_fpu_pins = fpu_vif_cfg.get_vif();

      void'( get_config_int("verbosity_level", verbosity_level) );
      set_report_verbosity_level(verbosity_level);
endfunction // build


task run();
      
      fpu_request m_request; 
      fpu_response m_response; 
  
      // let it run a clock cycle to initialize itself
      @(posedge m_fpu_pins.clk);
      @(negedge m_fpu_pins.clk);

      forever begin
         seq_item_port.get(m_request);

         uvm_report_info("request", m_request.convert2string(), UVM_HIGH ,`__FILE__,`__LINE__);
         analysis_port.write(m_request);
	 issue_request(m_request);
            
         wait(m_fpu_pins.ready == 1);

	 m_response = collect_response(m_request);
         m_response.set_id_info(m_request);
         rsp_port.write(m_response);

endtask // run


task issue_request(input fpu_request request);
      repeat ($urandom_range(0,17)) @(posedge m_fpu_pins.clk); // random idle time

      m_fpu_pins.opa <= request.a.operand;
      m_fpu_pins.opb <= request.b.operand;
      m_fpu_pins.fpu_op <= request.op;
      m_fpu_pins.rmode <= request.round;
      m_fpu_pins.start <= 1'b1;
      @(posedge m_fpu_pins.clk) m_fpu_pins.start <= 1'b0;
      @(negedge m_fpu_pins.clk);
endtask // issue_request

  
function fpu_response collect_response(input fpu_request request);
      fpu_response response;
      
      response = new();
      response.a.operand = request.a.operand;
      response.b.operand = request.b.operand;
      response.op = op_t'(m_fpu_pins.fpu_op);
      response.round = round_t'(m_fpu_pins.rmode);
      response.result.operand = m_fpu_pins.outp;
    
      // collect up status information
      response.status[STATUS_INEXACT] = m_fpu_pins.ine;
      response.status[STATUS_OVERFLOW] = m_fpu_pins.overflow;
      response.status[STATUS_UNDERFLOW] = m_fpu_pins.underflow;
      response.status[STATUS_DIV_ZERO] = m_fpu_pins.div_zero;
      response.status[STATUS_INFINITY] = m_fpu_pins.inf;
      response.status[STATUS_ZERO] = m_fpu_pins.zero;
      response.status[STATUS_QNAN] = m_fpu_pins.qnan;
      response.status[STATUS_SNAN] = m_fpu_pins.snan;
    
      return response;
endfunction // collect_response
  
endclass

