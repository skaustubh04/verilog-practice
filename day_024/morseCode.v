/*
*
* ===================================================
*       MORSE CODE USING SISO SHIFT REGISTER
* ===================================================
* 
* space b/w encoded dots/dashes -> 1 time unit
* space b/w each letter         -> 3 time units
* space b/w each word           -> 7 time units
* 
* length of 1 dot  -> 1 time unit
* length of 1 dash -> 3 time units
*
* frequency of clock will be 100MHz, but `wr_en_i`
* will be sent every 100ms (after 10M clock cycles)
*
* The message which will be transmitted will be
* the word "HDL" (or "hdl"), where
* h -> .... -> 1010101
* d -> _..  -> 1110101
* l -> ._.. -> 101110101
* combined along with the letter spacings, looks like
* 1010101_000_1110101_000_101110101
*
* The above code will be the content of the shift reg
* but I will also append a '0' to its beginning so
* that whenever it is RESET the output isn't read
* so quickly (can cause confusion due to prev/
* on-going o/p)
*
*/

`timescale 1ns / 1ps

module morse_code #(
	parameter WIDTH = 30
) (
	input wire  clk_i,	// i/p clock
	input wire  rst_n_i,	// active-low reset
	
	output wire rd_data_o	// data read from shift reg
);

	// -------------------------------------------
	// no. of bits in counter
	// for 10M clock cycles it will count up
	localparam COUNTER_WIDTH = $clog2(10_000_000); 

	// -----------------------------
	// counter, pulse and shift reg
	reg [COUNTER_WIDTH-1:0] counter;     // length log2(10M)
	reg 			trigger_en;  // enables shifting in shift reg
	reg [WIDTH-1:0]         shift_reg;   // length 30

	// ----------------------------------------------------------
	// initialting values in the register
	initial begin
		shift_reg <= 30'b0_1010101_000_1110101_000_101110101;
	end

	// ------------------------------------------------------------------
	// logic to control o/p and `shift_reg`
	// ------------------------------------------------------------------
	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin
			shift_reg  <= 30'b0_1010101_000_1110101_000_101110101;
			counter    <= {COUNTER_WIDTH{1'b0}};
			trigger_en <= 1'b0;
		end
		else begin
			if (trigger_en) begin
				shift_reg <= {shift_reg[WIDTH-2:0], 1'b0};
			end
			
			if (counter == 10_000_000 - 1) begin
				counter    <= {COUNTER_WIDTH{1'b0}};
				trigger_en <= 1'b1;
			end
			else begin
				counter    <= counter + 1'b1;
				trigger_en <= 1'b0;
			end
		end
	end

	// -----------------------------------
	// reading the MSB of shift reg as o/p
	assign rd_data_o = shift_reg[WIDTH-1];  

endmodule
