`timescale 1ns / 1ps

module full_adder_4bit (
	input [3:0]  A,
	input [3:0]  B,
	input	     Cin,
	output [3:0] Sum,
	output	     Cout,
	output	     P_and
);

	wire [3:0] P;
	wire [2:0] W;

	assign P = A ^ B;
	assign P_and = &P;

	assign {W[0], Sum[0]} = A[0] ^ B[0] ^ Cin;
	assign {W[1], Sum[1]} = A[1] ^ B[1] ^ W[0];
	assign {W[2], Sum[2]} = A[2] ^ B[2] ^ W[1];
	assign {Cout, Sum[3]} = A[3] ^ B[3] ^ W[2];

endmodule

module csa_16bit (
	input [15:0]  a,
	input [15:0]  b,
	input 	      c_in,
	output [15:0] sum,
	output	      c_out
);

	wire [3:0] w;
	wire [3:0] p;

	// CHECK ".Cin()" EVERYTIME MODULE IS CALLED

	full_adder_4bit (.A(a[3:0]), .B(b[3:0]), .Cin(c_in), .Sum(sum[3:0]), .Cout(w[0]), .P_and(p[0]));
	full_adder_4bit (.A(a[4:7]), .B(b[4:7]), .Cin(), .Sum(sum[4:7]), .Cout(w[1]), .P_and(p[1]));
	full_adder_4bit (.A(a[8:11]), .B(b[8:11]), .Cin(), .Sum(sum[8:11]), .Cout(w[2]), .P_and(p[2]));
	full_adder_4bit (.A(a[12:15]), .B(b[12:15]), .Cin(), .Sum(sum[12:15]), .Cout(w[3]), .P_and(p[3]));

endmodule
