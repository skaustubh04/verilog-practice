/*
*
* TWO SIMULTANEOUSLY REQUIRED SIGNALS - CONSOLIDATING THE SIGNALS TO AVOID
* MISMATCH DURING CDC (USING TOGGLE SYNCHRONIZER, OPEN-LOOP CONFIGURATION)
* 
* THE DESIGN IS AS FOLLOWS:
*	* Clock domain 'A' will be used to only send the 'ld' and 'en' signals
*	  to the FIFO. The rest will be handled by the clock in domain 'B'.
*	* The FIFO requires 2 signals to be simultaneously HIGH for the data
*	  to be written to the FIFO. These inputs are 'wr_ld_i' and 'wr_en_i'.
*	* The data to be written to the FIFO, along with all other functions
*	  will be handled in clock domain 'B'.
*	* To handle this, and avoid any unintentional skew which might occur
*	  on any of the 2 signals, the signal which is sent from domain 'A'
*	  will be a single signal which will be synchrnoized using `toggle
*	  synchrnoizer` for clock domain crossing, and then that same signal
*	  will be sent to both 'ld' and 'en' inputs of the FIFO.
*
* DESIGN SPECIFICATIONS:
*	* clock domain 'A' operates at higher frequency than clock domain 'B'
*	* The data will be 4 bytes wide.
*	* The FIFO has a depth of 16.
*	* FIFO inputs and output:
*		* INPUTS ---
*			* clk_i	    ... (this will be fulfilled by `b_clk_i`)
*			* rst_n_i   ... (this will be fulfilled by `b_rst_n_i`)
*			* wr_ld_i   ... (this will be output of dual-f/fs)
*			* wr_en_i   ... (this will be output of dual-f/fs)
*			* wr_data_i
*			* rd_en_i
*		* OUTPUTS ---
*			* rd_data_o
*			* full_o
*			* empty_o
*
*/

