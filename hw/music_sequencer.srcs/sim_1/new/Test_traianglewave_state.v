`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/06 11:48:35
// Design Name: 
// Module Name: Test_traianglewave_state
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


module Test_traianglewave_state;
    reg CLK;
    reg RESET;
    reg [23:0]period;
    wire [3:0]signalOut;
    
    traianglewave_state uut(
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
          
            #100000;
            
            #10 $stop;
            
         end
         
endmodule
