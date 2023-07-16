`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/05 12:25:09
// Design Name: 
// Module Name: traianglewave
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


module traianglewave(
input CLK,
input RESET,
input [23:0] period,
output [3:0] signalOut
);

reg [23:0] countForPeriod;
reg [23:0] countUp;
reg [3:0] chOut;

assign signalOut = chOut;

always@(posedge CLK)
begin
      if(RESET)
         countForPeriod <= 0;
      else
         if(countForPeriod >= period -1)
            countForPeriod <= 0;
         else
            countForPeriod <= countForPeriod + 1;
end

wire Up;
assign Up = countUp >= (period>>5);

always@(posedge CLK)
begin
      if(RESET)
         countUp <= 0;
      else
         if(Up)
            countUp <= 0;
         else
            countUp <= countUp + 1;
end


always@(posedge CLK)
begin
if(RESET)
  chOut <= 0;
else 
    if((countForPeriod > period - 1) || countForPeriod == 0)
        chOut <= 0;
    else if(countForPeriod <= (period >> 1))
        if(Up)
           chOut <= chOut + 1;
        else 
           chOut <= chOut;
           
    else if(countForPeriod > (period >> 1))
        if(Up)  
               chOut <= chOut - 1;
        else
               chOut <= chOut;
    else
       chOut <= chOut;
end

endmodule
