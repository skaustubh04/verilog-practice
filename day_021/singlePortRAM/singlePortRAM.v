/*
*
* This code preserves the logic such that the synthesizer
* chooses the BRAM over synthesizing flops, which are slower
* and take up more die-sapce.
* BRAMs are instead more densely packed grid of static
* memory, and the code written below has only the operations
* supported by BRAM (such that the synthesizer picks it over
* some flops).
* The thing which makes them mistake it for a LUT or flops is
* the `rst_n_i` (which is usually included in most of my other
* rtl designs). This design has to avoid it so that the 
* synthesizer infers it correctly, otherwise if flops are chosen,
* the actual performance will be affected as flops are slower.
*
*/

`timescale 1ns / 1ps

module single_port_ram #(
	parameter WIDTH = 16,			// width of each `wr_data_i`
	parameter DEPTH = 32,			// depth of RAM (this many slots of width `WIDTH`)
	parameter ADDR_WIDTH = $clog2 (DEPTH)	// for addressing the slots in RAM
) (
	// -------------------------------------------------------------
	// inputs
	input wire 	       	    clk_i,
	input wire 		    rst_n_i,	// active-low reset
	input wire [WIDTH-1:0] 	    wr_data_i,	// i/p data to RAM
	input wire 	       	    mode_i,	// write -> 0; read -> 1
	input wire [ADDR_WIDTH-1:0] addr_i,	// shared address bus

	// -------------------------------------------------------------
	// outputs
	output reg [WIDTH-1:0] rd_data_o
);

	// -----------------------------
	// defining the RAM
	reg [WIDTH-1:0] ram [0:DEPTH-1];

	// ----------------------------------------------
	// logic for read/write from/to the RAM
	// ----------------------------------------------
	always @(posedge clk_i) begin
		if (!mode_i) begin
			ram[addr_i] <= wr_data_i;
		end
		else begin
			if (!rst_n_i) begin
				rd_data_o <= {WIDTH{1'b0}};
			end
			else begin
				rd_data_o <= ram[addr_i];
			end
		end
	end

endmodule

