`timescale 1ns / 1ps

module timer (
	input wire clk,
	input wire rst,
	input wire timer_en,
	input wire timer_mode,
	output wire timer_done
);

	localparam T_LIGHT_OFF = 3'b011,
		   T_LIGHT_ON  = 3'b101;

	reg [2:0] curr_count_r;
	reg [2:0] next_count_ns;

	always @(posedge clk or posedge rst) begin
		if (rst) curr_count_r <= 3'b000;
		else	 curr_count_r <= next_count_ns;
	end

	assign timer_done = !(|curr_count_r);	// `timer_done` goes HIGH when `curr_count_r = T0`

	always @(*) begin
		casez ({rst, timer_en, timer_mode, timer_done})
			4'b1??? : next_count_ns = 3'b000;
			4'b010? : next_count_ns = T_LIGHT_OFF;
			4'b011? : next_count_ns = T_LIGHT_ON;
			4'b00?0 : next_count_ns = curr_count_r - 1'b1;
			4'b00?1 : next_count_ns = curr_count_r;
			default : next_count_ns = curr_count_r;
		endcase
	end

endmodule
