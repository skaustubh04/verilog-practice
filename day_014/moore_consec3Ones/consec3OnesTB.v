// TESTBENCH FOR
// CONSECUTIVE 3 ONES DETECTING MEALY MACHINE (OVERLAPPING)

`timescale 1ns / 1ps

module consec_3_ones_tb;

	reg  clk;
	reg  rst;
	reg  bitstream;
	wire y;

	reg [9:0] pattern;
	integer i;

	consec_3_ones uut (.clk(clk), .rst(rst), .bitstream(bitstream), .y(y));

	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	initial begin
		$timeformat (-9, 0, "", 5);
		pattern = 10'b01_1001_1110;

		$dumpfile ("consec3OnesTB.vcd");
		$dumpvars (0, consec_3_ones_tb);

		$display ("\nCONSECUTIVE 3 ONES DETECTING MOORE MACHINE (OVERLAPPING)\n");
		$monitor ("Time=%0t, rst=%b, bitstream=%b, y=%b", $time, rst, bitstream, y);

		rst = 1'b1;
		bitstream = 1'b0;

		@(negedge clk);
		rst = 1'b0;

		for (i=9; i>=0; i--) begin
			@(posedge clk);
			bitstream <= pattern[i];
		end

		@(posedge clk);
		#1;
		$display ("\nSIM FIN");
		$finish;
	end

endmodule
