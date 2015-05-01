  timeunit 1ns;
  timeprecision 1ns;
  
  
  parameter int FP_WIDTH = 32;
  parameter int FRAC_WIDTH = 23;


  typedef   enum {OP_ADD, OP_SUB, OP_MUL, OP_DIV, OP_SQR} op_t;
  string op_string[op_t] = '{OP_ADD:"add", 
                             OP_SUB:"sub", 
                             OP_MUL:"mul", 
                             OP_DIV:"div", 
                             OP_SQR:"sqr"};

  typedef   enum  {ROUND_EVEN, 
                   ROUND_ZERO, 
                   ROUND_UP, 
                   ROUND_DOWN
                   } round_t;
  
  string round_string[round_t] = '{ROUND_EVEN:"even", 
                                   ROUND_ZERO:"zero", 
                                   ROUND_UP:"up", 
                                   ROUND_DOWN:"down"};
  
// Enumeration of status bits.
typedef   enum {STATUS_INEXACT,
                STATUS_OVERFLOW,
                STATUS_UNDERFLOW,
                STATUS_DIV_ZERO,
                STATUS_INFINITY,
                STATUS_ZERO,
                STATUS_QNAN,
                STATUS_SNAN,
		STATUS_SIZE
                } status_t;

  typedef bit [STATUS_SIZE-1:0] status_vector_t;


  string status_string[status_t] = '{
                                     STATUS_INEXACT:"inexact",
                                     STATUS_OVERFLOW:"overflow",
                                     STATUS_UNDERFLOW:"underflow",
                                     STATUS_DIV_ZERO:"divide by zero",
                                     STATUS_INFINITY:"infinity",
                                     STATUS_ZERO:"zero",
                                     STATUS_QNAN:"quiet NAN",
                                     STATUS_SNAN:"signaling NAN"
                                     };

  typedef   enum  {C_NaN, 
                   C_Infinity, 
                   C_Zero, 
                   C_Valid
                   } operand_kind_t;
 

  typedef struct packed  {
			  bit    sign;
			  bit [7:0] exponent;
			  bit [22:0] mantissa;
			  } single_float_t;

//----------------------------------------------------------------------
// STRUCT REQSTRUCT
//
// classf objects cannot be passed back and forth through the
// DPI, however, structs can.  We use class transactions for
// the "real" work on the SystemVerilog side of the
// testbench and we convert to and from structs to pass back
// and forth to SystemC via DPI.
//----------------------------------------------------------------------

typedef struct  {
                 shortreal  a;
                 shortreal  b;
                 op_t       op;
                 round_t    round;
                 } REQSTRUCT;


//----------------------------------------------------------------------
// STRUCT RSPSTRUCT
//
// class objects cannot be passed back and forth through the
// DPI, however, structs can.  We use class transactions for
// the "real" work on the SystemVerilog side of the
// testbench and we convert to and from structs to pass back
// and forth to SystemC via DPI.
//----------------------------------------------------------------------

  typedef struct {
                  shortreal    a;
                  shortreal    b;
                  op_t         op;
                  round_t      round;
                  shortreal    result;
                  status_vector_t  status;
                  } RSPSTRUCT;


//----------------------------------------------------------------------



class fpu_vif_object extends uvm_object;
`uvm_object_utils(fpu_vif_object)

virtual fpu_pin_if vif;

function new(string name="");
      super.new(name);
endfunction

function virtual fpu_pin_if get_vif();
      return vif;
endfunction // virtual


function  void set_vif( virtual fpu_pin_if pins);
      vif = pins;
endfunction      

function void do_copy (uvm_object rhs);
      fpu_vif_object tmp;
      
      super.do_copy(rhs);
      $cast(tmp,rhs);
      vif= tmp.vif;
endfunction // void


endclass
