`timescale 1ns / 1ps

module binary_to_gray #(
	parameter WIDTH=4
) (
	input  wire [WIDTH-1:0] b_in,
	output reg  [WIDTH-1:0] gray
);

	integer i;

	always @(*) begin
		gray[WIDTH-1] = b_in[WIDTH-1];

		for (i=WIDTH-2; i>=0; i=i-1) begin
			gray[i] = b_in[i+1] ^ b_in[i];
		end
	end

endmodule
