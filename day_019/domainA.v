`timescale 1ns / 1ps

module DOMAIN_A (
	input wire 	 clk_i,
	input wire 	 rst_n_i,
	input wire [1:0] data_i,
	input wire 	 send_i,
	input wire	 ack_i,
	output wire 	 ready_o,
	output reg 	 en_o,
	output reg [1:0] data_o
);

	wire lden;
	wire xor_en_and;

	assign lden       = send_i & ready_o;
	assign xor_en_and = en_o ^ lden;

	READY_FSM ready_fsm_inst (
		.clk_i(clk_i), .rst_n_i(rst_n_i),
		.send_i(send_i), .ack_i(ack_i),
		.ready_o(ready_o)
	);

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			data_o <= 2'b0;
			en_o   <= 1'b0;
		end
		else if(lden) begin
			en_o   <= ~en_o;	// this happens only for 1 clock cycle
			data_o <= data_i;
		end
	end

endmodule
