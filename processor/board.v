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
reg en,rst
always@(btnL) rst = 1;
always@(posedge clock) begin
    if (~btnL == 0 && rst == 1) rst = 0;
end
always@(btnR) begin
    if(en == 1) en = 0;
    else en = 1;
end
    
processor design_processor(
    .clk0(CLK100MHZ),
    .rst0(btnL),
    .en0(btnR),
    .sw(sw),
    .led(LED)
);
endmodule
