`timescale 1ns / 1ps

module pipo_register #(
	parameter WIDTH = 16
) (
	// -------------------------------
	// inputs
	input wire 	        clk_i,
	input wire 	        rst_n_i,
	input wire 	        wr_en_i,
	input wire [WIDTH-1:0]  wr_data_i,
	// -------------------------------
	// outputs
	output wire [WIDTH-1:0] rd_data_o
);

	// --------------------------
	// shift register
	reg [WIDTH-1:0] shift_reg;

	always @(posedge clk_i or negedge rst_n_i) begin
		// contents reset
		if (!rst_n_i) begin
			shift_reg  <= {WIDTH{1'b0}};
		end
		else if (wr_en_i) begin
			shift_reg  <= wr_data_i;  // write data to shift reg
		end
	end

	// continuously read from shift reg
	assign rd_data_o = shift_reg;

endmodule
