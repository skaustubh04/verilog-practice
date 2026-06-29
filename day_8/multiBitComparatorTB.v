`timescale 1ns / 1ps

module multi_bit_comparator_tb;

	parameter WIDTH = 4;

	reg [WIDTH-1:0] a;
	reg [WIDTH-1:0] b;
	wire a_great_b;
	wire a_equal_b;
	wire a_less_b;

	integer i;

	multi_bit_comparator #(.WIDTH(WIDTH)) uut (.a(a), .b(b), .a_great_b(a_great_b), .a_equal_b(a_equal_b), .a_less_b(a_less_b));

	initial begin
		$dumpfile ("multiBitComparatorTB.vcd");
		$dumpvars (0, multi_bit_comparator_tb);

		$display ("\n");
		$monitor ("a=%b, b=%b, a_great_b=%b, a_equal_b=%b, a_less_b=%b", a, b, a_great_b, a_equal_b, a_less_b);

		for (i=0; i<4; i++) begin
			a = $urandom_range (0, 2**(WIDTH)-1);
			b = $urandom_range (0, 2**(WIDTH)-1);
			#10;
		end

		$display ("\n");
		$finish;
	end

endmodule
