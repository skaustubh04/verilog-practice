`timescale 1ns / 1ps

module DOMAIN_B (
	input wire 	  clk_i,
	input wire 	  rst_n_i,
	input wire [1:0]  data_i,
	input wire 	  en_i,
	output wire	  ack_o,
	output wire [3:0] data_n_o	// active-low o/p
);

	reg lden;

	PULSE_GEN pg_inst (
		.clk_i(clk_i), .rst_n_i(rst_n_i),
		.data_i(en_i), .data_q3_o(ack_o),
		.pulse_o(lden)
	);

	DECODER d_inst (
		.clk_i(clk_i), .rst_n_i(rst_n_i),
		.en_i(lden), .data_i(data_i),
		.data_n_o(data_n_o)
	);

endmodule
