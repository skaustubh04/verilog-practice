`timescale 1ns / 1ps

module cla_tb;

	reg [3:0] a;
	reg [3:0] b;
	reg c_in;
	wire [3:0] sum;
	wire c_out;

	cla uut (.a(a), .b(b), .c_in(c_in), .sum(sum), .c_out(c_out));

	initial begin
		$dumpfile ("claTB.vcd");
		$dumpvars (0, cla_tb);

		$display ("\n");
		$monitor ("a=%b, b=%b, c_in=%b, sum=%b, c_out=%b", a, b, c_in, sum, c_out);

		a=4'b1010; b=4'b0101; c_in=1'b0; #10;
		a=4'b0110; b=4'b0101; c_in=1'b0; #10;
		a=4'b1000; b=4'b0100; c_in=1'b0; #10;
		a=4'b1111; b=4'b1111; c_in=1'b0; #10;
		a=4'b1010; b=4'b0101; c_in=1'b1; #10;
		a=4'b0110; b=4'b0101; c_in=1'b1; #10;
		a=4'b1000; b=4'b0100; c_in=1'b1; #10;
		a=4'b1111; b=4'b1111; c_in=1'b1; #10;

		$display ("\n");
		$finish;
	end
endmodule

