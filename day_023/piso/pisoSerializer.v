`timescale 1ns / 1ps

module piso_serializer #(
	parameter WIDTH = 16
) (
	// -------------------------------
	// inputs
	input wire 	       clk_i,
	input wire 	       rst_n_i,
	input wire 	       wr_en_i,
	input wire [WIDTH-1:0] wr_data_i,
	// -------------------------------
	// outputs
	output reg 	       wr_valid_o,
	output wire 	       rd_data_o
);

	// -----------------------------------
	// number of bits for counter
	localparam WIDTH_BITS = $clog2(WIDTH);

	// ----------------------------
	// counter and shift register
	reg [WIDTH-1:0]      shift_reg;
	reg [WIDTH_BITS-1:0] counter;

	always @(posedge clk_i or negedge rst_n_i) begin
		// contents reset
		if (!rst_n_i) begin
			shift_reg  <= {WIDTH{1'b0}};
			wr_valid_o <= 1'b1;
			counter    <= {WIDTH_BITS{1'b0}};
		end
		else if (wr_en_i & wr_valid_o) begin
			shift_reg  <= wr_data_i;	   // inserted to shift reg in 1 clk cycle
			wr_valid_o <= 1'b0;		   // goes LOW after writing
			counter    <= {WIDTH_BITS{1'b0}};  // starts from 0
		end
		else if (!wr_valid_o) begin	// TRUE after shift reg is written to
			if (counter == WIDTH-1) begin	// TRUE when shifting last bit
				wr_valid_o <= 1'b1;		   // goes HIGH as shift reg can be written to
				counter    <= {WIDTH_BITS{1'b0}};  // resets to 0
			end
			else begin
				shift_reg  <= {shift_reg[WIDTH-2:0], 1'b0};
				counter    <= counter + 1'b1;
			end
		end
	end

	assign rd_data_o = shift_reg[WIDTH-1];

endmodule
