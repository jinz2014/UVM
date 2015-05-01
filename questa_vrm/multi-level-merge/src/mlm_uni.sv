module mlm_uni;

	logic clk;

	logic [0:15] i; // input value
	wire  [0:4]  p; // parity value

	// device (block) under test

	mlm_par par(i, p);

	// test stimulus

	initial begin
		@(negedge clk) i <= 16'b0;

		if ($test$plusargs("short")) begin
		@(negedge clk) i <= 16'hdead;
		@(negedge clk) i <= 16'hbeef;
		end

		if ($test$plusargs("broad")) begin
		@(negedge clk) i <= 16'h0055;
		@(negedge clk) i <= 16'h00aa;
		@(negedge clk) i <= 16'h0550;
		@(negedge clk) i <= 16'h0aa0;
		@(negedge clk) i <= 16'h5500;
		@(negedge clk) i <= 16'haa00;
		end

		@(negedge clk);
		@(negedge clk) $stop;
	end

	always @(negedge clk) begin
		$display($time, ": i=%h, p=%h", i, p);
	end

	// clock generator

	initial begin
		clk = 1'b1; forever #50 clk = ~clk;
	end

endmodule
