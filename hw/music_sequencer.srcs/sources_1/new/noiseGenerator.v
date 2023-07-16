`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/12 13:24:48
// Design Name: 
// Module Name: noiseGenerator
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


module noiseGenerator(
    input CLK,
    input RESET,
    input BTN,
    input [19:0] soundDataIn,
    input tenMSecCountSig,
    input [7:0] randomData,
    output [9:0] BRAMaddr,
    output [23:0] soundDataOut,
    output [3:0] soundVolume,
    output [11:0] tempo
    );
  
    reg [2:0] state;
    reg [3:0] note;
    reg [3:0] octave;
    reg [7:0] lengthOfPeriod;
    reg [3:0] volume;
    reg [15:0] outTime;
  
    parameter [2:0]
      INIT = 3'd0,
      SETADDR = 3'd1,
      LOADDATA = 3'd2,
      DECODE = 3'd3,
      OUTPUT = 3'd4,
      COMMAND = 3'd5;
  
    always@(posedge CLK) begin
      if(RESET)
        state <= INIT;
      else
        case(state)
          INIT: begin
            if(BTN) state <= SETADDR;
            else    state <= state;
          end
          SETADDR: state <= LOADDATA;
          LOADDATA: state <= DECODE;
          DECODE: begin
            if(note == 4'hD)
              state <= INIT;
            else if(note == 4'hE)
              state <= COMMAND;
            else
              state <= OUTPUT;
          end
          OUTPUT: begin
            if(lengthOfPeriod == 0)
              state <= SETADDR;
            else
              state <= state;
          end
          COMMAND: state <= SETADDR;
          default: state <= INIT;
        endcase
    end
    
    reg [9:0] addr;
  
    always@(posedge CLK) begin
      case(state)
        INIT: addr <= 10'h3FF;
        SETADDR: addr <= addr + 1;
        COMMAND: begin
          if({octave, lengthOfPeriod[7:6]} == 6'b000000)
            addr <= {lengthOfPeriod[5:0], volume};
        end
        default: addr <= addr;
      endcase
    end
  
    assign BRAMaddr = addr;
  
    always@(posedge CLK) begin
      if(state == LOADDATA)
        {note, octave, lengthOfPeriod, volume} <= soundDataIn;
      else if(state == OUTPUT) begin
        if(tenMSecCountSig) begin
          note <= (randomData[7:4] > 4'hB) ? {1'b0, randomData[6:4]} : randomData[7:4];
          octave <= (randomData[3:0] > 4'd7) ? (randomData[3:0] - 7) : (randomData[3:0] + 1);
          {lengthOfPeriod, volume} <= {lengthOfPeriod - 1, volume};
        end else 
          {note, octave, lengthOfPeriod, volume} <= {note, octave, lengthOfPeriod, volume};
      end
      else
        {note, octave, lengthOfPeriod, volume} <= {note, octave, lengthOfPeriod, volume};
    end
  
    reg [23:0] outData;
  
    always@(posedge CLK) begin
      if(state == INIT)
        outData <= 0;
      else if(state == DECODE)
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
          default: outData <= 24'd0;
        endcase
      else
        outData <= outData;
    end
  
    assign soundDataOut = outData;
    
    reg [3:0] filterVolume;
    
    always@(posedge CLK) begin
      if(RESET)
        filterVolume <= 15;
      else
        if(state == COMMAND)
          if({octave, lengthOfPeriod[7:6]} == 6'd3)
            filterVolume <= volume;
          else
            filterVolume <= filterVolume;
    end
    
    assign soundVolume = (filterVolume < volume) ? filterVolume : volume;
    
    assign tempo = (state == COMMAND && ({octave, lengthOfPeriod[7:6]} == 6'd1 || {octave, lengthOfPeriod[7:6]} == 6'd2)) ? {lengthOfPeriod, volume} : 12'd0;

endmodule
