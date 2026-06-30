`timescale 1ns / 1ps

module mux_2x1 (
	input [1:0] I,
	input Sel,
	output Y
);

	assign Y = Sel ? I[1] : I[0];

endmodule

module mux_8x1 (
	input [7:0] i,
	input [2:0] sel,
	output y
);

	wire [5:0] w;

	mux_2x1 m21_1_1 (.I(i[1:0]), .Sel(sel[0]), .Y(w[0]));
	mux_2x1 m21_1_2 (.I(i[3:2]), .Sel(sel[0]), .Y(w[1]));
	mux_2x1 m21_1_3 (.I(i[5:4]), .Sel(sel[0]), .Y(w[2]));
	mux_2x1 m21_1_4 (.I(i[7:6]), .Sel(sel[0]), .Y(w[3]));
	mux_2x1 m21_2_1 (.I(w[1:0]), .Sel(sel[1]), .Y(w[4]));
	mux_2x1 m21_2_2 (.I(w[3:2]), .Sel(sel[1]), .Y(w[5]));
	mux_2x1 m21_3_1 (.I(w[5:4]), .Sel(sel[2]), .Y(y));

endmodule
