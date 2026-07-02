`timescale 1ns / 1ps

module csa_4bit_tb;

	reg [3:0]  a;
	reg [3:0]  b;
	reg 	   c_in;
	wire [3:0] sum;
	wire 	   c_out;

	integer i;

	csa_4bit uut (a, b, c_in, sum, c_out);

	initial begin
		$dumpfile ("csa4BitTB.vcd");
		$dumpvars (0, csa_4bit_tb);

		$display ("\n");
		$monitor ("a=%b, b=%b, c_in=%b, sum=%b, c_out=%b", a, b, c_in, sum, c_out);

		a = 4'b1010; b = 4'b0101; c_in = 1'b0; #10;
		a = 4'b1010; b = 4'b0101; c_in = 1'b1; #10;

		for (i=0; i<4; i=i+1) begin
			a = $urandom_range (0, 2**(4)-1);
			b = $urandom_range (0, 2**(4)-1);
			c_in = $urandom_range (0, 1);
			#10;
		end

		$display ("\n");
		$finish;
	end

endmodule
