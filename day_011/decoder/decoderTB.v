`timescale 1ns / 1ps

module decoder_tb;

	reg  [3:0] bcd_in;
	wire [7:0] y;

	integer i;

	decoder uut (.bcd_in(bcd_in), .y(y));

	initial begin
		$dumpfile ("decoderTB.vcd");
		$dumpvars (0, decoder_tb);

		$display ("\nBCD TO 7-SEGMENT DISPLAY DECODER\n");
		$monitor ("bcd_in=%b, y=%b", bcd_in, y);

		for (i=0; i<10; i++) begin
			bcd_in = i; #10;
		end

		$display ("\n");
		$finish;
	end

endmodule
