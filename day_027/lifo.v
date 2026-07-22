/*
*
* =================================================
*         LAST-IN, FIRST-OUT (LIFO) MEMORY
* =================================================
*
* It is better to keep a `DEPTH` of power of 2.
* I will use a `DEPTH` of 16.
*
* I want this to infer BRAM. It will depend on
* which synthesizer is used, but most of them
* do not have a `rst` pin for their BRAMs.
* If I am to add a `rst` pin, I will have to add
* it in such a way that it is not part of the 
* sequenctial `always` block's conditional part,
* i.e., it can be added inside it in an `if` block.
* 
*/

`timescale 1ns / 1ps

module lifo #(
	parameter WIDTH = 32,
	parameter DEPTH = 16
) (
	// -----
	// clock and reset
	input wire             clk_i,
	input wire             rst_n_i,
	// --------
	// write
	input wire             wr_en_i,
	input wire [WIDTH-1:0] wr_data_i,
	output wire            full_o,
	// ---------
	// read
	input wire             rd_en_i,
	output reg [WIDTH-1:0] rd_data_o,
	output wire            empty_o
);

	// -----------------------------------------------------
	// for the pointers to access memory locations
	localparam ADDR_WIDTH = (DEPTH > 1) ? $clog2(DEPTH) : 1;

	// -------------------------
	// address pointers
	reg [ADDR_WIDTH:0] wr_ptr;
	reg [ADDR_WIDTH:0] rd_ptr;

	// -------------------------
	// last operation flag
	// write -> 0; read -> 1
	reg last_op_flag;

	// ------------------------
	// memory/register
	reg [WIDTH-1:0] memory [0:DEPTH-1];

	// ---------------------------------------------------
	// write operation
	// ---------------------------------------------------
	always @(posedge clk_i) begin
		if (!rst_n_i) begin
			wr_ptr <= {ADDR_WIDTH{1'b0}};
		end	
		else if (wr_en_i & !full_o) begin
			memory[wr_ptr] <= wr_data_i;
			wr_ptr         <= wr_ptr + 1'b1;
			last_op_flag   <= 1'b0;  // write -> 0
		end
	end

	// ---------------------------------------------------
	// read operation
	// ---------------------------------------------------
	always @(posedge clk_i) begin
		if (!rst_n_i) begin
			rd_ptr <= {ADDR_WIDTH{1'b0}};
		end
		else if (rd_en_i & !empty_o) begin
			rd_data_o    <= memory[rd_ptr];
			rd_ptr       <= rd_ptr + 1'b1;
			last_op_flag <= 1'b1;  // read -> 1
		end
	end

	always @(posedge clk_i) begin
		if (!rst_n_i) begin
			last_op_i <= 1'b1;  // defaults to read operation (read -> 1)
		end
		else if (wr_en_i & rd_en_i) begin
			last_op_i <= 1'b1;  // it is a case in which both the pointers advance, no worries
		end
		else if (wr_en_i & !full_o) begin
			last_op_flag <= 1'b0;  // write -> 0
		end
		else if (rd_en_i & !empty_o) begin
			last_op_flag <= 1'b1;  // read -> 1
		end
	end

	assign full_o  = (wr_ptr )
	assign empty_o = 
