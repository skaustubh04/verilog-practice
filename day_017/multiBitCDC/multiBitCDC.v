`timescale 1ns / 1ps

module multi_bit_cdc #(
	parameter WIDTH = 32,
	parameter DEPTH = 16
) (
	// ------------------------------
	// clocks and reset
	input wire wr_clk_i,
	input wire rd_clk_i,
	input wire wr_rst_n_i,
	input wire rd_rst_n_i,
	// ------------------------------
	// write
	input wire 	       wr_en_i,
	input wire [WIDTH-1:0] wr_data_i,
	output wire 	       full_o,
	// ------------------------------
	// read
	input wire 	       rd_en_i,
	output reg [WIDTH-1:0] rd_data_o,
	output wire	       empty_o
);

	// ------------------------------------------------------
	// for the pointers to be able to address the fifo memory
	localparam ADDR_WIDTH = $clog2 (DEPTH);

	// --------------------------------------------------------------------------------------
	// read and write pointers: binary, gray and synchronized
	// the pointers are assigned an extra bit to allow for smoother
	// calculation of which operation happened last (write, read)
	wire [ADDR_WIDTH:0] wr_ptr;		// binary write ptr
	wire [ADDR_WIDTH:0] rd_ptr;		// binary read ptr
	wire [ADDR_WIDTH:0] g_wr_ptr;		// gray write ptr
	wire [ADDR_WIDTH:0] g_rd_ptr;		// gray read ptr
	reg  [ADDR_WIDTH:0] g_wr_ptr_sync;	// synchronized gray write ptr for cdc - FLOP O/P
	reg  [ADDR_WIDTH:0] g_rd_ptr_sync;	// synchronized gray read ptr for cdc - FLOP O/P

	// ----------------------------
	// memory
	reg [WIDTH-1:0] memory [0:DEPTH-1];

	// ---------------------------------------------------------------------------
	// registers acting as o/p of flops (for CDC)
	reg [ADDR_WIDTH:0] g_wr_ptr_q;		// first flop's output for write
	reg [ADDR_WIDTH:0] g_rd_ptr_q;		// first flop's output for read
	// `g_wr_ptr_q` will be the i/p to 2nd flop, whose o/p will be `g_wr_ptr_sync`
	// `g_rd_ptr_q` will be the i/p to 2nd flop, whose o/p will be `g_rd_ptr_sync`

	// --------------------------------------------------------------------------------------
	// write pointer function instance
	// --------------------------------------------------------------------------------------
	WR_PTR wr_ptr_inst (
		.clk(wr_clk_i), .rst_n(wr_rst_n_i),
		.wr_en(wr_en_i), .wr_ptr(wr_ptr),
		.g_wr_ptr(g_wr_ptr), .g_rd_ptr_sync(g_rd_ptr_sync),
		.full(full_o)
	);

	// --------------------------------------------------------------------------------------
	// read pointer function instance
	// --------------------------------------------------------------------------------------
	RD_PTR rd_ptr_inst (
		.clk(rd_clk_i), .rst_n(rd_rst_n_i),
		.rd_en(rd_en_i), .rd_ptr(rd_ptr),
		.g_rd_ptr(g_rd_ptr), .g_wr_ptr_sync(g_wr_ptr_sync),
		.empty(empty_o)
	);

	// --------------------------------------------------------------------------------------
	// dual flops using `always` block
	// these will be used to allow cdc of the gray-coded pointer values
	// input to flop    -> gray-coded pointer values
	// output from flop -> gray-coded synchronized pointer values
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	// write flop
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	always @(posedge wr_clk_i or negedge wr_rst_n_i) begin
		if (!wr_rst_n_i) begin
			g_rd_ptr_q    <= {(ADDR_WIDTH+1){1'b0}};
			g_rd_ptr_sync <= {(ADDR_WIDTH+1){1'b0}};
		end
		else begin
			g_rd_ptr_q    <= g_rd_ptr;
			g_rd_ptr_sync <= g_rd_ptr_q;
		end
	end

	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	//read flop
	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	always @(posedge rd_clk_i or negedge rd_rst_n_i) begin
		if (!rd_rst_n_i) begin
			g_wr_ptr_q    <= {(ADDR_WIDTH+1){1'b0}};
			g_wr_ptr_sync <= {(ADDR_WIDTH+1){1'b0}};
		end
		else begin			
			g_wr_ptr_q    <= g_wr_ptr;
			g_wr_ptr_sync <= g_wr_ptr_q;
		end
	end

	// --------------------------------------------------------------------------------------
	// storing data values inside of FIFO (WRITE OPERATION)
	// --------------------------------------------------------------------------------------
	always @(posedge wr_clk_i) begin
		if (wr_en_i & !full_o) begin
			memory[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data_i;
		end
	end

	// --------------------------------------------------------------------------------------
	// reading data values from FIFO (READ OPERATION)
	// --------------------------------------------------------------------------------------
	always @(posedge rd_clk_i) begin
		if (rd_en_i & !empty_o) begin
			rd_data_o <= memory[rd_ptr[ADDR_WIDTH-1:0]];
		end
	end

endmodule
