`timescale 1ns / 1ps

module full_adder (
	input  A,
	input  B,
	input  Cin,
	output Sum,
	output Cout
);

	assign Sum = A ^ B ^ Cin;
	assign Cout = (A & B) | ((A | B) & Cin);

endmodule

module csa_4bit (
	input [3:0]  a,
	input [3:0]  b,
	input        c_in,
	output [3:0] sum,
	output 	     c_out
);

	wire [3:0] w;
	wire [3:0] p;

	assign p = a ^ b;

	full_adder fa1 (.A(a[0]), .B(b[0]), .Cin(c_in), .Sum(sum[0]), .Cout(w[0]));
	full_adder fa2 (.A(a[1]), .B(b[1]), .Cin(w[0]), .Sum(sum[1]), .Cout(w[1]));
	full_adder fa3 (.A(a[2]), .B(b[2]), .Cin(w[1]), .Sum(sum[2]), .Cout(w[2]));
	full_adder fa4 (.A(a[3]), .B(b[3]), .Cin(w[2]), .Sum(sum[3]), .Cout(w[3]));

	assign c_out = &p ? c_in : w[3];

endmodule
