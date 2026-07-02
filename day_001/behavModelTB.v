`timescale 1ns / 1ps

// testbench code for basic logic gates

module behavioural_modelling_tb;

	reg a, b;
	wire nand_g, nor_g, xnor_g;

	behavioural_modelling uut (a, b, nand_g, nor_g, xnor_g);

	initial begin
		$dumpfile("behavModelTB.vcd");			// specified dumpfile
		$dumpvars(0, behavioural_modelling_tb);		// dumping all vars to dumpfile

		$display("\n");
		$monitor("a = %b, b = %b, nand_g = %b, nor_g = %b, xnor_g = %b", a, b, nand_g, nor_g, xnor_g);
		#10;
		a=1'b0; b=1'b0; #10;
		a=1'b0; b=1'b1; #10;
		a=1'b1; b=1'b0; #10;
		a=1'b1; b=1'b1; #10;

		$display("\n");
		$finish;

	end

endmodule
