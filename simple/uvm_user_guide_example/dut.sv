module dut_dummy (dut_if pif);
  
  parameter N = 256;
  
  logic [31:0] mem [0:N-1];
  logic [31:0] data;
  
  initial begin
    for (int i = 0; i < N; i++)
      mem[i] = i;
  end
  
  always @ (posedge pif.clk) begin
    data <= mem[pif.addr];
  end

  always @ (negedge pif.clk) begin
    mem[pif.addr] <= pif.data;
  end

  initial 
  $monitor("addr=%0d data=%0d" , pif.addr, pif.data);
  
endmodule
