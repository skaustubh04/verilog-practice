`timescale 1ns / 1ps

/*
*
* It is better to keep `DEPTH` a power of 2 for efficient pointer management.
* I'm using DEPTH = 16
*
* The FIFO has following inputs and outputs:
	* INPUTS ---
		* clk_i     -> common FIFO clock
		* rst_n_i   -> active-low reset
		* wr_data_i -> this will be a vector of width `WIDTH`
		* wr_en_i   -> this is a flag used to allow writing to FIFO
		* rd_en_i   -> this is a flag used to allow reading from FIFO
	* OUTPUTS ---
		* full_o    -> this flag is used to indicate if FIFO is full
		* rd_data_o -> this will be a vector of width `WIDTH`
		* empty_o   -> this flag is used to indicate if FIFO is empty
* 
*/

module fifo #(
	parameter WIDTH = 32,	// data width
	parameter DEPTH = 16	// number of elements of that width
) (
	// ----------------------------------------------------------------------------------
	// clock & reset
	input wire clk_i,
	input wire rst_n_i,
	// ----------------------------------------------------------------------------------
	// write
	input wire	       wr_en_i,
	input wire [WIDTH-1:0] wr_data_i,
	output wire	       full_o,
	// ----------------------------------------------------------------------------------
	// read
	input wire 	       rd_en_i,
	output reg [WIDTH-1:0] rd_data_o,
	output wire 	       empty_o
);

	// ADDRESS WIDTH CALC ---
	localparam ADDR_WIDTH = $clog2 (DEPTH);

	// ADDRESS POINTERS ----
	reg [ADDR_WIDTH-1:0] wr_ptr;
	reg [ADDR_WIDTH-1:0] rd_ptr;

	// FLAGS ---
	reg last_operation_flag;	// write -> 0; read -> 1

	// MEMORY/REGISTER ---
	reg [WIDTH-1:0] memory [0:DEPTH-1];
	
	// ----------------------------------------------------------------------------------
	// write operation
	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			wr_ptr <= {ADDR_WIDTH{1'b0}};
		end
		else if (wr_en_i & !full_o) begin
			memory[wr_ptr] <= wr_data_i;
			wr_ptr <= wr_ptr + 1'b1;
		end
	end

	// ----------------------------------------------------------------------------------
	// read operation
	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			rd_ptr <= {ADDR_WIDTH{1'b0}};
		end
		else if (rd_en_i & !empty_o) begin
			rd_data_o <= memory[rd_ptr];
			rd_ptr <= rd_ptr + 1'b1;
		end
	end

	// ----------------------------------------------------------------------------------
	// checking which operation happened last
	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			last_operation_flag <= 1'b1;
		end
		else if (wr_en_i & !full_o) begin
			last_operation_flag <= 1'b0;
		end
		else if (rd_en_i & !empty_o) begin
			last_operation_flag <= 1'b1;
		end
	end

	// ----------------------------------------------------------------------------------
	// updating `full_o` and `empty_o` flags
	assign full_o  = ((wr_ptr == rd_ptr) & !last_operation_flag);
	assign empty_o = ((wr_ptr == rd_ptr) & last_operation_flag);

endmodule
