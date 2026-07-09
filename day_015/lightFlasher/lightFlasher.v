`timescale 1ns / 1ps

module light_flasher (
	input wire clk,
	input wire rst,
	input wire flash_req,
	output reg light_out
);

	localparam S_OFF    = 3'b000,
		   S_HIGH_1 = 3'b001,
		   S_LOW_1  = 3'b010,
		   S_HIGH_2 = 3'b011,
		   S_LOW_2  = 3'b100,
		   S_HIGH_3 = 3'b101;

	reg [2:0] curr_state_r;
	reg [2:0] next_state_ns;

	reg timer_en;
	reg timer_mode;
	wire timer_done;

	always @(posedge clk or posedge rst) begin
		if (rst) curr_state_r <= S_OFF;
		else	 curr_state_r <= next_state_ns;
	end

	timer t1 (
		.clk(clk),
		.rst(rst),
		.timer_en(timer_en),
		.timer_mode(timer_mode),
		.timer_done(timer_done)
	);

	always @(*) begin
		// to avoid unintentional latches
		next_state_ns = curr_state_r;
		timer_mode    = 1'b0;
		light_out     = 1'b0;
		timer_en      = 1'b0;

		(* parallel_case *)
		case (curr_state_r)
			S_OFF : begin
				next_state_ns = (flash_req) ? S_HIGH_1 : S_OFF;
				timer_mode    = 1'b1;
				timer_en      = 1'b1;
				light_out     = 1'b0;
			end

			S_HIGH_1 : begin
				if (timer_done) begin
					next_state_ns = S_LOW_1;
					timer_mode = 1'b0;
				end
				else begin
					next_state_ns = S_HIGH_1;
				end
				timer_en      = timer_done;
				light_out     = 1'b1;
			end

			S_LOW_1 : begin
				if (timer_done) begin
					next_state_ns = S_HIGH_2;
					timer_mode    = 1'b1;
				end 
				else begin
					next_state_ns = S_LOW_1;
				end
				timer_en      = timer_done;
				light_out     = 1'b0;
			end

			S_HIGH_2 : begin
				if (timer_done) begin
					next_state_ns = S_LOW_2;
					timer_mode    = 1'b0;
				end
				else begin
					next_state_ns = S_HIGH_2;
				end
				timer_en      = timer_done;
				light_out     = 1'b1;
			end

			S_LOW_2 : begin
				if (timer_done) begin
					next_state_ns = S_HIGH_3;
					timer_mode = 1'b1;
				end
				else begin
					next_state_ns = S_LOW_2;
				end
				timer_en      = timer_done;
				light_out     = 1'b0;
			end

			S_HIGH_3 : begin
				if (timer_done) begin
					next_state_ns = S_OFF;
					timer_mode = 1'b0;
				end
				else begin
					next_state_ns = S_HIGH_3;
				end
				timer_en      = timer_done;
				light_out     = 1'b1;
			end

			default : begin
				next_state_ns = S_OFF;
				timer_mode    = 1'b0;
				timer_en      = 1'b0;
				light_out     = 1'b0;
			end
		endcase
	end

endmodule
