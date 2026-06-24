`timescale 1ns / 1ps

module alu_add_sub #(parameter WIDTH=4)(a, b, cb_in, mode, sum, cb_out);

	input [WIDTH-1:0]      a;
	input [WIDTH-1:0]      b;
	input 		       cb_in;	// Carry in, Borrow in
	input 		       mode;	// 0 = ADD, 1 = SUB
	
	output reg [WIDTH-1:0] sum;
	output reg 	       cb_out;	// Carry out, Borrow out

	always @(*) begin
		if (mode == 1'b0) begin
			// ADD
			{cb_out, sum} = a + b + cb_in;
		end
		else if (mode == 1'b1) begin
			// SUB
			{cb_out, sum} = a - b - cb_in;
		end
		else begin
			// explicilty mentioning unknown values
			// REASON: if not done, 'sum' and 'cb_out' will take
			// unknown values, but won't be able to recover from them.
			{cb_out, sum} = {(WIDTH+1){1'bx}};
		end

	end

endmodule
