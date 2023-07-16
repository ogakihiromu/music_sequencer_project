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
 
module famicom(
    input CLK,
    input RESET,
    input BTN,
    input START,
    input [15:0] SW,
    input BTNU,
    input BTND,
    output CS,
    output SDIN,
    output SCLK,
    output DC,
    output RES,
    output VBAT,
    output VDD,
    output [11:0] SEG,
    output [15:0] LD,
    output SOUND,
    output ACTIVE_LOW
    );

assign ACTIVE_LOW = 1;

wire [3:0] signalOut1;
wire [3:0] signalOut2;
wire [3:0] signalOut3;
wire [3:0] signalOut4;

//reg [23:0] r_period;
wire [23:0] soundDataOut1;
wire [23:0] soundDataOut2;
wire [23:0] soundDataOut3;
wire [23:0] soundDataOut4;

wire [19:0] ToSeq1;
wire [19:0] ToSeq2;
wire [19:0] ToSeq3;
wire [19:0] ToSeq4;

wire [9:0] ToBram1;
wire [9:0] ToBram2;
wire [9:0] ToBram3;
wire [9:0] ToBram4;

wire [6:0] ToPWM;
wire [27:0] multiplexer;

reg [23:0] dina;

PmodOLEDCtrl Display(
		.CLK(CLK),
		.RST(RESET),
		.BTNU(BTNU),
        .BTNL(START),
        .BTND(BTND),
		.CS(CS),
		.SDIN(SDIN),
		.SCLK(SCLK),
		.DC(DC),
		.RES(RES),
		.VBAT(VBAT),
		.VDD(VDD)
    );

