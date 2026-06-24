`timescale 1ns / 1ps

module alu_add_sub #(parameter WIDTH=4)(a, b, cb_in, mode, sum, cb_out);

	input [WIDTH-1:0]      a;
	input [WIDTH-1:0]      b;
	input 		       cb_in;	// Carry in, Borrow in
	input 		       mode;	// 0 = ADD, 1 = SUB
	
	output reg [WIDTH-1:0] sum;
	output reg 	       cb_out;	// Carry out, Borrow out

	reg [WIDTH:0] result_reg;

	always @(*) begin
		if (mode == 1'b0) begin
			// ADD
			result_reg = a + b + cb_in;
		end
		else begin
			// SUB
			result_reg = a - b - cb_out;
		end

		sum = 	 result_reg[WIDTH-1:0];
		cb_out = result_reg[WIDTH];
	end

endmodule
