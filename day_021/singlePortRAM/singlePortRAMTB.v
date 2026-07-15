`timescale 1ns / 1ps

module single_port_ram_tb;

	// -----------------------------------
	// parameters
	parameter WIDTH      = 16;
	parameter DEPTH      = 32;
	parameter ADDR_WIDTH = $clog2 (DEPTH);

	// ----------------------------
	// inputs
	reg 		     clk_i;
	reg 		     rst_n_i;
	reg 		     mode_i;
	reg [WIDTH-1:0]      wr_data_i;
	reg [ADDR_WIDTH-1:0] addr_i;

	// ----------------------------
	// outputs
	wire [WIDTH-1:0]     rd_data_o;

	// ---------------
	// other variables
	integer i;

	// --------------------------------------------
	// passing values to design module
	single_port_ram #(
		.WIDTH(WIDTH),
		.DEPTH(DEPTH),
		.ADDR_WIDTH(ADDR_WIDTH)
	) uut (
		.clk_i(clk_i),
		.rst_n_i(rst_n_i),
		.mode_i(mode_i),
		.wr_data_i(wr_data_i),
		.addr_i(addr_i),
		.rd_data_o(rd_data_o)
	);

	// -------------------------------
	// defining clock
	initial begin
		clk_i = 0;
		forever #5 clk_i = ~clk_i;
	end

	initial begin
		$dumpfile ("singlePortRAMTB.vcd");
		$dumpvars (0, single_port_ram_tb);

		$display ("\nSINGLE PORT RAM\n");
		$display (" mode_i |  addr_i | wr_data_i | rd_data_o ");
		$display ("--------|---------|-----------|-----------");
		$monitor ("   %b    |   %h    |    %h   |    %h   ", mode_i, addr_i, wr_data_i, rd_data_o);

		rst_n_i = 1'b0;			// zeros "read" output

		@(negedge clk_i);		
		mode_i = 1'b0;			// write mode
		addr_i = {ADDR_WIDTH{1'b0}};	// initial address

		// randomly generating values to pass as input to RAM
		for (i=0; i<33; i++) begin
			@(negedge clk_i);
			wr_data_i = $urandom_range (0, 2**(WIDTH-1)-1);
			addr_i    = i;
			#10;
		end

		rst_n_i = 1'b1;			// enables reading from RAM

		@(negedge clk_i);
		mode_i = 1'b1;			// read mode
		addr_i = {ADDR_WIDTH{1'b0}};	// reset address

		// start reading from RAM
		for (i=0; i<12; i++) begin
			@(negedge clk_i);
			addr_i = i;
			#10;
		end

		@(negedge clk_i);
		rst_n_i = 1'b0;
		#30;
		
		$display ("\nSIM FIN");
		$finish;
	end

endmodule
