`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:02:06 04/25/2017 
// Design Name: 
// Module Name:    LFSR 
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
module LFSR(
	 input clk,
	 input [9:0] seed,
	 input reseed,
	 output [9:0] out
    );
	 
  reg [9:0] r;

  always@(posedge clk)
  begin
    if(reseed)
	   r = seed;
	 else begin
	   // tap sequence [10, 3, 0]
	   r = (r >> 1) | (r[9]^r[2]^1'b1) << 9;
	 end
  end
  
  assign out = r;

endmodule
