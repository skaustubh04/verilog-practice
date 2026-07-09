`timescale 1ns / 1ps

// direction vals and road FSM states
`define MWIDTH 2
`define M_NS   2'b00
`define M_EW   2'b01
`define M_LT   2'b10
// `define T_EXP  -> will define later
// `define TWIDTH -> will define later

// ok -> signals that it is 'ok' to request a new direction
// direction -> outputs the requested direction

module road_fsm (
	input wire       clk,
	input wire       rst,
	input wire       traffic_ew,
	input wire       traffic_lt,
	input wire       ok,
	output reg [1:0] direction
);

	reg [`MWIDTH-1:0] curr_state, next_state;
	// wire [`MWIDTH-1:0] next_state_noreg     // NOT BEING USED
	reg  tload;  				   // timer load
	wire tdone;				   // timer complete

	// store value in `curr_state`
	always @(posedge clk or posedge rst) begin
		if (rst) curr_state <= `M_NS;
		else 	 curr_state <= next_state;
	end

	// instantiate timer
	Timer #(`TWIDTH) timer (clk, rst, tload, `T_EXP, tdone);

	always @(*) begin
		case (curr_state)
			`M_NS : {direction, tload, next_state} = 
				  {`M_NS, 1'b1, ok ? (traffic_lt ? `M_LT
							         : (traffic_ew ? `M_EW : `M_NS))
						   : `M_NS};

			`M_EW : {direction, tload, next_state} = 
				  {`M_EW, 1'b0, (ok & (!traffic_ew | tdone)) ? `M_NS : `M_EW};

			`M_LT : {direction, tload, next_state} = 
				  {`M_LT, 1'b0, (ok & (!traffic_lt | tdone)) ? `M_NS : `M_LT};

			default : {direction, tload, next_state} = 
				    {`M_NS, 1'b0, `M_NS};
		endcase
	end

endmodule
