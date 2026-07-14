`timescale 1ns / 1ps

module READY_BUSY_FSM (
	input wire clk_i,
	input wire rst_n_i,
	input wire ack_i,
	input wire send_i,
	output reg ready_o
);

	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			ready_o <= 1'b1;	// it is ready to send data
		end
		else if (ready_o & send_i) begin
			ready_o <= 1'b0;	// `ready_o` goes LOW when data is ready to be sent
		end
		else if (!ready_o & ack_i) begin
			ready_o <= 1'b1;	// assert `ready` when `ack_i` arrives
		end
	end

endmodule
