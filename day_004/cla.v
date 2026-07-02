`timescale 1ns / 1ps

module cla (
	input [3:0]  a,
	input [3:0]  b,
	input 	     c_in,
	output reg [3:0] sum,
	output reg   c_out
);

	wire [3:0] p, g;
	reg [2:0] c;

	assign p = a ^ b;
	assign g = a & b;

	always @(*) begin
		
		c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c_in);
		c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c_in);
		c_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c_in);

		// Fixed a mistake:
		// Earlier, just before the 'always' block, i had written 'assign sum = p ^ c_in'
		// This would provide incorrect result as the further carry
		// aren't getting used, and only 'c_in' gets extended to
		// 4 bits (like 4'b000c_in), which is incorrect

		sum[0] = p[0] ^ c_in;
		sum[1] = p[1] ^ c[0];
		sum[2] = p[2] ^ c[1];
		sum[3] = p[3] ^ c[2];
	end

endmodule
