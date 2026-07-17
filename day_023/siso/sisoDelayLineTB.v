`timescale 1ns / 1ps

module siso_delay_line_tb;

	// ------------------
	// shift reg size
	parameter WIDTH = 16;

	// ------------
	// i/ps & o/ps
	reg  clk_i;
	reg  rst_n_i;
	reg  wr_data_i;
	wire rd_data_o;

	// ---------------
	// other variables
	integer i;
	
	siso_delay_line #(
		.WIDTH(WIDTH)
	) uut (
		.clk_i(clk_i),
		.rst_n_i(rst_n_i),
		.wr_data_i(wr_data_i),
		.rd_data_o(rd_data_o)
	);

	initial begin
		clk_i = 0;
		forever #1 clk_i = ~clk_i;
	end

	initial begin
		$dumpfile ("sisoDelayLineTB.vcd");
		$dumpvars (0, siso_delay_line_tb);

		$display ("\nSISO: DELAY LINE\n");
		$display (" rst_n_i | wr_data_i | rd_data_o ");
		$display ("---------|-----------|-----------");
		$monitor ("    %b    |     %b     |     %b  ", rst_n_i, wr_data_i, rd_data_o);

		rst_n_i   = 1'b0;
		wr_data_i = 1'b0;

		@(posedge clk_i);
		@(negedge clk_i);
		rst_n_i = 1'b1;

		for (i=0; i<32; i++) begin
			@(negedge clk_i);
			wr_data_i = $urandom_range(0, 1);
		end
		
		@(posedge clk_i);
		#1;	// ends but shows output of last i/p
		
		$display ("\nSIM FIN");
		$finish;
	end

endmodule
