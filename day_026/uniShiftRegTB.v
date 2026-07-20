`timescale 1ns / 1ps

module universal_shift_reg_tb;

	// ------------------------
	// parameters
	parameter WIDTH = 4;

	// ------------------------
	// inputs
	reg  		clk_i;
	reg  		rst_n_i;
	reg  		wr_en_i;
	reg [1:0] 	sel_i;
	reg [WIDTH-1:0] p_data_i;
	reg 		s_left_i;
	reg 		s_right_i;

	// ------------------------
	// outputs
	wire 		 s_left_o;
	wire 		 s_right_o;
	wire [WIDTH-1:0] p_data_o;

	// ------------------------
	// other variables
	integer i;
	// string  monitor_var;  --- UNUSED BECAUSE ERROR: "PROPERTY IS NOT IMPLEMENTED"

	universal_shift_reg #(
		.WIDTH(WIDTH)
	) uut (
		.clk_i	   (clk_i),
		.rst_n_i   (rst_n_i),
		.wr_en_i   (wr_en_i),
		.sel_i	   (sel_i),
		.p_data_i  (p_data_i),
		.s_left_i  (s_left_i),
		.s_right_i (s_right_i),
		.s_left_o  (s_left_o),
		.s_right_o (s_right_o),
		.p_data_o  (p_data_o)
	);

	always begin
		#5 clk_i = ~clk_i;
	end

	initial begin
		$timeformat (-9, 0, "", 5);

		// monitor_var = $sformatf(" %%3t |    %%b    |    %%b    |  %%2b  |    %%4b   |     %%b    |     %%b     |    %%0%0db    |     %%b     |     %%b     ", WIDTH);

		$dumpfile ("uniShiftRegTB.vcd");
		$dumpvars (0, universal_shift_reg_tb);

		$display ("\nUNIVERSAL SHIFT REGISTER\n");
		$display (" time | rst_n_i | wr_en_i | sel_i | p_data_i | s_left_i | s_right_i | p_data_o | s_left_o | s_right_o ");
		$display ("------|---------|---------|-------|----------|----------|-----------|----------|----------|-----------");
		$monitor (" %3t  |    %b    |    %b    |  %2b   |   %4b   |     %b    |     %b     |   %4b   |     %b    |     %b    ",$time, rst_n_i, wr_en_i, sel_i, p_data_i, s_left_i, s_right_i, p_data_o, s_left_o, s_right_o);
		// $monitor (monitor_var, $time, rst_n_i, wr_en_i, sel_i, p_data_i, s_left_i, s_right_i, p_data_o, s_left_o, s_right_o);

		clk_i     = 1'b0;
		rst_n_i   = 1'b0;
		wr_en_i   = 1'b0;
		sel_i     = 2'bxx;
		p_data_i  = {WIDTH{1'b0}};
		s_left_i  = 1'b0;
		s_right_i = 1'b0;
	
		@(posedge clk_i);
		@(negedge clk_i);
		rst_n_i  = 1'b1;
		sel_i    = 2'b10;  // SHIFT_LEFT
		s_left_i = 1'b1;

		repeat(2) @(negedge clk_i);
		wr_en_i = 1'b1;

		for (i=0; i<2; i++) begin
			repeat(2) @(negedge clk_i);
			p_data_i = $urandom_range (0, 2**(WIDTH-1)-1);
			sel_i    = 2'b11;  // PARALLEL_LOAD
		end

		repeat(2) @(negedge clk_i);
		sel_i = 2'b01;  // SHIFT_RIGHT, keep s_right_i = 1'b0

		repeat(2) @(negedge clk_i);
		sel_i = 2'b00;  // DATA_HOLD

		@(negedge clk_i);
		#3;

		$display ("\nSIM FIN");
		$finish;
	end

endmodule
