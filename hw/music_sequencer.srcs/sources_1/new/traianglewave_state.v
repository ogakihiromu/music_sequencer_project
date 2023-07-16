`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/06 10:40:44
// Design Name: 
// Module Name: traianglewave_state
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


module traianglewave_state(
input CLK,
input RESET,
input [23:0] period,
output [3:0] signalOut
);

reg [23:0] countForPeriod;
reg [23:0] countUp;
reg [3:0] chOut;
reg [1:0] state;
reg [23:0] storePeriod;

assign signalOut = (chOut<<2);

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
      else if((state == 1) || (state == 2))
             countUp <= (Up)? 0 : (countUp + 1);
      else 
        countUp <= 0;
end

//parameter  halfPeriod = (period >> 1);

always@(posedge CLK)
begin
      if(RESET)
         state <= 0;
     case(state)
        0: state <= 1;
        1: if(countForPeriod > (period >> 1)-1) state <= 2;
        2: if(chOut==0)  state <= 3;
        3: if(countForPeriod == (period -1)) state <= 0;
     endcase
end

always@(posedge CLK)
begin
  if(RESET)
        chOut <= 0;

    if(state == 0)
        storePeriod <= period;
        
    else if(state == 1)
        if(Up)
            chOut <= chOut + 1;
        else 
            chOut <= chOut;
     
    else if(state == 2)
        if(Up)  
            chOut <= (chOut ==0)? chOut: (chOut - 1);
        else
            chOut <= chOut;
            
    else if(state == 3)
        chOut <= 0;

end


endmodule