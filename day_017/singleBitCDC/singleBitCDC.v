`timescale 1ns / 1ps

module single_bit_cdc (
	input wire clk_a,
	input wire clk_b,
	input wire rst_n,
	input wire a,
	output reg y
);

	reg a_q;
	reg b_q;

	always @(posedge clk_a or negedge rst_n) begin
		if (!rst_n) begin
			a_q <= 1'b0;
		end
		else begin
			a_q <= a;
		end
	end

	always @(posedge clk_b or negedge rst_n) begin
		if (!rst_n) begin
			b_q <= 1'b0;
			y   <= 1'b0;
		end
		else begin
			b_q <= a_q;
			y   <= b_q;
		end
	end

endmodule
