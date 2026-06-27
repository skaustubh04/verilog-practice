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

	wire [3:0] m0;
	wire [4:0] m1;
	wire [5:0] m2;
	wire [6:0] m3;	// 7-bit final product after LSL

	wire [7:0] s [2:0];

	assign m0 = {4{b[0]}} & a;
	assign m1 = {4{b[1]}} & a;
	assign m2 = {4{b[2]}} & a;
	assign m3 = {4{b[3]}} & a;

	assign s[0] = m0 + (m1<<1);
	assign s[1] = s[0] + (m2<<2);
	assign s[2] = s[1] + (m3<<3);
	assign p = s[2];

	// assign p = m0 + (m1 << 1) + (m2 << 2) + (m3 << 3);

endmodule
