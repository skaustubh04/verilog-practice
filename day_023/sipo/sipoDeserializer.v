`timescale 1ns / 1ps

module sipo_deserializer #(
	parameter WIDTH      = 16
) (
	input wire             clk_i,
	input wire 	       rst_n_i,		// active-low reset
	input wire 	       wr_en_i,		// write enable
	input wire 	       wr_data_i,	// serial data i/p
	output reg	       valid_o,		// valid flag
	output reg [WIDTH-1:0] rd_data_o	// parallel data o/p
);

	// -----------------------------------
	// number of bits for counter
	localparam WIDTH_BITS = $clog2(WIDTH);

	// ---------------------------
	// counter and shift register
	reg [WIDTH_BITS-1:0] counter;
	reg [WIDTH-1:0]      shift_reg;

	always @(posedge clk_i or negedge rst_n_i) begin
		// shift regsiter contents reset
		if (!rst_n_i) begin
			shift_reg <= {WIDTH{1'b0}};
			valid_o     <= 1'b0;
			counter   <= {WIDTH_BITS{1'b0}};
		end
		else if (wr_en_i) begin
			shift_reg <= {shift_reg[WIDTH-2:0], wr_data_i};	// update shift register

			if (counter == WIDTH-1) begin				// shift register is full
				counter   <= {WIDTH_BITS{1'b0}};		// reset counter
				valid_o   <= 1'b1;				// valid flag goes HIGH
				rd_data_o <= {shift_reg[WIDTH-2:0], wr_data_i};	// data is read at o/p
			end
			else begin
				counter <= counter + 1'b1;		// increment counter
				valid_o <= 1'b0;			// valid flag stays LOW
			end
		end
		else begin
			valid_o <= 1'b0;	// so that it doesn't stay HIGH when not writing
		end
	end

endmodule
