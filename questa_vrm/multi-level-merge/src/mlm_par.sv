module mlm_par(input logic [0:15] d, output logic [0:4] p);

	//
	// Hamming parity generator
	//
	// This is way more inefficient than one might like but it probably
	// lend itself well to partial statement coverage and merging tests.
	//
	// =====
    // BIT   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21
	// SIG p00 p01 d00 p02 d01 d02 d03 p03 d04 d05 d06 d07 d08 d09 d10 p04 d11 d12 d13 d14 d15
	// p00  X       X       X       X       X       X       X       X       X       X       X
	// p01      X   X           X   X           X   X           X   X           X   X        
	// p02              X   X   X   X                   X   X   X   X                   X   X
	// p03                              X   X   X   X   X   X   X   X                               
	// p04                                                              X   X   X   X   X   X
	// =====
	//

	always @(d) begin

		p = 5'b0;

		if (d[0]) begin
			p[0] = ~p[0];
			p[1] = ~p[1];
		end

		if (d[1]) begin
			p[0] = ~p[0];
			p[2] = ~p[2];
		end

		if (d[2]) begin
			p[1] = ~p[1];
			p[2] = ~p[2];
		end

		if (d[3]) begin
			p[0] = ~p[0];
			p[1] = ~p[1];
			p[2] = ~p[2];
		end

		if (d[4]) begin
			p[0] = ~p[0];
			p[3] = ~p[3];
		end

		if (d[5]) begin
			p[1] = ~p[1];
			p[3] = ~p[3];
		end

		if (d[6]) begin
			p[0] = ~p[0];
			p[1] = ~p[1];
			p[3] = ~p[3];
		end

		if (d[7]) begin
			p[2] = ~p[2];
			p[3] = ~p[3];
		end

		if (d[8]) begin
			p[0] = ~p[0];
			p[2] = ~p[2];
			p[3] = ~p[3];
		end

		if (d[9]) begin
			p[1] = ~p[1];
			p[2] = ~p[2];
			p[3] = ~p[3];
		end

		if (d[10]) begin
			p[0] = ~p[0];
			p[1] = ~p[1];
			p[2] = ~p[2];
			p[3] = ~p[3];
		end

		if (d[11]) begin
			p[0] = ~p[0];
			p[4] = ~p[4];
		end

		if (d[12]) begin
			p[1] = ~p[1];
			p[4] = ~p[4];
		end

		if (d[13]) begin
			p[0] = ~p[0];
			p[1] = ~p[1];
			p[4] = ~p[4];
		end

		if (d[14]) begin
			p[2] = ~p[2];
			p[4] = ~p[4];
		end

		if (d[15]) begin
			p[0] = ~p[0];
			p[2] = ~p[2];
			p[4] = ~p[4];
		end

	end

endmodule
