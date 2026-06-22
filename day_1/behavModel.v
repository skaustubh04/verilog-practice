`timescale 1ns / 1ps

// basic logic gates using behavioural modelling

module behavioural_modelling (
	input a, b,
	output reg nand_g, nor_g, xnor_g
);

	always @(*)begin
		nand_g <= ~(a & b);
		nor_g  <= ~(a | b);
		xnor_g <= ~(a ^ b);
	end

endmodule
