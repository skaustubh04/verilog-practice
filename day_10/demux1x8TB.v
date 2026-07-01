`timescale 1ns / 1ps

module mux_1x8_tb;

	reg i;
	reg [2:0] sel;
	wire [7:0] y;

	integer k;

	demux_1x8 uut (.i(i), .sel(sel), .y(y));

	initial begin
		$dumpfile ("demux1x8TB.vcd");
		$dumpvars (0, mux_1x8_tb);

		$display ("\n");
		$display ("  i  | sel[2] | sel[1] | sel[0] |    y    ");
		$display ("-----|--------|--------|--------|---------");
		$monitor ("  %b  |    %b   |    %b   |   %b    | %b   ", i, sel[2], sel[1], sel[0], y);
		for (k=0; k<4; k++) begin
			i = $urandom_range (0, 1);
			sel = $urandom_range (0, 7);
			#10;
		end

		$display ("\n");
		$finish;
	end

endmodule
