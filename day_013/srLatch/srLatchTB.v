`timescale 1ns / 1ps

module sr_latch_tb;

	reg  s;
	reg  r;
	wire q;
	wire q_bar;

	integer i;

	sr_latch uut (.s(s), .r(r), .q(q), .q_bar(q_bar));

	initial begin
		$timeformat (-9, 0, "", 5);

		s = 1'b0;
		r = 1'b0;

		$dumpfile ("srLatchTB.vcd");
		$dumpvars (1, uut);

		$display ("\nSR LATCH\n");
		$display (" Time | s | r | q | q_bar");
		$display ("------|---|---|---|------");
		$monitor ("   %0t  | %b | %b | %b |  %b ", $time, s, r, q, q_bar);

		// looped twice to show output of 
		// first case when {q,q_bar} =/= 2'bxx
		for (i=0; i<2; i++) begin
			s=1'b0; r=1'b0; #1;
			s=1'b0; r=1'b1; #1;
			s=1'b1; r=1'b0; #1;
			s=1'b1; r=1'b1; #1;
		end

		#1;

		$display ("\nSIM FIN");
		$finish;
	end

endmodule
