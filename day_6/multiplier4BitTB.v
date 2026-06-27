`timescale 1ns / 1ps

module multiplier_4bit_tb;

	reg [3:0]  a;
	reg [3:0]  b;
	wire [7:0] p;
	
	integer i;

	multiplier_4bit uut (.a(a), .b(b), .p(p));

	initial begin
		$dumpfile ("multiplier4BitTB.vcd");
		$dumpvars (0, multiplier_4bit_tb);

		$display ("\n");
		$monitor ("a=%b, b=%b, p=%b (%b)", a, b, p, p);

		for (i=0; i<8; i+=1) begin
			a = $urandom_range (0, 15);
			b = $urandom_range (0, 15);
			#10;
		end

		$display ("\n");
		$finish;
	end

endmodule

