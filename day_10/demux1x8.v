`timescale 1ns / 1ps

module demux_1x2 (
	input I,
	input Sel,
	output [1:0] Y
);

	assign Y = Sel ? {I, 1'bx} : {1'bx, I};

endmodule

module demux_1x8 (
	input i,
	input [2:0] sel,
	output [7:0] y
);

	wire [5:0] w;

	demux_1x2 dm1x2_1_1 (.I(i), .Sel(sel[2]), .Y(w[1:0]));

	demux_1x2 dm1x2_2_1 (.I(w[0]), .Sel(sel[1]), .Y(w[3:2]));
	demux_1x2 dm1x2_2_2 (.I(w[1]), .Sel(sel[1]), .Y(w[5:4]));

	demux_1x2 dm1x2_3_1 (.I(w[2]), .Sel(sel[0]), .Y(y[1:0]));
	demux_1x2 dm1x2_3_2 (.I(w[3]), .Sel(sel[0]), .Y(y[3:2]));
	demux_1x2 dm1x2_3_3 (.I(w[4]), .Sel(sel[0]), .Y(y[5:4]));
	demux_1x2 dm1x2_3_4 (.I(w[5]), .Sel(sel[0]), .Y(y[7:6]));

endmodule
