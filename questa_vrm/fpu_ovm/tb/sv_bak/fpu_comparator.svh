import mti_fli::*;

class fpu_comparator #(type T = fpu_response) extends uvm_threaded_component;
`uvm_component_utils(fpu_comparator)
   
uvm_analysis_export #( T ) before_export , after_export;

local uvm_tlm_analysis_fifo #( T ) before_fifo , after_fifo;
int m_matches , m_mismatches = 0;


function new( string name, uvm_component parent ) ;
      super.new( name, parent );
endfunction


function void build();
      int verbosity_level = UVM_HIGH;
      super.build();
      
      before_export = new("before_export" , this );
      after_export = new("after_export" , this );

      before_fifo = new("before" , this );
      after_fifo = new("after" , this );
    
      void'( get_config_int("verbosity_level", verbosity_level) );
      set_report_verbosity_level(verbosity_level);
endfunction


task run();
      T b;
      T a;
  
      string s;
   
      forever begin
      
      before_fifo.get( b );
      after_fifo.get( a );
      
      if( !a.compare( b ) ) begin
         $sformat( s , "Comparator Mismatch: DUT response %s, differs from REF-model response %s" , a.convert2string() , b.convert2string() );
         uvm_report_error(get_type_name(), s, UVM_LOW ,`__FILE__,`__LINE__);
         m_mismatches++;
      end
      else begin
         $sformat( s , "Comparator Match: %s " , b.convert2string() );
         uvm_report_info(get_type_name(), s, UVM_HIGH, `__FILE__,`__LINE__);
         m_matches++;
      end
    end
endtask

function void connect();
      super.connect();
      before_export.connect( before_fifo.analysis_export );
      after_export.connect( after_fifo.analysis_export );
endfunction

function void report();
      string cmd;
      
      // Use the FLI via DPI to get access to the Questa CLI
      //$sformat(cmd, "coverage attr  -name Match -value %d",    m_matches);
      //assert (! mti_Cmd(cmd));

      //$sformat(cmd, "coverage attr  -name Mismatch -value %d", m_mismatches);  
      //assert (! mti_Cmd(cmd));
endfunction

function void flush();
      m_matches = 0;
      m_mismatches = 0;
      before_fifo.flush();
      after_fifo.flush();
endfunction

endclass
