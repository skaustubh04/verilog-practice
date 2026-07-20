`timescale 1ns / 1ps

module universal_shift_reg #(
	parameter WIDTH = 4
) (
	// ------------------------------
	// clock and reset
	input wire 	       clk_i,
	input wire 	       rst_n_i,	   // async active-low rst

	// ------------------------------
	// inputs
	input wire             wr_en_i,    // if HIGH, allows writing
	input wire [1:0]       sel_i,	   // select lines for 4:1 mux
	input wire [WIDTH-1:0] p_data_i,   // parallel data i/p
	input wire             s_left_i,   // i/p for SHIFTING LEFT
	input wire 	       s_right_i,  // i/p for SHIFTING RIGHT

	// ------------------------------
	// outputs
	output wire 	       s_left_o,   // o/p when SHIFTING LEFT
	output wire	       s_right_o,  // o/p whe SHIFTING RIGHT
	output reg [WIDTH-1:0] p_data_o    // o/p of register
);

	localparam DATA_HOLD     = 2'b00,  // data is held as is
		   SHIFT_RIGHT   = 2'b01,  // data is SHIFTED RIGHT
		   SHIFT_LEFT    = 2'b10,  // data is SHIFTED LEFT
		   PARALLEL_LOAD = 2'b11;  // data is PARALLELLY LOADED to register
	
	always @(posedge clk_i or negedge rst_n_i) begin
		if (!rst_n_i) begin  // register contents reset to `0` on true
			p_data_o <= {WIDTH{1'b0}};
		end
		else begin
			if (wr_en_i) begin  // data can be updated only when `wr_en_i` is HIGH
				case (sel_i)
					DATA_HOLD     : p_data_o <= p_data_o;
					SHIFT_RIGHT   : p_data_o <= {s_right_i, p_data_o[WIDTH-1:1]};
					SHIFT_LEFT    : p_data_o <= {p_data_o[WIDTH-2:0], s_left_i};
					PARALLEL_LOAD : p_data_o <= p_data_i;
					default       : p_data_o <= p_data_o;
				endcase
			end
		end
	end

	assign s_left_o  = p_data_o[WIDTH-1];  // o/p is MSB
	assign s_right_o = p_data_o[0];	       // o/p is LSB

endmodule
