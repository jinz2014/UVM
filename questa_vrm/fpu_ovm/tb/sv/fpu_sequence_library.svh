class fpu_sequence_setup extends uvm_sequence #(fpu_request, fpu_response);
   `uvm_object_utils(fpu_sequence_setup)

  function new(string name = "fpu_sequence_setup");
        super.new(name);
  endfunction // new


  task body();
    int num_scenarios = $urandom_range(2,10);
    
    for(int unsigned i = 0; i < num_scenarios; i++) begin
     `uvm_do_with( req, {
                         req.a.mode == C_Zero;
                         req.b.mode == C_Zero;
                         } )
   
    end
  endtask // body
endclass
                                                 



class fpu_sequence_fair extends uvm_sequence #(fpu_request, fpu_response);
   `uvm_object_utils(fpu_sequence_fair)
   fpu_sequence_setup  sequence_setup;
   
function new(string name = "fpu_sequence_fair");
      super.new(name);
      sequence_setup = new();
endfunction // new


task body();
   int num_scenarios = $urandom_range(1,10)*10;
   `uvm_do( sequence_setup )

   for(int unsigned i = 0; i < num_scenarios; i++) begin
      `uvm_do_with( req,   {
                            req.op != OP_SQR; // disable for faster verification :-)
                            solve req.a.mode before req.b.operand; // enable for faster verification :-)
                            solve req.b.mode before req.b.operand; // enable for faster verification :-)
                           } )
   end
endtask // body
endclass


class fpu_sequence_random extends uvm_sequence #(fpu_request, fpu_response);
   `uvm_object_utils(fpu_sequence_random)
   fpu_sequence_setup  sequence_setup;
   
function new(string name = "fpu_sequence_random");
      super.new(name);
      sequence_setup = new();
endfunction // new


task body();
      int num_scenarios = $urandom_range(1,10)*10;
      
      `uvm_do( sequence_setup )


      for(int unsigned i = 0; i < num_scenarios; i++) begin
         `uvm_do_with( req,   {
                               req.op dist {OP_ADD :=10, OP_SUB := 10, OP_MUL := 10, OP_DIV := 10,  OP_SQR := 1};  
                               //solve req.a.mode before req.b.operand; // enable to faster verification :-)
                               //solve req.b.mode before req.b.operand; // enable to faster verification :-)
                              } )
                       
      end
endtask // body
                                             
endclass



class fpu_sequence_neg_sqr extends uvm_sequence #(fpu_request, fpu_response);
 `uvm_object_utils(fpu_sequence_neg_sqr)
                                               
function new(string name = "fpu_sequence_neg_sqr");
      super.new(name);
endfunction // new


task body();
      int num_scenarios = $urandom_range(1,10)*10;
      
      for(int unsigned i = 0; i < num_scenarios; i++) begin
         `uvm_do_with( req,   {
                               req.op == OP_SQR; 
                               //req.a.operand.sign == 'b1; // enable for faster verification :-)
                               //req.b.operand.sign == 'b1; // enable for faster verification :-)
                              } )
                       
      end
endtask // body
                                             
endclass


class fpu_sequence_simple_sanity extends uvm_sequence #(fpu_request, fpu_response);
 `uvm_object_utils(fpu_sequence_simple_sanity)
                                               
function new(string name = "fpu_sequence_simple_sanity");
      super.new(name);
endfunction // new


task body();
      int num_scenarios = $urandom_range(1,10)*10;
      
      for(int unsigned i = 0; i < num_scenarios; i++) begin
         `uvm_do_with( req,   {
                          	req.a.mode == C_Valid; 
                          	req.b.mode == C_Valid; 
                               //req.a.operand.sign == 'b1; // enable for faster verification :-)
                               //req.b.operand.sign == 'b1; // enable for faster verification :-)
                              } )
                       
      end
endtask // body
endclass


// read test stimulus patterns from a file
class fpu_sequence_patternset extends uvm_sequence #(fpu_request, fpu_response);
   `uvm_object_utils(fpu_sequence_patternset)

   string patternset_filename;
   int patternset_maxcount;

   function new(string name = "fpu_sequence_patternset");
      super.new(name);
   endfunction // new

   task pre_body();
      void'(m_sequencer.get_config_int ("patternset_maxcount", patternset_maxcount));
      void'(m_sequencer.get_config_string ("patternset_filename", patternset_filename));
   endtask

   task body();
      pattern_stimulus(patternset_filename, patternset_maxcount);
   endtask // body

   task pattern_stimulus( input string filename = "pattern.vec", input int max_count = -1 );
      int    fid = 0;
      int    code = 0;
      int    pattern_count = 0;
      string line, stmp;
      bit[31:0] av, bv, rv, ov, rdv;
      shortreal rf;
      
      if (max_count == -1) 
        uvm_report_info(get_type_name, $psprintf("Loading patterset: %s, using ALL patterns in patternset", filename, max_count), UVM_MEDIUM );
      else
        uvm_report_info(get_type_name, $psprintf("Loading patterset: %s, using %0d patterns", filename, max_count), UVM_MEDIUM );

      fid = $fopen(filename, "r");
      if (!fid) begin
         uvm_report_fatal(get_type_name, $psprintf("Cant open file %f",filename),UVM_LOW);
         $stop;
      end
      
      while ( !$feof(fid) && ( max_count == -1 || (pattern_count <= max_count)) )  
        begin
	        // operand A
	        code = $fscanf(fid, "%8h", av);
	        // operand B
	        code = $fscanf(fid, "%8h", bv);  
	        // op mode
	        code = $fscanf(fid, "%3b", ov);  
	        // round mode
	        code = $fscanf(fid, "%2b", rdv);  
		`uvm_do_with( req, {
                                    req.a.operand == single_float_t'(av);
                                    req.b.operand == single_float_t'(bv);
	                            req.op        == op_t'(ov);
	                            req.round     == round_t'(rdv);
                              } )
	        // result
 	       code = $fscanf(fid, "%8h", rv);  
	       rf = rv;
		   
	       if ((pattern_count % 10)==0) uvm_report_info(get_type_name, $psprintf("Loading patterset %0d...", pattern_count), UVM_HIGH );
	       pattern_count++;
      end // while not EOF
      $fclose(fid);
   endtask // pattern_stimulus
endclass

