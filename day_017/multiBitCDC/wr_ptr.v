`timescale 1ns / 1ps

module WR_PTR #(
	parameter ADDR_WIDTH = 4
) (
	input  wire 		   clk,
	input  wire 		   rst_n,
	input  wire 		   wr_en,
	input  wire [ADDR_WIDTH:0] g_rd_ptr_sync,

	output reg  [ADDR_WIDTH:0] wr_ptr,
	output wire [ADDR_WIDTH:0] g_wr_ptr,
	output wire 		   full
);

	assign g_wr_ptr = (wr_ptr >> 1) ^ wr_ptr;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wr_ptr   <= {(ADDR_WIDTH+1){1'b0}};
		end
		else if (wr_en & !full) begin
			wr_ptr <= wr_ptr + 1'b1;
		end
	end

	assign full = (g_wr_ptr[ADDR_WIDTH:ADDR_WIDTH-1] == ~g_rd_ptr_sync[ADDR_WIDTH:ADDR_WIDTH-1]) &
		      (g_wr_ptr[ADDR_WIDTH-2:0] == g_rd_ptr_sync[ADDR_WIDTH-2:0]);

endmodule
