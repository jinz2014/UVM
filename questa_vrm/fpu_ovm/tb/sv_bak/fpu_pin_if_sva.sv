`timescale 1ns/1ns

interface fpu_pin_if #(int FP_WIDTH = 32) (input bit clk);

  // Input Operands A & B
  logic [FP_WIDTH-1:0] opa;
  logic [FP_WIDTH-1:0] opb;
  
  //fpu operations (fpu_op)
  // ========================
  // 000 = add, 
  // 001 = substract, 
  // 010 = multiply, 
  // 011 = divide,
  // 100 = square root
  // 101 = unused
  // 110 = unused
  // 111 = unused
  logic [2:0]          fpu_op;
  
  // Rounding Mode: 
  // ==============
  // 00 = round to nearest even(default), 
  // 01 = round to zero, 
  // 10 = round up, 
  // 11 = round down
  logic [1:0]          rmode;
  
  //output port
  logic [FP_WIDTH-1:0] outp;
  
  //Control signals
  logic                start;
  logic                ready;
  
  //Exceptions
  logic                ine;       // inexact
  logic                overflow;  // overflow
  logic                underflow; // underflow
  logic                div_zero;  // divide by zero
  logic                inf;       // infinity
  logic                zero;      // zero
  logic                qnan;      // quiet Not-a-Number
  logic                snan;      // signalling Not-a-Number
  
  modport master(
   input               clk,
   output              opa,
   output              opb,
   output              fpu_op,
   output              rmode,
   input               outp,
   output              start,
   input               ready,
   input               ine,
   input               overflow,
   input               underflow,
   input               div_zero,
   input               inf,
   input               zero,
   input               qnan,
   input               snan);
  
  modport slave(
   input               clk,
   input               opa,
   input               opb,
   input               fpu_op,
   input               rmode,
   output              outp,
   input               start,
   output              ready,
   output              ine,
   output              overflow,
   output              underflow,
   output              div_zero,
   output              inf,
   output              zero,
   output              qnan,
   output              snan);
  
  modport monitor_mp(
   input               clk,
   input               opa,
   input               opb,
   input               fpu_op,
   input               rmode,
   input               outp,
   input               start,
   input               ready,
   input               ine,
   input               overflow,
   input               underflow,
   input               div_zero,
   input               inf,
   input               zero,
   input               qnan,
   input               snan);


typedef enum logic[2:0] {add, subtract, multiply, divide, square_root, nop1, nop2, nop3} op_t;

property validate_pipeline (op_t operand, int delay);
int dly;
@(posedge clk) ($rose(start && fpu_op == operand), dly=0) |=> (!ready,dly++)[*0:$] ##1 ready && dly==delay;
endproperty

`ifdef SVA
    `ifdef SVA_DUT
        check_add_delay:  assert property(validate_pipeline(add, 8));
        check_sub_delay:  assert property(validate_pipeline(subtract, 8));
        check_mult_delay: assert property(validate_pipeline(multiply, 13));
        check_div_delay:  assert property(validate_pipeline(divide, 35));
        check_sqrt_delay: assert property(validate_pipeline(square_root, 35));

        covered_add_delay: cover property(validate_pipeline(add, 8));
        covered_sub_delay: cover property(validate_pipeline(subtract, 8));
        covered_mult_delay: cover property(validate_pipeline(multiply, 13));
        covered_div_delay: cover property(validate_pipeline(divide, 35));
        covered_sqrt_delay: cover property(validate_pipeline(square_root, 35));
    `endif

    `ifdef SVA_SPEC
        check_add_delay:  assert property(validate_pipeline(add, 7));
        check_sub_delay:  assert property(validate_pipeline(subtract, 7));
        check_mult_delay: assert property(validate_pipeline(multiply, 12));
        check_div_delay:  assert property(validate_pipeline(divide, 35));
        check_sqrt_delay: assert property(validate_pipeline(square_root, 35));

        covered_add_delay: cover property(validate_pipeline(add, 7));
        covered_sub_delay: cover property(validate_pipeline(subtract, 7));
        covered_mult_delay: cover property(validate_pipeline(multiply, 12));
        covered_div_delay: cover property(validate_pipeline(divide, 35));
        covered_sqrt_delay: cover property(validate_pipeline(square_root, 35));
    `endif

    property valid_op;
    @(posedge clk) start |-> (fpu_op != nop1 && fpu_op != nop2 && fpu_op != nop3);
    endproperty

    check_opcode:   assert property(valid_op);
    covered_opcode: cover property(valid_op);
`endif // SVA

endinterface // fpu_pin_if
