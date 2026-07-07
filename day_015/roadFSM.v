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
	input        clk,
	input  	     rst,
	input  	     traffic_ew,
	input        traffic_lt,
	input        ok,
	output [1:0] direction
);

	wire [`MWIDTH-1:0] curr_state, next_state;
	reg  [`MWIDTH-1:0] next_state_noreg;  	   // next state without reset
	reg  tload;  				   // timer load
	reg  [1:0] direction;			   // direction output
	wire tdone;				   // timer complete

	// instantiate state register
	DFF #(`MWIDTH) state_reg (clk, next_state, curr_state);

	// instantiate timer
	Timer #(`TWIDTH) timer (clk, rst, tload, `T_EXP, tdone);

	always @(*) begin
		case (curr_state)
			`M_NS : {direction, tload, next_state_noreg} = 
				  {`M_NS, 1'b1, ok ? (traffic_lt ? `M_LT
							         : (traffic_ew ? `M_EW : `M_NS))
						   : `M_NS};

			`M_EW : {direction, tload, next_state_noreg} = 
				  {`M_EW, 1'b0, (ok & (!traffic_ew | tdone)) ? `M_NS : `M_EW};

			`M_LT : {direction, tload, next_state_noreg} = 
				  {`M_LT, 1'b0, (ok & (!traffic_lt | tdone)) ? `M_NS : `M_LT};

			default : {direction, tload, next_state_noreg} = 
				    {`M_NS, 1'b0, `M_NS};
		endcase
	end

	assign next_state = rst ? `M_NS : next_state_noreg;

endmodule
