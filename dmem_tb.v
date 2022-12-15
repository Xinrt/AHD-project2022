`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/16 22:50:18
// Design Name: 
// Module Name: dmem_tb
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


module dmem_tb();
    reg  t_clk;
    reg  t_rst;
    reg  [1:0] t_en;
    reg  [3:0] t_we;
    reg  [31:0] t_addr;
    reg  [31:0] t_din;
    wire [31:0] t_dout;
    wire t_outofbound;
    
    dmem dut(
        .clk(t_clk),
        .rst(t_rst),
        .dmemRW(t_en),
        .w_en(t_we),
        .addr(t_addr),
        .din(t_din),
        .dout(t_dout),
        .outofbound(t_outofbound)
    );
    
    initial begin
        forever begin
            t_clk <=1;
            #5;
            t_clk <=0;
            #5;
        end
    end
    
    initial begin
        t_din=32'h20221118;
        // 00100000 00100010 00010001 00011000
        
        t_rst=1'b1;
        t_we=4'b0001;
        t_addr=32'h80000000;
        #5
        
        // test initial reset
        $display(t_dout);
        if(t_dout != 32'h00000000) begin
            $display("Incorrect initial reset");
            $stop;
        end
     
        #5;
        t_rst=1'b0;
        t_en = 2'b01;
        t_we=4'b0001;
        t_addr=32'h80000000;
        #5;
        if(t_dout!=32'h00000000) begin
            $display("Not write correctly");
            $stop;
        end
        
        #5
        t_rst=1'b0;
        t_en = 2'b01;
        t_we=4'b0010;
        t_addr=32'h80000000;
        #5;
        if(t_dout!=32'h00000000) begin
            $display("Not write correctly");
            $stop;
        end
        
        #5;      
        t_rst=1'b0;
        t_en = 2'b01;
        t_we=4'b0100;
        t_addr=32'h80000000;
        #5;
        if(t_dout!=32'h00000000) begin
            $display("Not write correctly");
            $stop;
        end
        
        #5;      
        t_rst=1'b0;
        t_en = 2'b01;
        t_we=4'b1000;
        t_addr=32'h80000000;
        #5;
        if(t_dout!=32'h00000000) begin
            $display("Not write correctly");
            $stop;
        end
        
        #5;      
        t_rst=1'b0;
        t_en = 2'b01;
        t_we=4'b0011;
        t_addr=32'h80000000;
        #5;
        if(t_dout!=32'h00000000) begin
            $display("Not write correctly");
            $stop;
        end
        
        #5;      
        t_rst=1'b0;
        t_en = 2'b10;
        t_we=4'b0011;
        t_addr=32'h00100000;
        #5;
        if(t_dout!=32'h11987251) begin
            $display("Not read correctly");
            $stop;
        end

        #5;      
        t_rst=1'b0;
        t_en = 2'b10;
        t_we=4'b0011;
        t_addr=32'h00100004;
        #5;
        if(t_dout!=32'h18790475) begin
            $display("Not read correctly");
            $stop;
        end
        
        #5;      
        t_rst=1'b0;
        t_en = 2'b10;
        t_we=4'b0011;
        t_addr=32'h00100008;
        #5;
        if(t_dout!=32'h10257233) begin
            $display("Not read correctly");
            $stop;
        end               
        
        // test enable signal     
        #5;      
        t_rst=1'b0;
        t_en = 2'b00;
        t_we=4'b0011;
        t_addr=32'h00100008;
        #5;
        if(t_dout!=32'h00000000) begin
            $display("Enable signal not work correctly");
            $stop;
        end     
        
        #5;      
        t_rst=1'b0;
        t_en = 2'b11;
        t_we=4'b0011;
        t_addr=32'h00100008;
        #5;
        if(t_dout!=32'h00000000) begin
            $display("Enable signal not work correctly");
            $stop;
        end   
        
        $display("All tests passed");
        $finish;
    end
endmodule
