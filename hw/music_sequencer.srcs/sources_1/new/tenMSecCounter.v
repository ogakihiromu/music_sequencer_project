`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/11 11:33:19
// Design Name: 
// Module Name: tenMSecCounter
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


module tenMSecCounter(
    input CLK,
    input RESET,
    input [11:0] tempo,
    input [7:0] SW,
    output counterSig
    );
    
    reg [31:0] baseTime;
    parameter [31:0] tenMSecCount = 32'd1000000;
    
    always@(posedge CLK) begin
      if(RESET)
        baseTime <= tenMSecCount;
      else
        if(tempo[11:10] == 2'b01)
          baseTime <= (baseTime > 32'd10000000) ? baseTime : baseTime + tempo[9:0];
        else if(tempo[11:10] == 2'b10)
          baseTime <= (baseTime < 32'd100000)   ? baseTime : baseTime - tempo[9:0];
        else
          case(SW[7])
            1'b1: baseTime <= tenMSecCount + (SW[6:0] << 16);
            1'b0: baseTime <= tenMSecCount - (SW[6:0] << 12);
          endcase
    end
    
    reg [31:0] count;
    
    always@(posedge CLK) begin
      if(RESET)
        count <= 0;
      else
        if(count >= baseTime)
          count <= 0;
        else
          count <= count + 1;
    end
    
    assign counterSig = (count == baseTime);
    
endmodule
