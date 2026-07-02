// DECIMAL TO BCD PRIORITY ENCODER

`timescale 1ns / 1ps

module priority_encoder (
	input wire [9:0] a,
	output reg 	 en,
	output reg [3:0] y
);

	always @(*) begin
		y = 4'b0000;
		en = 1'b1;

		casez (a)
			10'b1????????? : y = 4'b1001;
			10'b01???????? : y = 4'b1000;
			10'b001??????? : y = 4'b0111;
			10'b0001?????? : y = 4'b0110;
			10'b00001????? : y = 4'b0101;
			10'b000001???? : y = 4'b0100;
			10'b0000001??? : y = 4'b0011;
			10'b00000001?? : y = 4'b0010;
			10'b000000001? : y = 4'b0001;
			10'b0000000001 : y = 4'b0000;
			default : begin
				y = 4'b0000;
				en = 1'b0;
			end
		endcase
	end

endmodule
