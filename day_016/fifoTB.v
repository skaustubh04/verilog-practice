`timescale 1ns / 1ps

module fifo_tb;

	// ----------------------------------------------------------------------------------
	// parameters for memory
	parameter WIDTH = 32;
	parameter DEPTH = 16;

	// ----------------------------------------------------------------------------------
	// clock & reset
	reg clk;
	reg rst_n_i;

	// ----------------------------------------------------------------------------------
	// write
	reg 		 wr_en_i;
	reg  [WIDTH-1:0] wr_data_i;
	wire 		 full_o;

	// ----------------------------------------------------------------------------------
	// read
	reg 		 rd_en_i;
	wire [WIDTH-1:0] rd_data_o;
	wire 		 empty_o;
	
	// ----------------------------------------------------------------------------------
	// required variables
	// reg [WIDTH-1:0] pattern;	// used for `wr_data_i`
	integer i;

	// ----------------------------------------------------------------------------------
	// the UUT
	fifo #(
		.WIDTH(WIDTH),
		.DEPTH(DEPTH)
	) uut (
		.clk_i(clk),
		.rst_n_i(rst_n_i),
		.wr_en_i(wr_en_i),
		.wr_data_i(wr_data_i),
		.full_o(full_o),
		.rd_en_i(rd_en_i),
		.rd_data_o(rd_data_o),
		.empty_o(empty_o)
	);

	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	initial begin
		$timeformat (-9, 0, "", 5);

		$dumpfile ("fifoTB.vcd");
		$dumpvars (0, fifo_tb);

		$display ("\nFIFO - WRITE & READ WITH SAME CLOCK\n");
		$display (" Time | rst_n | wr_en |   wr_data   | rd_en |   rd_data   | full | empty ");
		$display ("------|-------|-------|-------------|-------|-------------|------|-------");
		$monitor ("   %0t  |   %b   |   %b   |  %0h   |   %b   |  %0h   |   %b  |   %b  ", $time, rst_n_i, wr_en_i, wr_data_i, rd_en_i, rd_data_o, full_o, empty_o);

		rst_n_i = 1'b0;
		wr_data_i = {WIDTH{1'bx}};

		@(negedge clk);
		rst_n_i   = 1'b1;
		wr_data_i = $urandom_range (0, 2**(WIDTH)-1);
		wr_en_i   = 1'b0;
		rd_en_i   = 1'b0;
		
		repeat(2) @(negedge clk);
		rd_en_i = 1'b1;

		repeat(2) @(negedge clk);
		rd_en_i = 1'b0;
		wr_en_i = 1'b1;

		repeat(2) @(negedge clk);
		wr_en_i = 1'b0;

		for (i=0; i<10; i++) begin
			@(negedge clk);
			wr_data_i = $urandom_range (0, 2**(WIDTH)-1);

			if (i == 3) wr_en_i = 1'b1;

			if (i == 7) rd_en_i = 1'b1;
		end

		repeat(5) @(negedge clk);
		rd_en_i = 1'b0;

		@(posedge clk);
		@(negedge clk);
		$display ("\nSIM FIN");
		$finish;
	end

endmodule
