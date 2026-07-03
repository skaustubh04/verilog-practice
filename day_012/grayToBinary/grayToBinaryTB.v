`timescale 1ns / 1ps

module gray_to_binary_tb;

	parameter WIDTH=4;

	reg  [WIDTH-1:0] gray;
	wire [WIDTH-1:0] b_out;

	integer i;

	gray_to_binary #(
		.WIDTH(WIDTH)
	) uut (
		.gray(gray),
		.b_out(b_out)
	);

	initial begin
		$dumpfile ("grayToBinaryTB.vcd");
		$dumpvars (0, gray_to_binary_tb);

		$display ("\nGRAY TO BINARY CONVERTER\n");
		$monitor ("gray=%b, b_out=%b", gray, b_out);

		for (i=0; i<(1<<WIDTH); i++) begin
			gray = $urandom_range (0, 2**(WIDTH)-1);
			#10;
		end

		$display ("\n");
		$finish;
	end

endmodule
