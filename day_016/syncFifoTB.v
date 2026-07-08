`timescale 1ns / 1ps

module sync_fifo_tb;

	localparam WIDTH = 8;
	localparam DEPTH = 16;

   	reg clk;
	reg rst;
	reg wr_en;
	reg rd_en;
   	reg [WIDTH-1:0] wr_data;
   	wire [WIDTH-1:0] rd_data;
   	wire empty, full;

	sync_fifo #(
	   	.WIDTH(WIDTH),
		.DEPTH(DEPTH)
   	) uut (
		.clk(clk),
	   	.rst(rst),
	   	.wr_en(wr_en),
	   	.rd_en(rd_en),
	   	.wr_data(wr_data),
	   	.rd_data(rd_data),
	   	.empty(empty),
	   	.full(full)
   	);
   
   	initial begin 
   		clk= 0;
   		forever #5 clk = ~clk;
   	end
   
    	initial begin
		$dumpfile ("syncFifoTB.vcd");
		$dumpvars (0, sync_fifo_tb);

		$display ("\nSYNCHRONOUS FIFO\n");

		rst = 1;
	        wr_en = 0;
	        rd_en = 0;
	        wr_data = 0;
	      	#10 rst = 0;
	      	#10 wr_en = 1; wr_data = 1;
	      	#10 wr_en = 1; wr_data = 2;
	      	#10 wr_en = 1; wr_data = 3;
	      	#10 rd_en = 1;
	      	#10 rd_en = 1;
	      	#10 wr_en = 1; wr_data = 4;
	      	#10 wr_en = 1; wr_data = 5;
	      	#80 $display ("\nSIM FIN");
		$finish;
    	end
    
   	always @(posedge clk) begin
      		$monitor("RD Data: %d, Empty: %d, Full: %d", rd_data, empty, full);
   	end

endmodule
