`timescale 1ns / 1ps

module consolidate_cdc_tb;

	// --------------------------------
	// defining the parameters for FIFO
	parameter WIDTH = 32;
	parameter DEPTH = 16;

	// -----------------------
	// the inputs
	// - - - - - - - - - - - -
	// clock domain 'A'
	reg a_clk_i;
	reg a_rst_n_i;
	reg a_lden;
	// - - - - - - - - - - - -
	// clock domain 'B'
	reg 		b_clk_i;
	reg 		b_rst_n_i;
	reg 		rd_en_i;
	reg [WIDTH-1:0] wr_data_i;

	// ------------------------
	// the outputs
	// - - - - - - - - - - - - 
	// clock domain 'B'
	wire 		 full_o;
	wire 		 empty_o;
	wire [WIDTH-1:0] rd_data_o;

	// -----------------------------------------
	// other variables for convenient simulation
	integer i;
	integer j;

	// ---------------------------------------------------
	// passing variables to unit under test
	consolidate_cdc #(
		.WIDTH(WIDTH), .DEPTH(DEPTH)
	) uut (
		.a_clk_i(a_clk_i), 	.a_rst_n_i(a_rst_n_i),
		.a_lden(a_lden),	.b_clk_i(b_clk_i),
		.b_rst_n_i(b_rst_n_i),	.rd_en_i(rd_en_i),
		.wr_data_i(wr_data_i),	.full_o(full_o),
		.empty_o(empty_o),	.rd_data_o(rd_data_o)
	);

	// -----------------------------------
	// defining clock for domain 'A'
	initial begin
		a_clk_i = 0;
		forever #1 a_clk_i = ~a_clk_i;
	end

	// -------------------------------------
	// defining clock for domain 'B'
	initial begin
		b_clk_i = 0;
		forever #1.5 b_clk_i = ~b_clk_i;
	end

	initial begin
		$dumpfile ("consolidateCDCTB.vcd");
		$dumpvars (0, consolidate_cdc_tb);

		$display ("\nCDC BY CONSOLIDATING SIMULTANEOUSLY REQUIRED SIGNALS\n");
		$display (" a_rst_n | b_rst_n | a_lden | rd_en | empty | full | wr_data  | rd_data ");
		$display ("---------|---------|--------|-------|-------|------|---------|---------");
		$monitor ("    %b    |    %b    |    %b   |   %b   |   %b   |   %b   | %8h | %8h ", a_rst_n_i, b_rst_n_i, a_lden, rd_en_i, empty_o, full_o, wr_data_i, rd_data_o);

		// initial state
		a_rst_n_i = 1'b0;
		b_rst_n_i = 1'b0;
		a_lden	  = 1'b0;
		rd_en_i	  = 1'b0;
		wr_data_i = 'b0;

		// at first negative edge of `a_clk_i`, deassert reset pins
		@(negedge a_clk_i);
		a_rst_n_i = 1'b1;
		b_rst_n_i = 1'b1;

		// ------------------------------------------------------------------------
		// separating clock domains to avoid any irl hardware voilations
		// ------------------------------------------------------------------------
		fork
			// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			// clock domain 'A'
			// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			begin
				repeat(25) begin
					@(negedge a_clk_i);
					a_lden = 1'b1;

					repeat(2) @(posedge a_clk_i);
					a_lden = 1'b0;
				end
			end

			// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			// clock domain 'B'
			// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
			begin
				repeat(4) @(negedge b_clk_i);

				for (i=0; i<4; i++) begin
					@(posedge b_clk_i);
					for (j=0; j<5; j++) begin
						@(negedge b_clk_i);
						wr_data_i = $urandom_range (0, 2**(WIDTH-1)-1);
					end

					if (i == 1) rd_en_i = 1'b1;
				end

				repeat(8) @(negedge b_clk_i);
				rd_en_i = 1'b0;
			end
		join	// this joins these 2 domains without causing violations (different clocks)

		$display ("\nSIM FIN");
		$finish;
	end

endmodule
