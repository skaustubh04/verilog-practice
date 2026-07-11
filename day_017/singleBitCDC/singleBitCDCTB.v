`timescale 1ns / 1ps

module single_bit_cdc_tb;

	reg  clk_a;
	reg  clk_b;
	reg  rst_n;
	reg  a;
	wire y;

	integer i;

	single_bit_cdc uut (
		.clk_a(clk_a), .clk_b(clk_b),
		.rst_n(rst_n), .a(a), .y(y)
	);

	initial begin
		clk_a = 0;
		forever #1 clk_a = ~clk_a;
	end

	initial begin
		clk_b = 0;
		forever #1.5 clk_b = ~clk_b;
	end

	initial begin
		$dumpfile ("singleBitCDCTB.vcd");
		$dumpvars (0, single_bit_cdc_tb);

		$display ("\nSINGLE BIT CDC (OPEN LOOP CONFIG)\n");
		$display (" a | y ");
		$display ("---|---");
		$monitor (" %b | %b ", a, y);

		rst_n = 1'b0;
		a     = 1'bx;

		for (i=0; i<5; i++) begin
			@(negedge clk_a);
			rst_n = 1'b1;
			a     = 1'b0;
	
			@(posedge clk_a);
			repeat(2) @(negedge clk_a);
			a = 1'b1;
	
			repeat(4) @(negedge clk_a);
		end

		$display ("\nSIM FIN");
		$finish;
	end

endmodule
