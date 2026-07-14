`timescale 1ns / 1ps

module PULSE_GEN (
	input wire  clk_i,
	input wire  rst_n_i,
	input wire  data_i,
	output wire data_q3_o,	// o/p of 3rd f/f
	output wire pulse_o	// o/p of xor gate
);

	// ---
	// intermediate step variables
	reg [2:0] q;

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			q[2:0] <= 3'b0;
		end
		else begin
			q[0] <= data_i;
			q[1] <= q[0];
			q[2] <= q[1];
		end
	end

	assign data_q3_o = q[2];
	assign pulse_o   = q[1] ^ q[2];

endmodule
