`timescale 1ns / 1ps

module single_port_rom #(
	parameter WIDTH      = 32,
	parameter DEPTH      = 16,
	parameter ADDR_WIDTH = (DEPTH > 1) ? $clog2(DEPTH) : 1,
	parameter INIT_FILE  = "rom_init.mem"
) (
	// ----------------------------------------------------------
	// clock
	input wire 		    clk_i,
	// ----------------------------------------------------------
	// inputs
	input wire                  rd_en_i,	// read-enable
	input wire [ADDR_WIDTH-1:0] rd_addr_i,	// ROM address as i/p
	// ----------------------------------------------------------
	// output
	output reg [WIDTH-1:0]      rd_data_o	// o/p read from ROM
);

	// -----------------------------
	// defining ROM
	reg [WIDTH-1:0] rom [0:DEPTH-1]; 

	// -------------------------------------------------------------------------
	// reading the hex file (so that ROM has some data)
	// -------------------------------------------------------------------------
	initial begin
		$readmemh(INIT_FILE, rom);
	end

	// -------------------------------------------------------------------------
	// reading from the ROM
	// -------------------------------------------------------------------------
	always @(posedge clk_i) begin
		if (rd_en_i) begin
			rd_data_o <= rom[rd_addr_i];
		end
	end

endmodule
