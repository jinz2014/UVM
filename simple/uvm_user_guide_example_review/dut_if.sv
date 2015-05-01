interface dut_if;

logic        clk;
logic        rd_en;
logic        wr_en;
logic [31:0] addr;
logic [31:0] data_in;
logic [31:0] data_out;
logic [31:0] delay;

endinterface
