`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:35:57 11/15/2016 
// Design Name: 
// Module Name:    Modulator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Modulator(
    input clk,
    output clk_out
    );

	localparam HALF = 499;
	localparam LIMIT = 999;
	reg counter[9:0] = 0;
	
	always@(posedge clk) begin
		if (counter <= HALF)
			clk_out <= 1;
		else 
			clk_out <= 0;
		
		counter <= counter + 1;
		
		if (counter > LIMIT) 
			counter <= 0;
	end

endmodule
