// BCD TO 7-SEGMENT DISPLAY DECODER
// DISPLAY IS ACTIVE HIGH

`timescale 1ns / 1ps

module decoder (
	input  wire [3:0] bcd_in,  // bcd input
	output reg  [7:0] y  	   // decoded for 7-segment (h,g,f,e,d,c,b,a)
);

	always @(*) begin
		(* parallel_case, full_case *)
		case (bcd_in)
			4'd0 : y = 8'b0011_1111;
			4'd1 : y = 8'b0000_0110;
			4'd2 : y = 8'b0101_1011;
			4'd3 : y = 8'b0100_1111;
			4'd4 : y = 8'b0110_0110;
			4'd5 : y = 8'b0110_1101;
			4'd6 : y = 8'b0111_1101;
			4'd7 : y = 8'b0000_0111;
			4'd8 : y = 8'b0111_1111;
			4'd9 : y = 8'b0110_1111;
			// default case isn't required when using 'full_case'
			// pragmas - it assumes I have covered all possible
			// cases that can occur irl
		endcase
	end

endmodule
