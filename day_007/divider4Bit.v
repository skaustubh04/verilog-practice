`timescale 1ns / 1ps

module divider_4bit (
	input [3:0]      divisor,
	input [3:0]      dividend,
	output reg [3:0] quotient,
	output reg [3:0] remainder
);
	always @(*) begin
		quotient = 4'b0000;
		remainder = dividend;

		if (divisor != 0) begin
			while (remainder >= divisor) begin
				remainder = remainder - divisor;
				quotient = quotient + 1'b1;
			end
		end
	end

endmodule
