`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/07 10:11:20
// Design Name: 
// Module Name: Coin
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


module coin(
    input CLK,
    input RESET,
    input start,
    input [19:0] soundDataIn,
    output [7:0] BRAMaddr,
    output [23:0] soundDataOut,
    output [3:0] soundVolume,
    output active
    );

  reg [2:0] state;
  reg [3:0] note;
  reg [3:0] octave;
  reg [7:0] lengthOfPeriod;
  reg [3:0] volume;
  reg [15:0] outTime;
  
  reg [31:0] msecCount;

  parameter [2:0]
    INIT = 3'd0,
    SETADDR = 3'd1,
    LOADDATA = 3'd2,
    CHECKEND = 3'd3,
    OUTPUT = 3'd4;

  assign active = (state != INIT); 
  
  always@(posedge CLK) begin
    if(RESET)
      state <= 0;
    else
      case(state)
        INIT: begin
          if(start) state <= SETADDR;
          else    state <= state;
        end
        SETADDR: state <= LOADDATA;
	    LOADDATA: state <= CHECKEND;
	    CHECKEND: begin
	      if(note == 4'd13)
	        state <= INIT;
	      else
	        state <= OUTPUT;
	    end
        OUTPUT: begin
          if(lengthOfPeriod == 0)
	        state <= SETADDR;
	      else
	        state <= state;
	    end
      endcase
  end
  
  reg [7:0] addr;

  always@(posedge CLK) begin
    case(state)
      INIT: addr <= 8'hFF;
      SETADDR: addr <= addr + 1;
      default: addr <= addr;
    endcase
  end

  always@(posedge CLK) begin
    if(RESET)
      msecCount <= 0;
    else  if(state == OUTPUT) begin
      if(msecCount == 32'd1000000)
        msecCount <= 0;
	  else
	    msecCount <= msecCount + 1;
    end
    else
      msecCount <= 0;
  end

  assign BRAMaddr = addr;

  always@(posedge CLK) begin
    if(state == LOADDATA)
      {note, octave, lengthOfPeriod, volume} <= soundDataIn;
    else begin
      if(msecCount == 32'd1000000)
        {note, octave, lengthOfPeriod, volume} <= {note, octave, lengthOfPeriod - 1, volume};
      else 
        {note, octave, lengthOfPeriod, volume} <= {note, octave, lengthOfPeriod, volume};
    end
  end

  reg [23:0] outData;

  always@(posedge CLK) begin
    if(state == INIT)
      begin
        outData <= 0;
      end
    else if(state == CHECKEND)
      case(note)
        4'h0: outData <= 24'd3058104 >> (octave - 1);
        4'h1: outData <= 24'd2886003 >> (octave - 1);
        4'h2: outData <= 24'd2724053 >> (octave - 1);
        4'h3: outData <= 24'd2571355 >> (octave - 1);
        4'h4: outData <= 24'd2427184 >> (octave - 1);
        4'h5: outData <= 24'd2290951 >> (octave - 1);
        4'h6: outData <= 24'd2162162 >> (octave - 1);
        4'h7: outData <= 24'd2040816 >> (octave - 1);
        4'h8: outData <= 24'd1926411 >> (octave - 1);
        4'h9: outData <= 24'd1818182 >> (octave - 1);
        4'hA: outData <= 24'd1716149 >> (octave - 1);
        4'hB: outData <= 24'd1619695 >> (octave - 1);
        4'hC: outData <= 24'd0;
      endcase
    else
      outData <= outData;
  end

  assign soundDataOut = outData;
  assign soundVolume = volume;

endmodule
