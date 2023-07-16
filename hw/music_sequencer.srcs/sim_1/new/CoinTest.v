`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/10 16:16:50
// Design Name: 
// Module Name: CoinTest
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


module CoinTest;

  reg CLK;
  reg RESET;
  reg START;
  reg [19:0] soundDataIn;
  wire [7:0] BRAMaddr;
  wire [23:0] period;
  wire [3:0] soundDataOut;
  wire [3:0] soundVolume;
  wire active;
  
  coin uut(
    .CLK(CLK),
    .RESET(RESET),
    .start(START),
    .soundDataIn(soundDataIn),
    .BRAMaddr(BRAMaddr),
    .period(period),
    .soundDataOut(soundDataOut),
    .soundVolume(soundVolume),
    .active(active)
    );
    
    always
      #5 CLK = ~CLK;
    
    initial begin
      CLK = 0;
      RESET = 0;
      START = 0;
      soundDataIn = 20'h4630F;
      
      #50;
      
      #10 RESET = 1;
      #10 RESET = 0;
      #50 START = 1;
      #10 START = 0;
      #100000;
      #10 $stop;
      
    end

endmodule
