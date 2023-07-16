`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/04 11:00:18
// Design Name: 
// Module Name: music
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module squarewave(
	input CLK,
	input RESET,
	input [23:0] period,
	input [3:0] volume,
	output [3:0] signalOut
	);

reg [23:0] countForPeriod;
reg [3:0] chOut;

 always@(posedge CLK)
  begin
    if(RESET)
      chOut <= 4'h0;
    else
      if(countForPeriod == (period>>1) || countForPeriod == 0)
        chOut <= (chOut == 0) ? volume : 4'h0;
      else
        chOut <= chOut;
  end

assign signalOut = (period == 0) ? 4'h0 : chOut;

 always@(posedge CLK)
  begin
    if(RESET)
      countForPeriod <= 4'h0;
    else
      if(countForPeriod >= period -1)
        countForPeriod <= 0;
      else
        countForPeriod <= countForPeriod + 1;
  end

endmodule
