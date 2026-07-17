`timescale 1ns / 1ps

module siso_shift_reg #(
	parameter WIDTH = 16
) (
	input wire  clk_i,
	input wire  rst_n_i,
	input wire  wr_data_i,	// serial in
	output wire rd_data_o	// serial out
);

	// -----------------------
	// defining shift register
	reg [WIDTH-1:0] shift_reg;

	// ------------------------------------------------------------
	// shifting values inside regsiter
	// ------------------------------------------------------------
	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			shift_reg <= {WIDTH{1'b0}};
		end
		else begin
			shift_reg <= {shift_reg[WIDTH-2:0], wr_data_i};
		end
	end

	assign rd_data_o = shift_reg[WIDTH-1];	// reading from the register

endmodule
