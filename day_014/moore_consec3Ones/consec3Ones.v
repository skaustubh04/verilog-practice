// CONSECUTIVE 3 ONES DETECTING MOORE MACHINE (OVERLAPPING)

module consec_3_ones (
	input wire clk,
	input wire rst,
	input wire bitstream,
	output reg y
);

	localparam S0 = 2'b00;
	localparam S1 = 2'b01;
	localparam S2 = 2'b10;
	localparam S3 = 2'b11;

	reg [1:0] curr_state, next_state;

	// sequential logic
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			curr_state <= S0;
		end
		else begin
			curr_state <= next_state;
		end
	end

	// combinational (next state) logic
	always @(*) begin
		// to avoid latches
		next_state = curr_state;
		y = (curr_state == S3) ? 1'b1 : 1'b0;

		case (curr_state)
			S0 : next_state = (bitstream == 1'b1) ? S1 : S0;
			S1 : next_state = (bitstream == 1'b1) ? S2 : S0;
			S2 : next_state = (bitstream == 1'b1) ? S3 : S0;
			S3 : next_state = (bitstream == 1'b1) ? S3 : S0;  // Detects overlap
			default : next_state = S0;
		endcase
	end

endmodule
