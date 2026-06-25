`timescale 1ns / 1ps

module cla (
	input [3:0]  a,
	input [3:0]  b,
	input 	     c_in,
	output [3:0] sum,
	output reg   c_out
);

	wire [3:0] p, g;
	reg [2:0] c;

	assign p = a ^ b;
	assign g = a & b;

	assign sum = p ^ c_in;

	always @(*) begin
		c[0] = g[0] + (p[0] & c_in);
		c[1] = g[1] + (p[1] & g[0]) + (p[1] & p[0] & c_in);
		c[2] = g[2] + (p[2] & g[1]) + (p[2] & p[1] & g[0]) + (p[2] & p[1] & p[0] & c_in);
		c_out = g[3] + (p[3] & g[2]) + (p[3] & p[2] & g[1]) + (p[3] & p[2] & p[1] & g[0]) + (p[3] & p[2] & p[1] & p[0] & c_in);
	end

endmodule
