`timescale 1ns / 1ps

module d_flip_flop_tb;

	reg  clk;
	reg  rst;
	reg  d;
	wire q;

	d_flip_flop uut (.clk(clk), .rst(rst), .d(d), .q(q));

	initial begin
		clk = 0;
		forever #0.5 clk = ~clk;
	end

	initial begin	
		$timeformat (-9, 1, "", 5);

		$dumpfile ("dFlipFlopTB.vcd");
		$dumpvars (0, d_flip_flop_tb);

		$display ("\nD FLIP-FLOP\n");
		$display (" Time | rst | d | q ");
		$display ("------|-----|---|---");
		$monitor ("  %0t |  %b  | %b | %b ", $realtime, rst, d, q);

		rst = 1'b1; #0.7;
		rst = 1'b0; #0.3;

		d = 1'b0; #1;
		d = 1'b1; #1;

		rst = 1'b1; #1;

		#1;

		$display ("\nSIM FIN");
		$finish;
	end

endmodule
