`timescale 1ns / 1ps

module binary_to_gray_tb;

	parameter WIDTH=4;

	reg  [WIDTH-1:0] b_in;
	wire [WIDTH-1:0] gray;

	integer i;

	binary_to_gray #(
		.WIDTH(WIDTH)
	) uut (
		.b_in(b_in),
		.gray(gray)
	);

	initial begin
		$dumpfile ("binaryToGrayTB.vcd");
		$dumpvars (0, binary_to_gray_tb);

		$display ("\nBINARY TO GRAY CONVERTER\n");
		$monitor ("b_in=%b, gray=%b", b_in, gray);

		for (i=0; i<4; i+=1) begin
			b_in = $urandom_range (0, 2**(WIDTH)-1);
			#10;
		end

		$display ("\n");
		$finish;
	end

endmodule
