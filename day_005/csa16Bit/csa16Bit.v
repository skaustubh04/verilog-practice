`timescale 1ns / 1ps

module full_adder_4bit (
	input [3:0]  A,
	input [3:0]  B,
	input	     Cin,
	output [3:0] Sum,
	output	     Cout
);

	wire [2:0] W;

	assign {W[0], Sum[0]} = A[0] + B[0] + Cin;
	assign {W[1], Sum[1]} = A[1] + B[1] + W[0];
	assign {W[2], Sum[2]} = A[2] + B[2] + W[1];
	assign {Cout, Sum[3]} = A[3] + B[3] + W[2];

endmodule

module csa_16bit (
	input  [15:0] a,
	input  [15:0] b,
	input 	      c_in,
	output [15:0] sum,
	output	      c_out
);

	wire [3:0] w;
	wire [3:0] fa_w;
	wire [15:0] p;

	assign p = a ^ b;

	// CHECK ".Cin()" EVERYTIME MODULE IS CALLED

	full_adder_4bit fa1 (.A(a[3:0]), .B(b[3:0]), .Cin(c_in), .Sum(sum[3:0]), .Cout(fa_w[0]));
	full_adder_4bit fa2 (.A(a[7:4]), .B(b[7:4]), .Cin(w[0]), .Sum(sum[7:4]), .Cout(fa_w[1]));
	full_adder_4bit fa3 (.A(a[11:8]), .B(b[11:8]), .Cin(w[1]), .Sum(sum[11:8]), .Cout(fa_w[2]));
	full_adder_4bit fa4 (.A(a[15:12]), .B(b[15:12]), .Cin(w[2]), .Sum(sum[15:12]), .Cout(fa_w[3]));

	assign w[0] = &p[3:0] ? c_in : fa_w[0];
	assign w[1] = &p[7:4] ? w[0] : fa_w[1];
	assign w[2] = &p[11:8] ? w[1] : fa_w[2];
	assign c_out = &p[15:12] ? w[2] : fa_w[3];

endmodule
