`timescale 1ns / 1ps

module DECODER (
	input wire 	 clk_i,
	input wire 	 rst_n_i,
	input wire 	 en_i,
	input wire [1:0] data_i,
	output reg [3:0] data_n_o
);

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			data_n_o <= 4'b1111;
		end
		else if (en_i) begin
			(* full_case, parallel_case *)
			case (data_i)
				2'b00 : data_n_o <= 4'b1110;
				2'b01 : data_n_o <= 4'b1101;
				2'b10 : data_n_o <= 4'b1011;
				2'b11 : data_n_o <= 4'b0111;
			endcase
		end
	end

endmodule
			
