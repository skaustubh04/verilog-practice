/*
*
* This code preserves the logic such that the synthesizer
* chooses the BRAM over synthesizing flops, which are slower
* and take up more die-space, while also being slower and
* inefficient.
* A pin such as `rst_n_i` can't be used on the "RAM" here
* due to the way a BRAM is physically built.
*
* This is a design for True Dual-Port (TDP) RAM. It can
* allow 2 operations (r/w) from both ports.
* The `rst_n_i` pin can be used here on the ports
* from which we can "read" data to clear the output ONLY.
* Only requirement is that it should not be used in the 
* `always @(...)` statement.
*
* The reason for having shared address buses is also due
* to the physical layout of BRAM. It cannot have 4 address
* wires, that can cause violations by writing from 2 ports
* (which can be having different clock speeds) at the same
* address, which can happen at the same time. Or the o/p
* of the "read" operations can fetch different values due 
* to clocks being different.
*
*/

`timescale 1ns / 1ps

module true_dual_port_ram #(
	parameter WIDTH      = 16,		// width of each "write" data i/p and "read" data o/p
	parameter DEPTH      = 32,		// this many slots of width `WIDTH` inside RAM
	parameter ADDR_WIDTH = $clog2 (DEPTH)	// to point to the slots inside RAM
) (
	// ------------------------------------------------------------------------------------------
	// clock and reset
	input wire a_clk_i,	// clock for port 'A'
	input wire b_clk_i,	// clock for port 'B'
	input wire a_rst_n_i,	// active-low reset for port 'A'
	input wire b_rst_n_i,	// active-low reset for port 'B'
	// ------------------------------------------------------------------------------------------
	// port 'A'
	input wire 	            a_mode_i,		// write -> 0; read -> 1
	input wire [WIDTH-1:0]      a_wr_data_i,	// "write" data i/p
	input wire [ADDR_WIDTH-1:0] a_addr_i,		// shared address bus for "write" and "read"
	output reg [WIDTH-1:0]	    a_rd_data_o,	// "read" data o/p
	// ------------------------------------------------------------------------------------------
	// port 'B'
	input wire 		    b_mode_i,		// write -> 0; read -> 1
	input wire [WIDTH-1:0] 	    b_wr_data_i,        // "write" data i/p
	input wire [ADDR_WIDTH-1:0] b_addr_i,           // shared address bus for "write" and "read"
	output reg [WIDTH-1:0]      b_rd_data_o		// "read" data o/p
);

	// -----------------------------
	// defining the RAM
	reg [WIDTH-1:0] ram [0:DEPTH-1];

	// -----------------------------------------------------
	// port 'A' (R/W)
	// -----------------------------------------------------
	always @(posedge a_clk_i) begin
		if (!a_mode_i) begin
			ram[a_addr_i] <= a_wr_data_i;
		end
		else begin
			if (!a_rst_n_i) begin
				a_rd_data_o <= {WIDTH{1'b0}};
			end
			else begin
				a_rd_data_o <= ram[a_addr_i];
			end
		end
	end

	// -----------------------------------------------------
	// port 'B' (R/W)
	// -----------------------------------------------------
	always @(posedge b_clk_i) begin
		if (!b_mode_i) begin
			ram[b_addr_i] <= b_wr_data_i;
		end
		else begin
			if (!b_rst_n_i) begin
				b_rd_data_o <= {WIDTH{1'b0}};
			end
			else begin
				b_rd_data_o <= ram[b_addr_i];
			end
		end
	end

endmodule