`timescale 1ns / 1ps

module consolidate_cdc #(
	// ------------------------------------------------------------------------------
	// data and FIFO parameters
	parameter WIDTH = 32,
	parameter DEPTH = 16
) (
	// ------------------------------------------------------------------------------
	// clock and reset
	input wire a_clk_i,	// clock for domain 'A'
	input wire b_clk_i,	// clock for domain 'B'
	input wire a_rst_n_i,	// active-low reset for domain 'A'
	input wire b_rst_n_i,	// active-low reset for domain 'B'

	// ------------------------------------------------------------------------------
	// clock domain 'A'
	input wire a_lden,	// 'lden' signal coming from domain 'A'
	// This signal will drive both `wr_en_i` and `wr_ld_i` on the FIFO

	// ------------------------------------------------------------------------------
	// clock domain 'B'
	input wire [WIDTH-1:0] wr_data_i,	// 4-byte long data to be written to FIFO
	input wire 	       rd_en_i,		// signal to enable reading from FIFO
	output wire	       full_o,		// flag to indicate whether FIFO is full
	output wire 	       empty_o,		// flag to indicate whether FIFO is empty
	output reg [WIDTH-1:0] rd_data_o	// 4-byte long data read from FIFO
);

	// ------------------------------------------------------
	// for the pointers to be able to address the FIFO memory
	localparam ADDR_WIDTH = $clog2 (DEPTH);

	// ----------------------------------------------------
	// read and write pointers
	reg [ADDR_WIDTH-1:0] wr_ptr;	// binary write pointer
	reg [ADDR_WIDTH-1:0] rd_ptr;	// binary read pointer

	// --------------------------------
	// memory
	reg [WIDTH-1:0] memory [0:DEPTH-1];

	// ----------------------------------------------------------------------
	// i/ps & o/ps of flops, and connected elements (mux, xor gate) - for CDC
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// clock domain 'A'
	reg 	   a_lden_q;	// o/p of flop in domain 'A'
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// clock domain 'B'
	reg  b1_lden_q;	// o/p of 1st flop in domain 'B'
	reg  b2_lden_q;	// o/p of 2nd flop in domain 'B'
	reg  b3_lden_q; // o/p of 3rd flop in domain 'B'
	wire lden_sync;	// o/p of xor gate
	wire wr_ld_i;	// i/p to FIFO
	wire wr_en_i;	// i/p to FIFO

	// -----------------------------------------------------
	// flag to check which operation happened last
	reg last_operation_flag;	// write -> 0; read -> 1

	// --------------------------------------------------------------------------------------
	// toggle synchronizer
	// --------------------------------------------------------------------------------------
	// it is better to use this synchronizer in place of dual-f/f
	// synchronizer as there is possibility of failure in capturing
	// data when moving data from fast clock domain to slower clock
	// domain. The flop is controlled by domain B's clock.
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// clock domain 'A'
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// this side uses 1 f/f before passing the data to clock domain 'B'
	always @(posedge a_clk_i or negedge a_rst_n_i) begin
		if (!a_rst_n_i) begin
			a_lden_q <= 1'b0;
		end
		else if (a_lden) begin
			a_lden_q <= ~a_lden_q;	// alternate logic given at bottom
		end
	end
	
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// clock domain 'B'
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// this side uses 3 f/fs before the final o/ps are compared using
	// a xor gate, which provides the final o/p
	assign lden_sync = b2_lden_q ^ b3_lden_q;
	assign wr_ld_i   = lden_sync;
	assign wr_en_i   = lden_sync;

	always @(posedge b_clk_i or negedge b_rst_n_i) begin
		if (!b_rst_n_i) begin
			b1_lden_q    <= 1'b0;
			b2_lden_q    <= 1'b0;
			b3_lden_q    <= 1'b0;
		end
		else begin			
			b1_lden_q    <= a_lden_q;
			b2_lden_q    <= b1_lden_q;
			b3_lden_q    <= b2_lden_q;
		end
	end

	// --------------------------------------------------------------------------------------
	// storing data values inside FIFO (WRITE OPERATION)
	// --------------------------------------------------------------------------------------
	// since wr_ld_i = wr_en_i, in the condition for `else if` I have
	// only included one of them.
	always @(posedge b_clk_i or negedge b_rst_n_i) begin
		if (!b_rst_n_i) begin
			wr_ptr <= {ADDR_WIDTH{1'b0}};
		end
		else if (wr_ld_i & !full_o) begin
			memory[wr_ptr] <= wr_data_i;
			wr_ptr	       <= wr_ptr + 1'b1;
		end
	end

	// --------------------------------------------------------------------------------------
	// reading data values from FIFO (READ OPERATION)
	// --------------------------------------------------------------------------------------
	always @(posedge b_clk_i or negedge b_rst_n_i) begin
		if (!b_rst_n_i) begin
			rd_ptr <= {ADDR_WIDTH{1'b0}};
		end
		else if (rd_en_i & !empty_o) begin
			rd_data_o <= memory[rd_ptr];
			rd_ptr	  <= rd_ptr + 1'b1;
		end
	end

	// --------------------------------------------------------------------------------------
	// checking which operation happened last
	// --------------------------------------------------------------------------------------
	// since wr_ld_i = wr_en_i, in the condition for 2nd `else if` block
	// I have only included one of them.
	always @(posedge b_clk_i or negedge b_rst_n_i) begin
		if (!b_rst_n_i) begin
			last_operation_flag <= 1'b1;	// last operation was 'read' - default
		end
		else if (wr_en_i & !full_o) begin
			last_operation_flag <= 1'b0;	// last operation was 'write'
		end
		else if (rd_en_i & !empty_o) begin
			last_operation_flag <= 1'b1;	// last operation was 'read'
		end
	end

	// --------------------------------------------------------------------------------------
	// updating `full_o` and `empty_o` flags
	// --------------------------------------------------------------------------------------
	assign full_o  = (wr_ptr == rd_ptr) & ~last_operation_flag;
	assign empty_o = (wr_ptr == rd_ptr) & last_operation_flag;

endmodule

/*

	// --------------------------------------------------------------------------------------
	// toggle synchronizer
	// --------------------------------------------------------------------------------------
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// clock domain 'A' - as shown in diagrams
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// this side uses 1 f/f before passing the data to clock domain 'B'
	wire [1:0] mux_in_2x1;	// i/ps to mux (select line will be a_lden)

	assign mux_in_2x1 = (a_lden_q) ? {1'b0, 1'b1} : {1'b1, 1'b0};
	
	always @(posedge a_clk_i or negedge a_rst_n_i) begin
		if (!a_rst_n_i) begin
			a_lden_q <= 1'b0;
		end
		else if (a_lden) begin
			a_lden_q <= mux_in_2x1[1];
		end
		else begin
			a_lden_q <= mux_in_2x1[0];
		end
	end

*/
