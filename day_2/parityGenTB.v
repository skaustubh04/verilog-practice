`timescale 1ns / 1ps

module parity_gen_tb;

	reg [3:0] data_in;
	reg parity_type;
	wire gen_parity;

	parity_gen uut (.data_in(data_in), .parity_type(parity_type), .gen_parity(gen_parity));

	initial begin
		$dumpfile("parityGenTB.vcd");
		$dumpvars(0, parity_gen_tb);

		$display("\n");
		$monitor("data_in=%b, gen_parity=%b", data_in, gen_parity);

		$display("parity_type=0 (EVEN PARITY)");
		parity_type=1'b0;
		data_in=4'b0000; #10;
		data_in=4'b0011; #10;
		data_in=4'b0110; #10;
		data_in=4'b1000; #10;

		$display("\nTransitioning to other parity");
		data_in=4'bxxxx; #10;

		$display("\nparity_type=1 (ODD PARITY)");
		parity_type=1'b1;
		data_in=4'b0000; #10;
		data_in=4'b0011; #10;
		data_in=4'b0110; #10;
		data_in=4'b1000; #10;

		$display("\n");
		$finish;
	end
endmodule
