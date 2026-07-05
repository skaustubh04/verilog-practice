`timescale 1ns / 1ps

module csa_16bit_tb;

	reg [15:0]  a;
	reg [15:0]  b;
	reg 	    c_in;
	wire [15:0] sum;
	wire 	    c_out;

	integer i;

	csa_16bit uut (.a(a), .b(b), .c_in(c_in), .sum(sum), .c_out(c_out));

	initial begin
		$dumpfile ("csa16BitTB.vcd");
		$dumpvars (0, csa_16bit_tb);

		$display ("\nCSA 16-BIT\n");
		$monitor ("a=%b (%d), b=%b (%d), c_in=%b, sum=%b (%d), c_out=%b", a, a, b, b, c_in, sum, sum, c_out);

		for (i=0; i<8; i++) begin
			a = $urandom_range (0, 2**(16)-1);
			b = $urandom_range (0, 2**(16)-1);
			c_in = $random;
			#10;
		end

		#1;

		$display("\nSIM FIN");
		$finish;
	end

endmodule
