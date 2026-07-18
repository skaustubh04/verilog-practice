`timescale 1ns / 1ps

module morse_code_tb;

	parameter WIDTH = 30;

	reg  clk_i;
	reg  rst_n_i;
	wire rd_data_o;

	morse_code #(
		.WIDTH(WIDTH)
	) uut (
		.clk_i(clk_i),
		.rst_n_i(rst_n_i),
		.rd_data_o(rd_data_o)
	);

	always begin
		#5 clk_i = ~clk_i;
	end

	initial begin
		$timeformat (-9, 0, "", 5);

		$dumpfile ("morseCodeTB.vcd");
		$dumpvars (0, morse_code_tb);

		$display ("\nMORSE CODE USING SHIFT REGISTER (SISO)\n");
		$display ("    time    | rst_n_i | rd_data_o ");
		$display ("------------|---------|-----------");
		$monitor (" %10t |    %b    |      %b     ", $time, rst_n_i, rd_data_o);

		clk_i   = 1'b0;
		rst_n_i = 1'b0;

		repeat(10) @(posedge clk_i);
		@(negedge clk_i);
		rst_n_i = 1'b1;

		wait(uut.shift_reg == 'b0);

		@(posedge clk_i);
		#100;

		$display ("\nSIM FIN");
		$finish;
	end

endmodule
