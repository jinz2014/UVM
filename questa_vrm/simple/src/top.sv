module top;

 `ifdef dirtest
  initial begin
    $display("Hello from %s", `dirtest);
  end
 `else
  integer seed;
  initial begin
    $value$plusargs("SEED=%d", seed);
    $display("Hello from random test, seed is %d", seed);
  end
 `endif

endmodule
