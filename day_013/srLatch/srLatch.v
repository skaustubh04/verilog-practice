`timescale 1ns / 1ps

module sr_latch (
	input wire s,
	input wire r,
	output reg q,
	output reg q_bar
);

	always @(*) begin
		case ({s,r})
			2'b00 : begin
				q = q;
				q_bar = q_bar;
			end
			
			2'b01 : begin
				q = 1'b0;
				q_bar = 1'b1;
			end

			2'b10 : begin
				q = 1'b1;
				q_bar = 1'b0;
			end

			2'b11 : begin
				q = 1'b0;
				q_bar = 1'b0;
			end

			default : begin
				q = 1'bx;
				q_bar = 1'bx;
			end
		endcase
	end

endmodule
