`timescale 1ns / 1ps

module DECODER_2x4 (
	input wire 	 clk_i,
	input wire 	 rst_n_i,
	input wire 	 lden_i,
	input wire [1:0] data_i,
	output reg [3:0] data_o
);

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			data_o <= 4'b1;
		end
		else if (lden) begin
			(* full_case, parallel_case *)
			case (data_i)
				2'b00 : data_o <= 4'b1110;
				2'b01 : data_o <= 4'b1101;
				2'b10 : data_o <= 4'b1011;
				2'b11 : data_o <= 4'b0111;
			endcase
		end
	end

endmodule
