`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/04 17:55:47
// Design Name: 
// Module Name: Test_pwm
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


module Test_pwm;

    reg CLK;
    reg RESET;
    reg [3:0]signalIn;
    wire pwmOut;

   pwm uut(
        .CLK(CLK),
        .RESET(RESET),
        .signalIn(signalIn),
        .pwmOut(pwmOut)
        );
        
        always
            #5 CLK = ~CLK;
        
        initial begin
            CLK = 0;
            RESET = 0;
            signalIn = 0;
            
            #50;
            
            #10 RESET = 1;
            
            #10 RESET = 0;
            
            signalIn = 1;
                        
            #150000;
            
            signalIn = 0;
            
            #150000;
                
        
            signalIn = 4;
            
            #150000;
            
            signalIn = 15;
            
            #150000;          
            
            
            #10 $stop;
            
         end
        


endmodule
