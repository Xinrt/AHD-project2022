`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/16 17:15:22
// Design Name: 
// Module Name: board
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


module board(
    input wire CLK100MHZ,
    input wire [15:0] sw,
    input wire btnL,
    input wire btnR,
    output wire [15:0] LED
);
    
processor design_proceddor(
    .clk0(CLK100MHZ),
    .rst0(btnL),
    .en0(btnR),
    .sw(sw),
    .led(LED)
);
endmodule
