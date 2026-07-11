`timescale 1ns / 1ps

module RD_PTR #(
	parameter ADDR_WIDTH = 4
) (
	input wire 		   clk,
	input wire 		   rst_n,
	input wire 		   rd_en,
	input wire [ADDR_WIDTH:0] g_wr_ptr_sync,

	output reg  [ADDR_WIDTH:0] rd_ptr,
	output wire [ADDR_WIDTH:0] g_rd_ptr,
	output wire 		   empty
);

	assign g_rd_ptr = (rd_ptr >> 1) ^ rd_ptr;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			rd_ptr <= {(ADDR_WIDTH+1){1'b0}};
		end
		else if (rd_en & !empty) begin
			rd_ptr <= rd_ptr + 1'b1;
		end
	end

	assign empty = (g_rd_ptr == g_wr_ptr_sync);

endmodule
