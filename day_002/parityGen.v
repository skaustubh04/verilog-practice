`timescale 1ns / 1ps

// parity_type = 0 -> even parity
// parity_type = 1 -> odd parity

module parity_gen (data_in, parity_type, gen_parity);

	input [3:0] data_in;
	input parity_type;
	output reg gen_parity;

	// --- generating parity ---
	always @(*) begin
		if (parity_type == 0) begin	// even parity
			gen_parity <= ^data_in;
		end
		else begin
			gen_parity <= ~(^data_in);
		end
	end
endmodule
