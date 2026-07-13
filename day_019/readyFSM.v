`timescale 1ns / 1ps

module READY_FSM (
	input wire  clk_i,
	input wire  rst_n_i,	// reset from domain A (active-low)
	input wire  send_i,	// i/p coming from domain A
	input wire  ack_i,	// i/p coming from domain B
	output wire ready_o	// o/p of fsm
);

	localparam S0 = 1'b0,
		   S1 = 1'b1;

	reg  state_r;
	wire state_ns;

	assign state_ns = (~state_r & send_i) | (state_r & ~ack_i);
	assign ready_o  = ~state_r;

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			state_r <= 1'b0;
		end
		else begin
			state_r <= state_ns;
		end
	end

endmodule
