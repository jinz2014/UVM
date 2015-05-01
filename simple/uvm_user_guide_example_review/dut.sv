module dut_dummy (dut_if pif);
  
  parameter N = 256;
  
  logic [31:0] mem [0:N-1];
  
  initial begin
    for (int i = 0; i < N; i++)
      mem[i] = i;
  end
  
  always @ (posedge pif.clk) begin
    if (pif.rd_en)
      pif.data_out <= #(pif.delay) mem[pif.addr];
  end

  always @ (negedge pif.clk) begin
    if (pif.wr_en)
      mem[pif.addr] <= pif.data_in;
  end

  initial 
  $monitor($time,,,"DUT: addr=%0h rd_en=%b wr_en=%b data_in=%0d data_out=%0d read_delay=%0d" , 
  pif.addr, pif.rd_en, pif.wr_en, pif.data_in, pif.data_out, pif.delay);

  property p_ro_wr;
    @(posedge pif.clk) pif.wr_en |-> (pif.addr < 128); 
  endproperty  
  ap_ro_wr: assert property (p_ro_wr);

  property p_data_out_never_x;
    @(posedge pif.clk) pif.rd_en |=> !$isunknown(pif.data_out);
  endproperty  
  ap_data_out_never_x: assert property (p_data_out_never_x);
  
  property p_rw_mutex;
    @(posedge pif.clk) not (pif.wr_en and pif.rd_en);
  endproperty  
  ap_rw_mutex: assert property (p_rw_mutex);
  
endmodule
