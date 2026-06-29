`timescale 1ns / 1ps

module multi_bit_comparator #(
	parameter WIDTH = 4
) (
	input [WIDTH-1:0] a,
	input [WIDTH-1:0] b,
	output a_great_b,
	output a_equal_b,
	output a_less_b
);

	assign a_great_b = (a > b);
	assign a_equal_b = (a == b);
	assign a_less_b = (a < b);

endmodule
