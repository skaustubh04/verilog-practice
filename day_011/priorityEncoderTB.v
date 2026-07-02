`timescale 1ns / 1ps

module priority_encoder_tb;

	reg  [9:0] a;
	wire 	   en;	// enable
	wire [3:0] y;

	integer i;

	priority_encoder uut (.a(a), .en(en), .y(y));

	initial begin
		$dumpfile ("priorityEncoderTB.vcd");
		$dumpvars (0, priority_encoder_tb);

		$display ("\nDECIMAL TO BCD ENCODER\n");
		$monitor ("a=%b, en=%b, y=%b", a, en, y);

		a = 10'b0000000000; #10;
		a = 10'b0000000001; #10;
		a = 10'b0000000011; #10;
		a = 10'b0000000111; #10;
		a = 10'b0000001111; #10;
		a = 10'b0000011111; #10;
		a = 10'b0000111111; #10;
		a = 10'b0001111111; #10;
		a = 10'b0011111111; #10;
		a = 10'b0111111111; #10;
		a = 10'b1111111111; #10;

		$display ("\n");
		$finish;
	end

endmodule
