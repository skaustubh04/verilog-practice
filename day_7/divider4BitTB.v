`timescale 1ns / 1ps

module divider_4bit_tb;

	reg [3:0]  dividend;
	reg [3:0]  divisor;
	wire [3:0] quotient;
	wire [3:0] remainder;

	integer i;

	divider_4bit uut (.dividend(dividend), .divisor(divisor), .quotient(quotient), .remainder(remainder));

	initial begin
		$dumpfile ("divider4BitTB.vcd");
		$dumpvars (0, divider_4bit_tb);

		$display ("\n");
		$monitor ("divisor=%b, dividend=%b, quotient=%b (%d), remainder=%b (%d)", divisor, dividend, quotient, quotient, remainder, remainder);

		for (i=0; i<4; i+=1) begin
			divisor = $urandom_range (0, 15);
			dividend = $urandom_range (0, 15);
			#10;
		end

		$display ("\n");
		$finish;
	end

endmodule
