module mlm_sys;

	logic clk, rst;

	logic [0:15] i; // input value
	logic [0:20] e; // error injection

	wire  [0:15] o;

	// device (system) under test

	mlm_dut dut(clk, rst, i, e, o);

	// test stimulus

	initial begin
		@(negedge clk) e <= 21'b0; rst <= 1'b1;
		@(negedge clk) i <= 16'b0; rst <= 1'b0;
		@(negedge clk);

		if ($test$plusargs("short")) begin
		@(negedge clk) i <= 16'hdead;
		@(negedge clk) i <= 16'hbeef;
		end

		if ($test$plusargs("broad")) begin
		@(negedge clk) e <= 21'b0010_0000_0000_0000_0000_0; // transmission error
		@(negedge clk) i <= 16'h0055;
		@(negedge clk) i <= 16'h00aa;
		@(negedge clk) i <= 16'h0550;
		@(negedge clk) i <= 16'h0aa0;
		@(negedge clk) i <= 16'h5500;
		@(negedge clk) i <= 16'haa00;
		end

		if ($test$plusargs("shift")) for (int k = 0; k < 21; k++) begin
		@(negedge clk) e <= (21'b1000_0000_0000_0000_0000_0 >> k); // check errors in all bits
		@(negedge clk) i <= 16'h0055;
		@(negedge clk) i <= 16'h00aa;
		@(negedge clk) i <= 16'h0550;
		@(negedge clk) i <= 16'h0aa0;
		@(negedge clk) i <= 16'h5500;
		@(negedge clk) i <= 16'haa00;
		end

		@(negedge clk) i <= 16'b0;
		@(negedge clk);
		@(negedge clk) $stop;
	end

	// reference model (input delayed by two clocks)

	logic [0:15] i1;
	logic [0:15] i2;

	always @(posedge clk) begin
		i1 <= (rst ? 16'b0 : i);
		i2 <= (rst ? 16'b0 : i1);
	end

	// self-check (fails near zero-time)

	always @(negedge clk) begin
		if (o == i2) begin
			$display($time, ":                                   o=%h (OK)", o);
		end else begin
			$display($time, ":                                   o=%h (NG -- expected %h)", o, i2);
		end
	end

	// clock generator

	initial begin
		clk = 1'b1; forever #50 clk = ~clk;
	end

endmodule

module mlm_dut(input logic clk, rst, input logic [0:15] i, input logic [0:20] e, output logic [0:15] o);

	wire [0:20] w;
	wire [0:20] v = w ^ e;

	mlm_enc enc(clk, rst, i, w);
	mlm_dec dec(clk, rst, v, o);

endmodule

module mlm_enc(input logic clk, rst, logic [0:15] d, output logic [0:20] h);

	wire [0:4] p;

	mlm_par par(d, p);

	always @(posedge clk) begin
		$display($time, ": d=%h, p=%h", d, p);

		// produce Hamming-interlaced output

		if (rst) begin
			h <= 21'b0;
		end else begin
			h <= { p[0],
			       p[1], d[0],
			       p[2], d[1],  d[2],  d[3],
			       p[3], d[4],  d[5],  d[6],  d[7],  d[8],  d[9],  d[10],
			       p[4], d[11], d[12], d[13], d[14], d[15] };
		end
	end

endmodule

module mlm_dec(input logic clk, rst, logic [0:20] h, output logic [0:15] q);

	wire [0:4]  p = { h[0],  h[1],  h[3],  h[7],  h[15] };

	wire [0:15] d = { h[2],  h[4],  h[5],  h[6],  h[8],  h[9],  h[10], h[11],
	                  h[12], h[13], h[14], h[16], h[17], h[18], h[19], h[20] };

	wire [0:4]  n; // newly-generated parity bits

	wire [0:4]  e = n ^ p;

	mlm_par par(d, n);

	always @(posedge clk) begin
		$display($time, ":               p=%h, d=%h, e=%h", n, d, e);

		if (rst) begin
			q <= 16'b0;
		end else begin
			case ({e[4], e[3], e[2], e[1], e[0]})
				'b00011: q <= (d ^ 16'h8000);
				'b00101: q <= (d ^ 16'h4000);
				'b00110: q <= (d ^ 16'h2000);
				'b00111: q <= (d ^ 16'h1000);
				'b01001: q <= (d ^ 16'h0800);
				'b01010: q <= (d ^ 16'h0400);
				'b01011: q <= (d ^ 16'h0200);
				'b01100: q <= (d ^ 16'h0100);
				'b01101: q <= (d ^ 16'h0080);
				'b01110: q <= (d ^ 16'h0040);
				'b01111: q <= (d ^ 16'h0020);
				'b10001: q <= (d ^ 16'h0010);
				'b10010: q <= (d ^ 16'h0008);
				'b10011: q <= (d ^ 16'h0004);
				'b10100: q <= (d ^ 16'h0002);
				'b10101: q <= (d ^ 16'h0001);
				default: q <= (d); /* no error or error in parity bit */
			endcase
		end
	end

endmodule
