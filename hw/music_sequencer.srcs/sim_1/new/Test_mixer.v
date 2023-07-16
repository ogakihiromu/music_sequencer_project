`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/05 14:43:55
// Design Name: 
// Module Name: Test_mixer
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


module Test_mixer;

    reg CLK;
    reg RESET;
    wire[3:0] signalOut1;
    wire[3:0] signalOut2;
    wire[3:0] signalOut3;
    reg[23:0] period1;
    reg[23:0] period2;
    reg[23:0] period3;
    wire[5:0] mixOut;
    
    mixer uut(
    .CLK(CLK),
    .RESET(RESET),
    .signal1(signalOut1),
    .signal2(signalOut2),
    .signal3(signalOut3),
    .mixOut(mixOut)
    );
    
    squarewave uut1(
           .CLK(CLK),
           .RESET(RESET),
           .period(period1),
           .signalOut(signalOut1)
           );
           
     squarewave uut2(
           .CLK(CLK),
           .RESET(RESET),
           .period(period2),
           .signalOut(signalOut2)
           );
                  
     traianglewave_state uut3(
           .CLK(CLK),
           .RESET(RESET),
           .period(period3),
           .signalOut(signalOut3)
           );             
        
        always
            #5 CLK = ~CLK;
        
        initial begin
            CLK = 0;
            RESET = 0;
            period1 = 0;
            period2 = 0;
            period3 = 0;
            
            #50;
            
            #10 RESET = 1;
            
            #10 RESET = 0;
            
            
            
            #(100000-100);
          
            period1 = 100;
            period2 = 1000;
            period3 = 500;
    
            #100000;
            #(100000-100);
            
            #10 $stop;
            
         end
endmodule
