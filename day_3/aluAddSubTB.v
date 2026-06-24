`timescale 1ns / 1ps

module alu_add_sub_tb;

	parameter WIDTH=4;

	reg [WIDTH-1:0]  a, b;
	reg 		 cb_in, mode;

	wire [WIDTH-1:0] sum;
	wire		 cb_out;

	reg [WIDTH-1:0] a_reg [3:0];
	reg [WIDTH-1:0] b_reg [3:0];
	reg [3:0] 	cb_in_reg;

	alu_add_sub uut #(
		.WIDTH(WIDTH)
	) (
		.a(a), .b(b), .cb_in(cb_in), .mode(mode),
		.sum(sum), .cb_out(cb_out)
	);

	initial begin
		$dumpfile ("aluAddSubTB.vcd");
		$dumpvars (0, alu_add_sub_tb);

		$display ("\n");
		$monitor ("a=%b, b=%b, cb_in=%b, sum=%b, cb_out=%b", a, b, cb_in, sum, cb_out);

		$display("mode=0 (ADD)");
		integer i;
		mode=1'b0;
		for (i=0; i<4; i=i+1) begin
			a = $urandom_range (0, 2**(WIDTH)-1);
			b = $urandom_range (0, 2**(WIDTH)-1);
			cb_in = $urandom_range (0, 1);

			a_reg[i] = a;
			b_reg[i] = b;
			cb_in_reg[i] = cb_in;

			#10;
		end

		$display ("\ntransitioning from ADD to SUB");
		mode=1'bx;

		$display("\nmode=1 (SUB)");
		integer i;
		mode=1'b1;
		for (i=0; i<4; i=i+1) begin
			a = a_reg[i];
			b = b_reg[i];
			cb_in = cb_in_reg[i];

			a_reg[i] = a;
			b_reg[i] = b;
			cb_in_reg[i] = cb_in;

			#10;
		end
	
		$finish;

endmodule		