blk_mem_gen_0 b0(
    .clka(CLK),
    .wea(0),
    .ena(1),
    .addra(ToBram1),
    .dina(dina),
    .douta(ToSeq1)
);

  assign LD[15:12] = (ToSeq1[19:16] == 4'hC) ? 4'h0 : ToSeq1[19:16];

blk_mem_gen_1 b1(
    .clka(CLK),
    .wea(0),
    .ena(1),
    .addra(ToBram2),
    .dina(dina),
    .douta(ToSeq2)
);

  assign LD[11:8] = (ToSeq2[19:16] == 4'hC) ? 4'h0 : ToSeq2[19:16];

blk_mem_gen_2 b2(
    .clka(CLK),
    .wea(0),
    .ena(1),
    .addra(ToBram3),
    .dina(dina),
    .douta(ToSeq3)
);

  assign LD[7:4] = (ToSeq3[19:16] == 4'hC) ? 4'h0 : ToSeq3[19:16];
    
blk_mem_gen_4 noiseBRAM(
  .addra(ToBram4),
  .clka(CLK),
  .douta(ToSeq4),
  .ena(1)
);

  assign LD[3:0] = (ToSeq4[19:16] == 4'hC) ? 4'h0 : ToSeq4[19:16];

wire [3:0] volumeToCh1;
wire [3:0] volumeToCh2;
wire [3:0] volumeToCh3;
wire [3:0] volumeToCh4;

wire counterSig;
wire [11:0] tempo;

tenMSecCounter tmsCounter(
  .CLK(CLK),
  .RESET(RESET),
  .tempo(tempo),
  .SW(SW[15:8]),
  .counterSig(counterSig)
  );

sequencer seq1(
  .CLK(CLK),
  .RESET(RESET),
  .BTN(BTN),
  .tenMSecCountSig(counterSig),
  .soundDataIn(ToSeq1),
  .BRAMaddr(ToBram1),
  .soundDataOut(soundDataOut1),
  .soundVolume(volumeToCh1),
  .tempo(tempo)
  );
  
  reg [31:0] counter;
  
  always@(posedge CLK) begin
    if(RESET)
      counter <= 0;
    else
      if(counter == 32'd10000) // 100000000clk <- -> 1sec
        counter <= 0;
      else
        counter <= counter + 1;
  end
  
  reg [11:0] buff;
  reg [1:0] selector;

  always@(posedge CLK) begin
    if(RESET)
      selector <= 0;
    else
      if(counter == 32'd10000)
        selector <= (selector == 2'b10) ? 0 : selector + 1;
      else
        selector <= selector;
  end
   
  always@(posedge CLK) begin
    if(selector == 2'b00) begin
      case(ToBram1[9:8])
        2'h0: buff <= 12'b1011_1_1000000; // 0
        2'h1: buff <= 12'b1011_1_1111001; // 1
        2'h2: buff <= 12'b1011_1_0100100; // 2
        2'h3: buff <= 12'b1011_1_0110000; // 3
        default: buff <= 12'b1011_1_1111111; // off
      endcase
    end
    else if(selector == 2'b01) begin
      case(ToBram1[7:4])
        4'h0: buff <= 12'b1101_1_1000000; // 0
        4'h1: buff <= 12'b1101_1_1111001; // 1
        4'h2: buff <= 12'b1101_1_0100100; // 2
        4'h3: buff <= 12'b1101_1_0110000; // 3
        4'h4: buff <= 12'b1101_1_0011001; // 4
        4'h5: buff <= 12'b1101_1_0010010; // 5
        4'h6: buff <= 12'b1101_1_0000010; // 6
        4'h7: buff <= 12'b1101_1_1011000; // 7
        4'h8: buff <= 12'b1101_1_0000000; // 8
        4'h9: buff <= 12'b1101_1_0010000; // 9
        4'hA: buff <= 12'b1101_1_0001000; // A
        4'hB: buff <= 12'b1101_1_0000011; // B
        4'hC: buff <= 12'b1101_1_0100111; // C
        4'hD: buff <= 12'b1101_1_0100001; // D
        4'hE: buff <= 12'b1101_1_0000110; // E
        4'hF: buff <= 12'b1101_1_0001110; // F
        default: buff <= 12'b1101_1_1111111; // off
      endcase
    end
    else if(selector == 2'b10) begin
      case(ToBram1[3:0])
        4'h0: buff <= 12'b1110_1_1000000; // 0
        4'h1: buff <= 12'b1110_1_1111001; // 1
        4'h2: buff <= 12'b1110_1_0100100; // 2
        4'h3: buff <= 12'b1110_1_0110000; // 3
        4'h4: buff <= 12'b1110_1_0011001; // 4
        4'h5: buff <= 12'b1110_1_0010010; // 5
        4'h6: buff <= 12'b1110_1_0000010; // 6
        4'h7: buff <= 12'b1110_1_1011000; // 7
        4'h8: buff <= 12'b1110_1_0000000; // 8
        4'h9: buff <= 12'b1110_1_0010000; // 9
        4'hA: buff <= 12'b1110_1_0001000; // A
        4'hB: buff <= 12'b1110_1_0000011; // B
        4'hC: buff <= 12'b1110_1_0100111; // C
        4'hD: buff <= 12'b1110_1_0100001; // D
        4'hE: buff <= 12'b1110_1_0000110; // E
        4'hF: buff <= 12'b1110_1_0001110; // F
        default: buff <= 12'b1110_1_1111111; // off
      endcase
    end
  end
    
  assign SEG = buff;

sequencer seq2(
  .CLK(CLK),
  .RESET(RESET),
  .BTN(BTN),
  .tenMSecCountSig(counterSig),
  .soundDataIn(ToSeq2),
  .BRAMaddr(ToBram2),
  .soundDataOut(soundDataOut2),
  .soundVolume(volumeToCh2)
  );
  
sequencer seq3(
    .CLK(CLK),
    .RESET(RESET),
    .BTN(BTN),
    .tenMSecCountSig(counterSig),
    .soundDataIn(ToSeq3),
    .BRAMaddr(ToBram3),
    .soundDataOut(soundDataOut3)
    );

wire [9:0] randomData;

noiseGenerator seq4(
     .CLK(CLK),
     .RESET(RESET),
     .BTN(BTN),
     .tenMSecCountSig(counterSig),
     .randomData(randomData[7:0]),
     .soundDataIn(ToSeq4),
     .BRAMaddr(ToBram4),
     .soundDataOut(soundDataOut4),
     .soundVolume(volumeToCh4)
     );

LFSR lfsr(
	 .clk(CLK),
	 .seed(10'b1001010100),
	 .reseed(RESET),
	 .out(randomData)
      );

squarewave ch1(
    .CLK(CLK),
    .RESET(RESET),
    .period(multiplexer[27:4]),
    .volume(multiplexer[3:0]),
    .signalOut(signalOut1)
    );
    
    // assign LD[15:12] = signalOut1;
    
squarewave ch2(
    .CLK(CLK),
    .RESET(RESET),
    .period(soundDataOut2),
    .volume(volumeToCh2),
    .signalOut(signalOut2)
    );
    
    // assign LD[11:8] = volumeToCh2;
      
traianglewave_state ch3(
    .CLK(CLK),
    .RESET(RESET),
    .period(soundDataOut3),
    .signalOut(signalOut3)
    );
    
    // assign LD[7:4] = signalOut3;

squarewave ch4(
    .CLK(CLK),
    .RESET(RESET),
    .period(soundDataOut4),
    .volume(4'h0), // volumeToCh4),
    .signalOut(signalOut4)
    );
    
    // assign LD[3:0] = signalOut4;

mixer Mixer(
    .CLK(CLK),
    .RESET(RESET),
    .signal1(signalOut1),
    .signal2(signalOut2),
    .signal3(signalOut3),
    .signal4(signalOut4),
    .mixOut(ToPWM)
    );

pwm PWM(
    .CLK(CLK),
    .RESET(RESET),
    .signalIn(ToPWM[6:3]),
    .pwmOut(SOUND)
    );
    
    wire [7:0] ToESRAM1;
    wire [19:0] ToCoin;

blk_mem_gen_3 es1(
    .clka(CLK),
    .wea(0),
    .ena(1),
    .addra(ToESRAM1),
    .dina(0),
    .douta(ToCoin)
);

wire [23:0] coinSoundData;
wire startCoin;
wire [3:0] coinVolume;
wire active;

coin Coin(
    .CLK(CLK),
    .RESET(RESET),
    .start(startCoin),
    .soundDataIn(ToCoin),
    .BRAMaddr(ToESRAM1),
    .soundDataOut(coinSoundData),
    .soundVolume(coinVolume),
    .active(active)
    );
    
    wire [7:0] ToESRAM2;
    wire [19:0] ToMush;
    
blk_mem_gen_5 es2(
    .clka(CLK),
    .ena(1),
    .addra(ToESRAM2),
    .douta(ToMush)
);

  wire [23:0] mushSoundData;
  wire startMush;
  wire [3:0] mushVolume;
  wire mushActive;

coin Mush(
    .CLK(CLK),
    .RESET(RESET),
    .start(startMush),
    .soundDataIn(ToMush),
    .BRAMaddr(ToESRAM2),
    .soundDataOut(mushSoundData),
    .soundVolume(mushVolume),
    .active(mushActive)
    );
    
wire select;
wire select2;

soundEffectCtrl CoinBTN(
    .CLK(CLK),
    .RESET(RESET),
    .BTNCoin(START),
    .activeCoin(active),
    .allowCoin(startCoin),
    .selectCoin(select),
    .BTNMush(BTND),
    .activeMush(mushActive),
    .allowMush(startMush),
    .selectMush(select2)
    );
    
assign multiplexer = (select) ? {coinSoundData, coinVolume} : ((select2) ? {mushSoundData, mushVolume} : {soundDataOut1, volumeToCh1});

endmodule
