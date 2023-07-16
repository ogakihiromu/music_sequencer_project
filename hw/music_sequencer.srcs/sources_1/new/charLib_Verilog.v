`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/07/12 10:59:51
// Design Name: 
// Module Name: charLib_Verilog
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


module charLib_Verilog(
    input clka,
    input[10:0] addra,
    output [7:0] douta
    );
    
blk_mem_gen_Display Display(
    .clka(clka),
    .addra(addra),
    .douta(douta)
    );
    
endmodule
