/*
*
* This is a rtl design code for LFSR, realizing
* a pentanomial equation, as follows
* x^16 + x^ 10 + x^7 + x^4 + 1
* 
* This will be implemented using a 16-bit
* shift register.
*
*/

`timescale 1ns / 1ps

module pentanomial_lfsr (
	input wire  clk_i,
	input wire  rst_n_i,
	output wire [15:0] lfsr_o
);

	// ------------------
	// defining shift reg
	reg [15:0] shift_reg;

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			shift_reg <= {16{1'b1}};
		end
		else begin
			shift_reg <= {shift_reg[14:0],
					shift_reg[15] ^ shift_reg[9] ^ shift_reg[6] ^ shift_reg[3]};
		end
	end

	assign lfsr_o = shift_reg;

endmodule
