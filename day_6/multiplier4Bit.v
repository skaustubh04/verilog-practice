`timescale 1ns / 1ps

/*
* a3 a2 a1 a0
* b3 b2 b1 b0
* -----------
*  (product)
*
* m0 = {a0b0, a1b0, a2b0, a3b0}
* m1 = {a0b1, a1b1, a2b1, a3b1}
* m2 = {a0b2, a1b2, a2b2, a3b2}
* m3 = {a0b3, a1b3, a2b3, a3b3}
*
* m0 << 1 --> this will LSL m0 by single power of 2, and put '0' as LSB
*/

module multiplier_4bit (
	input [3:0]  a,
	input [3:0]  b,
	output [7:0] p
);

	wire [3:0] m [3:0];

	assign m[0] = {4{b[0]}} & a;
	assign m[1] = {4{b[1]}} & a;
	assign m[2] = {4{b[2]}} & a;
	assign m[3] = {4{b[3]}} & a;

	assign p = m[0] + (m[1] << 1) + (m[2] << 2) + (m[3] << 3);

endmodule
