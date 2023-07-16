`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/05 12:31:32
// Design Name: 
// Module Name: Test_traianglewave
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


module Test_traianglewave;

    reg CLK;
    reg RESET;
    reg [23:0]period;
    wire [3:0]signalOut;
    
    traianglewave uut(
    .CLK(CLK),
    .RESET(RESET),
    .period(period),
    .signalOut(signalOut)
    );
        
        always
            #5 CLK = ~CLK;
        
        initial begin
            CLK = 0;
            RESET = 0;
            period = 0;
            
            #50;
            
            #10 RESET = 1;
            
            #10 RESET = 0;
            
            period = 1000;
            
            #(100000-100);
          
//            period = 0;
            
//            #(100000-100);
          
//            period = 100;
    
            #100000;
            
            #10 $stop;
            
         end
         
endmodule