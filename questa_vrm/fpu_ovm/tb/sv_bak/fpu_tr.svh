//----------------------------------------------------------------------
// CLASS fp_operand
// 08.08.2011 Removed local qualifier for fpu_response class method
//            compare 
//----------------------------------------------------------------------
class fp_operand extends uvm_object;
`uvm_object_utils(fp_operand)

rand operand_kind_t mode;
rand single_float_t operand;


constraint fair   { solve mode before operand; }


constraint NaN { if (mode == C_NaN) {
                                     operand.sign inside {'b0, 'b1} ;
                                     operand.exponent == 'hff;
                                     operand.mantissa[$size(operand.mantissa)-1] inside {'b0, 'b1}; // msb
                                     }
} // Nan

constraint Infinity { if (mode == C_Infinity) {
                                               operand.sign inside {'b0, 'b1} ;
                                               operand.exponent == 'hff;
                                               operand.mantissa == 'h0;
                                               }
}// Infinity

constraint Zero { if (mode == C_Zero) {
                                          operand.sign inside {'b0, 'b1} ;
                                          operand.exponent == 0;
                                          operand.mantissa == 0;
                                          }
} // Zero

constraint Valid { if (mode == C_Valid) {
                                         operand.sign inside {'b0, 'b1} ;
                                         operand.exponent != 'h00;
                                         operand.exponent != 'hff;
                                         operand.mantissa != 'h0;
                                         operand.mantissa != 'h7fffff;
                                         }
} // Valid


function new (string name = "fp_operand");
      super.new(name);
      this.operand = operand;
endfunction // new

function uvm_object clone(); // always return the baseclass
      fp_operand t = new();
      t.copy (this);
      return t;
endfunction // clone


function void copy (input fp_operand t);
      super.copy (t);
      operand = t.operand;
endfunction  


function string convert2string;
      string s;
      shortreal r_operand;
      
      r_operand = $bitstoshortreal(operand);
      //$sformat(s,"(%s)%e", mode, r_operand);
      $sformat(s,"%e", r_operand);
      return s;
endfunction // convert2string

local function bit compare(fp_operand t);
      if(t.operand != this.operand) return 0;
      return 1;
endfunction // bit

endclass


//----------------------------------------------------------------------
// CLASS fp_transaction
//----------------------------------------------------------------------
  class fp_transaction extends uvm_sequence_item;
`uvm_object_utils(fp_transaction)

rand fp_operand a;
rand fp_operand b;
rand op_t    op;
rand round_t round;

static int s_transaction_count = 0;
int m_id;

string scenario;

constraint fair { solve op before round, a.operand, b.operand;}

function new (string name = "fp_transaction");
      super.new(name);
      
      a = new();
      b = new();
      m_id = s_transaction_count++;
endfunction // new


function uvm_object clone(); // always return the baseclass
      fp_transaction t = new();
      t.copy (this);
      return t;
endfunction // clone


function void copy (input fp_transaction t);
      super.copy (t);
      a = t.a;
      b = t.b;
      op = t.op;
      round = t.round;
      scenario = t.scenario;      
endfunction  


virtual function string convert2string;
      string s;
      $sformat(s,"a=%s, b=%s, op=%s, round=%s", a.convert2string,b.convert2string,op,round);
      return s;
endfunction // convert2string


local function bit compare(fp_transaction t);
      if(t.a.operand != this.a.operand)   return 0;
      if(t.b.operand != this.b.operand)   return 0;
      if(t.op != this.op)  return 0;
      if(t.round != this.round)     return 0;
      return 1;
endfunction // bit


