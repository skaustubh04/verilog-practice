// CONSECUTIVE 3 ONES DETECTING MEALY MACHINE (OVERLAPPING)

`timescale 1ns / 1ps

module consec_3_ones (
	input wire clk,
	input wire rst,
	input wire bitstream,
	output reg y
);
	
	// state encoding
	localparam S0 = 2'b00;
	localparam S1 = 2'b01;
	localparam S2 = 2'b10;

	reg [1:0] curr_state, next_state;

	// sequential part
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			curr_state <= S0;
		end
		else begin
			curr_state <= next_state;
		end
	end

	// combinational part (next state logic)
	always @(*) begin
		// to avoid latches
		next_state = curr_state;
		y = 1'b0;

		case (curr_state)
			S0 : next_state = (bitstream == 1'b1) ? S1 : S0;
			S1 : next_state = (bitstream == 1'b1) ? S2 : S0;
			S2 : begin
				if (bitstream == 1'b1) begin
					next_state = S2;
					y = 1'b1;
				end
				else begin
					next_state = S0;
				end
			end
			default: begin
				next_state = S0;
			end
		endcase
	end

endmodule
