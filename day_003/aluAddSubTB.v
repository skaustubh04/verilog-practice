`timescale 1ns / 1ps

module alu_add_sub_tb;

	parameter WIDTH = 4;

	reg [WIDTH-1:0]  a, b;
	reg 		 cb_in, mode;

	wire [WIDTH-1:0] sum;
	wire		 cb_out;

	// variables not part of the uut
	reg [WIDTH-1:0] a_reg [3:0];
	reg [WIDTH-1:0] b_reg [3:0];
	reg [3:0] 	cb_in_reg;

	integer i;						// used in for-loop

	// parameterized uut
	alu_add_sub #(
		.WIDTH(WIDTH)
	) uut (
		.a(a), .b(b), .cb_in(cb_in), .mode(mode),
		.sum(sum), .cb_out(cb_out)
	);

	// passing values
	initial begin
		$dumpfile ("aluAddSubTB.vcd");			// dumpfile which will hold output
		$dumpvars (0, alu_add_sub_tb);			// variables from this file

		$display ("\n");
		$monitor ("a=%b, b=%b, cb_in=%b, sum=%b, cb_out=%b", a, b, cb_in, sum, cb_out);	// monitoring these variables

		$display ("mode=0 (ADD)");
		mode=1'b0;					// setting 'mode' as '0' -> ADD
		for (i=0; i<4; i=i+1) begin
			a = $urandom_range (0, 2**(WIDTH)-1);	// random 4-bit number, range: (0, 15)
			b = $urandom_range (0, 2**(WIDTH)-1);	// random 4-bit number, range: (0, 15)
			cb_in = $urandom_range (0, 1);		// random 1-bit number, range: (0, 1)

			a_reg[i] = a;				// storing these values to...
			b_reg[i] = b;				// ...compare with SUB later
			cb_in_reg[i] = cb_in;

			#10;
		end

		$display ("\nTransitioning from ADD to SUB");
		mode =  1'bx; 					// unknown value while transitioning
		a = {WIDTH{1'bx}};				// assign 1'bx, 'WIDTH' amount of times
		b = {WIDTH{1'bx}};				// assign 1'bx, 'WIDTH' amount of times
		cb_in = 1'bx;
		#10;
		
		$display ("\nmode=1 (SUB)");
		mode=1'b1;					// setting 'mode' as '1' -> SUB
		for (i=0; i<4; i=i+1) begin
			a = a_reg[i];				// using the previously stored values...
			b = b_reg[i];				// ...so that comparison is easier
			cb_in = cb_in_reg[i];
			
			#10;
		end
	
		$display ("\n");
		$finish;
	end

endmodule		
