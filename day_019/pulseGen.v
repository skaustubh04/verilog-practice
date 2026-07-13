`timescale 1ns / 1ps

module pulse_gen (
	input wire  clk_i,	
	input wire  rst_n_i,	// active-low reset
	input wire  data_i,	// i/p data
	output wire data_q2_o,	// o/p of 2nd f/f
	output wire data_q3_o,	// o/p of 3rd f/f
	output wire pulse_o	// o/p of xor gate
);

	// ---
	// outputs of flops and xor gate
	reg  q1;
	reg  q2;
	reg  q3;
	wire g_xor;

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			q1    <= 1'b0;
			q2    <= 1'b0;
			q3    <= 1'b0;
		end
		else begin
			q1 <= data_i;
			q2 <= q1;
			q3 <= q2;
		end
	end

	assign g_xor = q2 ^ q3;

	assign data_q2_o = q2;
	assign data_q3_o = q3;
	assign pulse_o   = g_xor;

endmodule
