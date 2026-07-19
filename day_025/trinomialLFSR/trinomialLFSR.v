/*
*
* Trinomial LFSR are mostly used for hardware
* efficiency. They use a 2-tap design.
* The polynomial implemented here is 
* x^7 + x^4 + 1
* This will be implemented using a 7-bit
* shift register.
*
*/

module trinomial_lfsr #(
	parameter WIDTH = 7
) (
	input wire 	        clk_i,
	input wire 	        rst_n_i,
	output wire [WIDTH-1:0] lfsr_o
);

	// -----------------------
	// defining shift reg
	reg [WIDTH-1:0] shift_reg;

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			shift_reg <= {WIDTH{1'b1}};
		end

		else begin
			shift_reg <= {shift_reg[5:0], shift_reg[6] ^ shift_reg[3]};
		end
	end

	assign lfsr_o = shift_reg;

endmodule
