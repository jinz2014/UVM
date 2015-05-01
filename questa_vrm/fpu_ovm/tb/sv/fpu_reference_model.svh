import "DPI-C" function void com_pute(input REQSTRUCT  req , output RSPSTRUCT res );

class fpu_reference_model extends uvm_threaded_component;
`uvm_component_utils(fpu_reference_model)

fpu_request  m_req; 
fpu_response m_rsp; 

uvm_blocking_get_port #(fpu_request)   get_port;
uvm_analysis_port     #(fpu_response)  response_analysis_port;

     
function new(string name, uvm_component parent=null);
      super.new(name, parent);
endfunction

      
function void build();
      int verbosity_level = UVM_HIGH;

      //super.build();
      
      get_port = new("get_port",  this);
      response_analysis_port = new("response_ap",this);

      //void'( get_config_int("verbosity_level", verbosity_level) );
      set_report_verbosity_level(verbosity_level);
endfunction

      
task run();
      forever begin
         get_port.get(m_req);

         `uvm_info(get_type_name(), m_req.convert2string(), UVM_FULL)
      
         m_rsp = compute(m_req);

         `uvm_info(get_type_name(), m_rsp.convert2string(), UVM_FULL)
         response_analysis_port.write(m_rsp);
     end
endtask

  
function fpu_response compute(fpu_request req);
      REQSTRUCT s_req; 
      RSPSTRUCT s_rsp; 
      
      fpu_response rsp;
      rsp = new();

      // convert to stuct and pass over DPI
      s_req = req.to_struct;

      // calc it...
      com_pute(s_req, s_rsp);

      // convert struct to class and return
      rsp = rsp.to_class(s_rsp);
      return rsp;
endfunction
  
endclass
