`timescale 1ns / 1ps

module dual_port_rom #(
	// parameters
	parameter WIDTH      = 32,
	parameter DEPTH      = 16,
	parameter ADDR_WIDTH = (DEPTH > 1) ? $clog2(DEPTH) : 1,
	parameter INIT_FILE  = "rom_init.mem"
) (
	// -------------------------------------
	// clocks
	input wire a_clk_i,
	input wire b_clk_i,
	// -------------------------------------
	// inputs
	input wire 	       	    a_rd_en_i,
	input wire 	      	    b_rd_en_i,
	input wire [ADDR_WIDTH-1:0] a_rd_addr_i,
	input wire [ADDR_WIDTH-1:0] b_rd_addr_i,
	// -------------------------------------
	// outputs
	output reg [WIDTH-1:0] 	    a_rd_data_o,
	output reg [WIDTH-1:0] 	    b_rd_data_o
);

	// -----------------------------
	// defining ROM
	reg [WIDTH-1:0] rom [0:DEPTH-1];
	
	// ---------------------------------------------
	// reading the hex file (initialzing ROM)
	// ---------------------------------------------
	initial begin
		$readmemh (INIT_FILE, rom);
	end

	// ---------------------------------------------
	// read logic for port 'A'
	// ---------------------------------------------
	always @(posedge a_clk_i) begin
		if (a_rd_en_i) begin
			a_rd_data_o <= rom[a_rd_addr_i];
		end
	end

	// ---------------------------------------------
	// read logic for port 'B'
	// ---------------------------------------------
	always @(posedge b_clk_i) begin
		if (b_rd_en_i) begin
			b_rd_data_o <= rom[b_rd_addr_i];
		end
	end

endmodule
