`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/06/30 09:50:27
// Design Name: 
// Module Name: pwm
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

module pwm(
	input CLK,
	input RESET,
	input [3:0] signalIn,
	output pwmOut
	);

  // control duty cycle
  reg pwmReg;
  reg [31:0] pwmCount;
  parameter pwmUnit=100;
  parameter pwmPeriod = 15 * pwmUnit;


  // end control duty cycle
  always@(posedge CLK)          
         begin
           if(RESET)
             pwmCount <= 0;
           else
             if(pwmCount > pwmPeriod - 2)
               pwmCount <= 0;
             else
               pwmCount <= pwmCount + 1;
         end
    
  always@(posedge CLK)
    begin
        if(RESET)
            pwmReg <= 0;
        else
          case (signalIn)
            0: pwmReg <= 0;
            1: pwmReg <= (pwmCount < 1*pwmUnit);
            2: pwmReg <= (pwmCount < 2*pwmUnit);
            3: pwmReg <= (pwmCount < 3*pwmUnit);
            4: pwmReg <= (pwmCount < 4*pwmUnit);
            5: pwmReg <= (pwmCount < 5*pwmUnit);
            6: pwmReg <= (pwmCount < 6*pwmUnit);
            7: pwmReg <= (pwmCount < 7*pwmUnit);
            8: pwmReg <= (pwmCount < 8*pwmUnit);
            9: pwmReg <= (pwmCount < 9*pwmUnit);
           10: pwmReg <= (pwmCount < 10*pwmUnit);
           11: pwmReg <= (pwmCount < 11*pwmUnit);
           12: pwmReg <= (pwmCount < 12*pwmUnit);
           13: pwmReg <= (pwmCount < 13*pwmUnit);
           14: pwmReg <= (pwmCount < 14*pwmUnit);
           15: pwmReg <= (pwmCount < 15*pwmUnit);
          endcase
    
    end

  // control sound

  assign pwmOut = pwmReg; 
    
endmodule
