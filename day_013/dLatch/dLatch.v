`timescale 1ns / 1ps

module d_latch (
	input wire en,
	input wire d,
	output reg q
);

	always @(*) begin
		if (en) q = d;
	end

endmodule
