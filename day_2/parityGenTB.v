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
		$monitor("parity_type=%b, data_in=%b, gen_parity=%b", parity_type, data_in, gen_parity);

		parity_type=1'b0;
		data_in=4'b0000; #10;
		data_in=4'b0011; #10;
		data_in=4'b0110; #10;
		data_in=4'b1000; #10;

		#20;

		parity_type=1'b1;
		data_in=4'b0000; #10;
		data_in=4'b0011; #10;
		data_in=4'b0110; #10;
		data_in=4'b1000; #10;

		$display("\n");
		$finish;
	end
endmodule
