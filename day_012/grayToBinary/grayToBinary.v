`timescale 1ns / 1ps

module gray_to_binary #(
	parameter WIDTH=4
) (
	input  wire [WIDTH-1:0] gray,
	output reg  [WIDTH-1:0] b_out
);

	integer i;

	always @(*) begin
		b_out[WIDTH-1] = gray[WIDTH-1];

		for (i=WIDTH-2; i>=0; i=i-1) begin
			b_out[i] = b_out[i+1] ^ gray[i];
		end
	end

endmodule
