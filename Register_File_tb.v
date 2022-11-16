`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/16 00:00:53
// Design Name: 
// Module Name: Register_File_tb
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


module Register_File_tb();
    
    reg t_clk;
    reg t_rst;
    
    reg [4:0] t_read_addr_1;
    reg [4:0] t_read_addr_2;
    reg [4:0] t_write_addr;
    
    reg [31:0] t_write_data;
    wire [31:0] t_read_data_1;
    wire [31:0] t_read_data_2;
    
    integer i;
    
    Register_File Register_File_tb(
        .clk(t_clk),
        .rst(t_rst),
        .read_addr_1(t_read_addr_1),
        .read_addr_2(t_read_addr_2),
        .write_addr(t_write_addr),
        .write_data(t_write_data),
        .read_data_1(t_read_data_1),
        .read_data_2(t_read_data_2)
    );
    
    always begin
        #5 
        t_clk = ~t_clk;
    end
    
    initial begin
        t_clk = 0;
        t_rst = 1;
        #5
        
        // test initial reset
        for (i = 0; i < 32; i = i + 1) begin
            t_read_addr_1 = i;
            t_read_addr_2 = i;
            #5
            if (t_read_data_1 != 32'b0 | t_read_data_2 != 32'b0) begin
                $display("Incorrect initial reset");
                $stop;
            end
            #5;
        end
        
        t_rst = 0;
        // write f0f0f0f0 to R1 and read it to first output
        t_write_addr = 5'b00001;
        t_write_data = 32'b11110000111100001111000011110000;
        t_read_addr_1 = 5'b00001;
        #5
        if (t_read_data_1 != 32'b11110000111100001111000011110000) begin
            $display("Incorrect write and read");
            $stop;
        end
        #5;
        
        // write 0f0f0f0f to R31 and read it to second output
        t_write_addr = 5'b11111;
        t_write_data = 32'b00001111000011110000111100001111;
        t_read_addr_2 = 5'b11111;
        #5
        if (t_read_data_2 != 32'b00001111000011110000111100001111) begin
            $display("Incorrect write and read");
            $stop;
        end
        #5;
        
        // write f0f0f0f0 to R0 (it should fail because R0 is always 0) and read it to first output
        t_write_addr = 5'b00000;
        t_write_data = 32'b11110000111100001111000011110000;
        t_read_addr_1 = 5'b00000;
        #5
        if (t_read_data_1 != 32'b0) begin
            $display("Incorrect write and read");
            $stop;
        end
        #5;
        
        // reset all registers and test
        t_rst = 1;
        for (i = 0; i < 32; i = i + 1) begin
            t_read_addr_1 = i;
            t_read_addr_2 = i;
            #5
            if (t_read_data_1 != 32'b0 | t_read_data_2 != 32'b0) begin
                $display("Incorrect reset");
                $stop;
            end
            #5;
        end       
        
        $display("all tests passed");
        $finish;
        
    end
    
endmodule
