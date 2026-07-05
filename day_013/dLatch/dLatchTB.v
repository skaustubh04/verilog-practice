`timescale 1ns / 1ps

module d_latch_tb;

	reg  en;
	reg  d;
	wire q;

	d_latch uut (.en(en), .d(d), .q(q));

	initial begin
		$timeformat (-9, 0, "", 5);

		$dumpfile ("dLatchTB.vcd");
		$dumpvars (0, d_latch_tb);
		
		$display ("\nD LATCH\n");
		$display (" Time | en  | d | q ");
		$display ("------|-----|---|---");
		$monitor ("   %0t  |  %b  | %b | %b ", $time, en, d, q);

		en = 1'b0; d = 1'bx; #1;
		en = 1'b1; d = 1'b0; #1;
		en = 1'b0; d = 1'bx; #1;
		en = 1'b1; d = 1'b1; #1;
		en = 1'b0; d = 1'bx; #1;

		#1;

		$display ("\nSIM FIN");
		$finish;
	end

endmodule
