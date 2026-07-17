`timescale 1ns / 1ps

module piso_serializer_tb;

	parameter WIDTH = 16;

	reg  		 clk_i;
	reg  		 rst_n_i;
	reg  		 wr_en_i;
	reg  [WIDTH-1:0] wr_data_i;

	wire 		 wr_valid_o;
	wire		 rd_data_o;

	integer i;

	piso_serializer #(
		.WIDTH(WIDTH)
	) uut (
		.clk_i(clk_i),
		.rst_n_i(rst_n_i),
		.wr_en_i(wr_en_i),
		.wr_data_i(wr_data_i),
		.wr_valid_o(wr_valid_o),
		.rd_data_o(rd_data_o)
	);

	initial begin
		clk_i = 0;
	end

	always #1 clk_i = ~clk_i;

	initial begin
		$dumpfile ("pisoSerializerTB.vcd");
		$dumpvars (0, piso_serializer_tb);

		$display ("\nPISO: SERIALIZER\n");
		$display (" rst_n_i | wr_en_i |   wr_data_i   | wr_valid_o | rd_data_o ");
		$display ("---------|---------|-----------|------------|-----------");
		$monitor ("    %b    |    %b    | %h |     %b     |     %b   ", rst_n_i, wr_en_i, wr_data_i, wr_valid_o, rd_data_o);

		rst_n_i = 1'b0;
		wr_data_i = {WIDTH{1'b0}};
		wr_en_i   = 1'b0;

		@(posedge clk_i);
		@(negedge clk_i);
		rst_n_i   = 1'b1;

		for (i=0; i<2; i++) begin
			@(negedge clk_i);
			wr_en_i   = 1'b1;
			wr_data_i = $urandom_range (0, 2**(WIDTH-1)-1);
			repeat(WIDTH) @(negedge clk_i);
		end

		@(posedge clk_i);
		#1;

		$display ("\nSIM FIN");
		$finish;
	end

endmodule
