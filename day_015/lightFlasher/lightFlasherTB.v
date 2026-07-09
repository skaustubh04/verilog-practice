`timescale 1ns / 1ps

module light_flasher_tb;

	reg  clk;
	reg  rst;
	reg  flash_req;
	wire light_out;

	light_flasher uut (
		.clk(clk),
		.rst(rst),
		.flash_req(flash_req),
		.light_out(light_out)
	);

	initial begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	initial begin
		$timeformat (-9, 0, "", 5);

		$dumpfile ("lightFlasherTB.vcd");
		$dumpvars (0, light_flasher_tb);

		$display ("\nLIGHT FLASHER: FACTORED FSM\n");
		$monitor ("Time=%0t, rst=%b, flash_req=%b, light_out=%b", $time, rst, flash_req, light_out);

		rst       = 1'b1;
		flash_req = 1'bx;

		@(negedge clk);
		rst       = 1'b0;
		flash_req = 1'b1;

		@(posedge clk);
		#60;
		$display ("\nSIM FIN");
		$finish;
	end

endmodule
