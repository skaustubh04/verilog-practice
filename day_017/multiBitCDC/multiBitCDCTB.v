`timescale 1ns / 1ps

module multi_bit_cdc_tb;

	parameter WIDTH = 32;
	parameter DEPTH = 16;

	reg  wr_clk_i;
	reg  rd_clk_i;
	reg  wr_rst_n_i;
	reg  rd_rst_n_i;
	reg  wr_en_i;
	reg  rd_en_i;
	reg [WIDTH-1:0] wr_data_i;

	wire full_o;
	wire empty_o;
	wire [WIDTH-1:0] rd_data_o;

	integer i;
	integer j;

	multi_bit_cdc #(
		.WIDTH(WIDTH), .DEPTH(DEPTH)
	) uut (
		.wr_clk_i(wr_clk_i), 	 .rd_clk_i(rd_clk_i),
		.wr_rst_n_i(wr_rst_n_i), .rd_rst_n_i(rd_rst_n_i),
		.wr_en_i(wr_en_i), 	 .wr_data_i(wr_data_i),
		.full_o(full_o), 	 .rd_en_i(rd_en_i),
		.rd_data_o(rd_data_o), 	 .empty_o(empty_o)
	);

	initial begin
		wr_clk_i = 0;
		forever #1 wr_clk_i = ~wr_clk_i;
	end

	initial begin
		rd_clk_i = 0;
		forever #1.5 rd_clk_i = ~rd_clk_i;
	end

	initial begin
		$dumpfile ("multiBitCDCTB.vcd");
		$dumpvars (0, multi_bit_cdc_tb);

		$display ("\nMULTI BIT CDC (OPEN LOOP CONFIG)\n");
		$display (" wr_rst_n | rd_rst_n | wr_en | rd_en | empty | full | wr_data  | rd_data ");
		$display ("----------|----------|-------|-------|-------|------|----------|----------");
		$monitor ("     %b    |     %b    |   %b   |   %b   |   %b   |   %b  | %8h | %8h ", wr_rst_n_i, rd_rst_n_i, wr_en_i, rd_en_i, empty_o, full_o, wr_data_i, rd_data_o);

		wr_rst_n_i = 1'b0;
		rd_rst_n_i = 1'b0;
		wr_en_i    = 1'b0;
		rd_en_i    = 1'b0;
		wr_data_i  = 'b0;

		@(negedge wr_clk_i);
		wr_rst_n_i = 1'b1;
		rd_rst_n_i = 1'b1;

		// -----------------------------------------------------------------------------
		// separating clock domains to avoid any irl hardware violations
		// -----------------------------------------------------------------------------
		fork
			// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			// wr_clk_i controlled domain
			// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			begin
				@(negedge wr_clk_i);
				wr_en_i = 1'b0;

				for (i=0; i<5; i++) begin
					@(posedge wr_clk_i);
					for (j=0; j<4; j++) begin
						repeat(2) @(negedge wr_clk_i);
						wr_data_i = $urandom_range (0, 2**(WIDTH-1)-1);

						if (j==0 & i==1) wr_en_i = 1'b1;
						if (j==3 & i==2) wr_en_i = 1'b0;
						if (j==2 & i==3) wr_en_i = 1'b1;
					end
				end
			end
	
			// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			// rd_clk_i controlled domain
			// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			begin
				repeat(4) @(negedge rd_clk_i);
				rd_en_i = 1'b1;

				repeat(30) @(negedge rd_clk_i);
				wr_en_i = 1'b0;

				repeat(5) @(negedge rd_clk_i);
				rd_en_i = 1'b0;
			end
		join	// this joined these 2 things such that they happen simultaneously

		$display ("\nSIM FIN");
		$finish;
	end

endmodule

