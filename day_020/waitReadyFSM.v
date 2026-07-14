`timescale 1ns / 1ps

module WAIT_READY_FSM (
	input wire clk_i,
	input wire rst_n_i,
	input wire en_i,
	input wire ld_i,
	output reg valid_o
);

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			valid_o <= 1'b0;
		end
		// priority to be given to ld_i because it clears
		// `valid_o` once the decoder has processed the i/p
		else if (ld_i) begin
			valid_o <= 1'b0;
		end
		else if (en_i) begin
			valid_o <= 1'b1;
		end
	end

endmodule
