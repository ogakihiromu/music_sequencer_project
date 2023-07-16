`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/07 10:12:01
// Design Name: 
// Module Name: soundEffectCtrl
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


module soundEffectCtrl(
    input CLK,
    input RESET,
    input BTNCoin,
    input BTNMush,
    input activeCoin,
    input activeMush,
    output allowCoin,
    output allowMush,
    output selectCoin,
    output selectMush
    );

    assign allowCoin = BTNCoin;
    assign allowMush = BTNMush;
    assign selectCoin = activeCoin;
    assign selectMush = (activeCoin != 1) ? activeMush : 0;

endmodule