`timescale 1ns / 1ps

module mux_8x1_tb;

	reg [7:0] i;
	reg [2:0] sel;
	wire y;

	integer k;

	mux_8x1 uut (.i(i), .sel(sel), .y(y));

	initial begin
		$dumpfile ("mux8x1TB.vcd");
		$dumpvars (0, mux_8x1_tb);

		$display ("\n");
		$display (" i[0] | i[1] | i[2] | i[3] | i[4] | i[5] | i[6] | i[7] | sel[0] | sel[1] | sel[2] |   y  ");
		$display ("------|------|------|------|------|------|------|------|--------|--------|--------|-----");
		$monitor ("   %b  |   %b  |   %b  |   %b  |   %b  |   %b  |   %b  |   %b  |    %b   |    %b   |    %b   |   %b ", i[0], i[1], i[2], i[3], i[4], i[5], i[6], i[7], sel[0], sel[1], sel[2], y);

		for (k=0; k<6; k++) begin
			i = $urandom_range (0, 2**(7)-1);
			sel = $urandom_range (0, 7);
			#10;
		end

		$display ("\n");
		$finish;
	end

endmodule