function  bit IsInfinite(single_float_t f);
      // An infinity has an exponent of 255 (shift left 23 positions) and
      // a zero mantissa. There are two infinities - positive and negative.
      string s;

      if ((f.exponent == 'hff) && ( f.mantissa == {$size(f.mantissa){1'b0}} ) ) begin
         $sformat(s,"IsInfinite say yes %b, %b ", f.exponent, f.mantissa);
         uvm_report_info("IsInfinite",s, UVM_FULL ,`__FILE__,`__LINE__);
         return 1;
      end else begin
         $sformat(s,"IsInfinite say no %b, %b ", f.exponent, f.mantissa);
         uvm_report_info("IsInfinite",s, UVM_FULL ,`__FILE__,`__LINE__);
         return 0;
      end
      
endfunction // bit


function  bit IsNan(single_float_t f);
    // A NAN has an exponent of 255 (shifted left 23 positions) and a non-zero mantissa.
      string s;
      if ((f.exponent == 'hff) && (f.mantissa[$size(f.mantissa)-1] = 1) ) begin
         $sformat(s,"IsNan say yes %b  - %b", f.exponent, f.mantissa);
         uvm_report_info("IsNan",s, UVM_FULL ,`__FILE__,`__LINE__);
         return 1;
      end else begin
         $sformat(s,"IsNan say no %b  - %b", f.exponent, f.mantissa);
         uvm_report_info("IsNan",s, UVM_FULL ,`__FILE__,`__LINE__);
         return 0;
      end
      
endfunction


function bit Sign(single_float_t f);
      // The sign bit of a number is the high bit.
      return (f.sign);
endfunction


function bit _Sign(shortreal A);
      // The sign bit of a number is the high bit.
      return ($shortrealtobits(A) & 'h80000000);
endfunction

  
function  bit TestCompare2sComplement ( single_float_t f_before, single_float_t f_after, int maxUlps = 10 );
      string s;
      bit [31:0] bv;
      
      int i_before, i_after, DiffInt;

      //$display("\ngot shortreal before=%h, after=%h", f_before, f_after );

       // In theory comparing two NAN can never work, you cannot even compare a NAN to itself as it will fail
       // If the FPU_TB_BUG compiler directives is defined, comparison of DUT result vs REF-MODEL result will fail if they are NAN
       // This can be considered as a conditionally introduced bug in the testbench
      `ifndef FPU_TB_BUG
  // Don't compare NaNs
        if ( IsNan(f_before) && IsNan(f_after) )
  return 1;
      `endif 
      
      i_before = int'(f_before);
      i_after = int'(f_after);

      bv = i_before; //$display("got hex before=%h", bv);
      bv = i_after;  //$display("got hex after=%h",  bv);
 

      // Make xInt lexicographically ordered as a twos-complement int
      if (i_before < 0) i_before = 'h80000000 - i_before;
      if (i_after  < 0) i_after  = 'h80000000 - i_after;
         
      DiffInt = (i_before - i_after);
      DiffInt = (DiffInt < 0) ? -DiffInt : DiffInt;      
      //$display("diff hex is %h",DiffInt);

      if (DiffInt <= maxUlps) 
        return 1;
      else
        return 0;
      
endfunction // bit


local function bit IsValid;
      string s;

      IsValid = 1;
      // ieee 754 - 7.1

      if ( ( IsInfinite(a.operand) || IsInfinite(b.operand) ) && ( (op = OP_ADD) || (op = OP_SUB) )) begin
         $sformat(s,"Ignoring compare as IsInfinite as %s" ,this.convert2string());
         uvm_report_info("IsValid",s, UVM_FULL ,`__FILE__,`__LINE__); 
         IsValid = 0;
      end
      
      if ( round != ROUND_EVEN ) begin
         $sformat(s,"Ignoring compare as not ROUND_EVEN %s" ,this.convert2string());
         uvm_report_info("IsValid",s, UVM_FULL ,`__FILE__,`__LINE__); 
         IsValid = 0;
      end
 


      $sformat(s,"IsValid : Looks good %s" ,this.convert2string());
      uvm_report_info("IsValid",s, UVM_FULL ,`__FILE__,`__LINE__);       

      return IsValid;
endfunction // bit

endclass // fpu_transaction






//----------------------------------------------------------------------
// CLASS fpu_request
//----------------------------------------------------------------------
class fpu_request extends fp_transaction;
`uvm_object_utils(fpu_request)
  
function new ( string name = "fpu_request" );
      super.new(name);
endfunction // new

function uvm_object clone();
      fpu_request t = new();
      t.copy(this);
      return t;
endfunction

function void copy (fpu_request t);
      super.copy(t);
endfunction


virtual function REQSTRUCT to_struct();
      REQSTRUCT ts;
      
      ts.a = $bitstoshortreal(this.a.operand);
      ts.b = $bitstoshortreal(this.b.operand);
      ts.op = this.op;
      ts.round =this.round;
      
      return ts;
endfunction

virtual function fp_transaction to_class(REQSTRUCT ts);
      fp_transaction req = new();

      req.a.operand = $shortrealtobits(ts.a);
      req.b.operand = $shortrealtobits(ts.b);
      req.op = ts.op;
      req.round = ts.round;
      
      return req;
endfunction


function void add2tr (int handle = 0);

      op_t       wop = op;
      round_t    wround = round;
      $add_attribute(handle, $bitstoshortreal(a.operand), "A");
      $add_attribute(handle, $bitstoshortreal(b.operand), "B");
      $add_attribute(handle, wop, "Operation");
      $add_attribute(handle, wround, "RoundingMode");
endfunction
endclass // fpu_request






//----------------------------------------------------------------------
// CLASS response
//----------------------------------------------------------------------
class fpu_response extends fp_transaction;
fp_operand        result;
status_vector_t   status;


// need constructor comp and clone methods defined
function new ( string name = "fpu_response" );
      super.new(name);
      result = new();
endfunction // new


function uvm_object clone();
      fpu_response t = new();
      t.copy (this);
      return t;
endfunction // clone


function void copy (input fpu_response t);
      super.copy (t);
      result = t.result;
      status = t.status;      
endfunction  


function string convert2string;
      string s;
      $sformat(s,"a=%s, b=%s, op=%s, round=%s, result = %e with status =%b", a.convert2string,b.convert2string,op,round,result.convert2string, status);
      return s;
endfunction
    

function bit compare(fpu_response t);
      bit status=1;
      string s;
      shortreal result_before, result_after;
      
      if(t.op != this.op)
        return 0;
      
      if(t.round != this.round)
        return 0;

      
      if (super.IsValid) begin
         status = TestCompare2sComplement( this.result.operand, t.result.operand );
         return status;
      end
      
      else return 1;
endfunction // bit


// convert from a class to a struct
function RSPSTRUCT to_struct();
      RSPSTRUCT ts;
      
      ts.a = $bitstoshortreal(this.a.operand);
      ts.b = $bitstoshortreal(this.b.operand);
      ts.op = this.op;
      ts.round = this.round;
      ts.result = $bitstoshortreal(this.result.operand);
      ts.status = this.status;
      
      return ts;
endfunction // to_struct


// convert from a struct to a class
static function fpu_response to_class(RSPSTRUCT ts);
      fpu_response req = new();
      
      req.a.operand = $shortrealtobits(ts.a);
      req.b.operand = $shortrealtobits(ts.b);
      req.op = ts.op;
      req.round = ts.round;
      req.result.operand = $shortrealtobits(ts.result);
      req.status = ts.status;
      
      return req;
endfunction // to_class


function void add2tr (int handle = 0);
      op_t       wop = op;
      round_t    wround = round;
      $add_attribute(handle, $bitstoshortreal(a.operand), "A");
      $add_attribute(handle, $bitstoshortreal(b.operand), "B");
      $add_attribute(handle, wop, "Operation");
      $add_attribute(handle, wround, "RoundingMode");
      $add_attribute(handle, $bitstoshortreal(result.operand), "Result");
endfunction

endclass // fpu_response

