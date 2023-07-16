`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/04 18:16:55
// Design Name: 
// Module Name: Test_famicom
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


module Test_famicom;

    reg CLK;
    reg RESET;
    reg BTN;
    reg START;
    wire LD;
    wire SOUND;

   famicom uut(
        .CLK(CLK),
        .RESET(RESET),
        .START(START),
        .LD(LD),
        .SOUND(SOUND),
        .BTN(BTN)
        );
        
        always
            #5 CLK = ~CLK;
        
        initial begin
            CLK = 0;
            RESET = 0;
            BTN = 0;
            START = 0;
            
            #50;
            
            #10 RESET = 1;
            
            #10 RESET = 0;
            
            #50;
            
            BTN = 1;
            
            #10;          
            
            BTN = 0;
            
            #10000;
            
            
         end
endmodule
