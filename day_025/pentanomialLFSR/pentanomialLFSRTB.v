`timescale 1ns / 1ps

module pentanomial_lfsr_tb;

	reg  	    clk_i;
	reg  	    rst_n_i;
	wire [15:0] lfsr_o;

	pentanomial_lfsr uut (
		.clk_i(clk_i),
		.rst_n_i(rst_n_i),
		.lfsr_o(lfsr_o)
	);

	always begin
		#5 clk_i = ~clk_i;
	end

	initial begin
		$timeformat (-9, 0, "", 5);

		$dumpfile ("pentanomialLFSRTB.vcd");
		$dumpvars (0, pentanomial_lfsr_tb);

		$display ("\nPENTANOMIAL LFSR");
		$display ("CHARACTERISTIC POLYNOMIAL: x^16 + x^10 + x^7 + x^4 + 1\n");

		$display (" time | rst_n_i |     lfsr_o      ");
		$display ("------|---------|-----------------");
		$monitor ("  %3t |    %b    | %16b        ", $time, rst_n_i, lfsr_o);

		clk_i   = 1'b0;
		rst_n_i = 1'b0;

		@(posedge clk_i);
		@(negedge clk_i);
		rst_n_i = 1'b1;

		repeat(30) @(negedge clk_i);
		#3;

		$display ("\nSIM FIN");
		$finish;
	end

endmodule
