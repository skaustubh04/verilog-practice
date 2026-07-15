/*
*
* This code preserves the logic such that the synthesizer
* chooses the BRAM over synthesizing flops, which are slower
* and take up more die-space, while also being slower and
* inefficient.
* A pin such as `rst_n_i` can't be used on the "RAM" here
* due to the way a BRAM is physically built.
*
* This is a design for Simple Dual-Port (SDP) RAM. It can
* only allow 1 operation from a port.
* In this design, port 'A' can only "write" to the RAM,
* while port 'B' can only be used for "reading" from
* the RAM.
* Oh, and the `rst_n_i` pin can be used here on the ports
* from which we can "read" data to clear the output ONLY.
* Only requirement is that it should not be used in the 
* `always @(...)` statement.
*
*/

`timescale 1ns / 1ps

module simple_dual_port_ram #(
	parameter WIDTH      = 16,			// this many bits per data entry to RAM
	parameter DEPTH      = 32,			// this many such entries of width `WIDTH`
	parameter ADDR_WIDTH = $clog2 (DEPTH)		// for addressing the slots in RAM
) (
	// -------------------------------------------------------------------------------------------
	// inputs
	input wire		    clk_i,
	input wire		    a_wr_en_i,		// separate write enable
	input wire		    b_rd_en_i,		// separate read enable
	input wire		    b_rst_n_i,		// active-low reset for "read" o/p
	input wire [WIDTH-1:0] 	    a_wr_data_i,	// data to be written to RAM
	input wire [ADDR_WIDTH-1:0] a_wr_addr_i,	// separate wire for "write" operation address
	input wire [ADDR_WIDTH-1:0] b_rd_addr_i,	// separate wire for "read" operation address
	// -------------------------------------------------------------------------------------------
	// outputs
	output reg [WIDTH-1:0] 	    b_rd_data_o		// data read from RAM
);

	// -----------------------------
	// defining the RAM
	reg [WIDTH-1:0] ram [0:DEPTH-1];

	// -------------------------------------------------------------
	// logic for read/write operation
	// -------------------------------------------------------------
	// Since this is a dual-port RAM, it will have different
	// conditions for handling both port 'A' and port 'B'
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	// port 'A' "write" logic
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	always @(posedge clk_i) begin
		if (a_wr_en_i) begin
			ram[a_wr_addr_i] <= a_wr_data_i;
		end
	end
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	// port 'B' "read" logic
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	always @(posedge clk_i) begin
		if (b_rd_en_i) begin
			if (!b_rst_n_i) begin
				b_rd_data_o <= {WIDTH{1'b0}};
			end
			else begin
				b_rd_data_o <= ram[b_rd_addr_i];
			end
		end
	end

endmodule
