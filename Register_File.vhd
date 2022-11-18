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
    
    reg [1:0] t_read_or_write;
    
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
        .read_or_write(t_read_or_write),
        .read_addr_1(t_read_addr_1),
        .read_addr_2(t_read_addr_2),
        .write_addr(t_write_addr),
        .write_data(t_write_data),
        .read_data_1(t_read_data_1),
        .read_data_2(t_read_data_2)
    );
    
    always begin
        #5; 
        t_clk = ~t_clk;
    end
    
    initial begin
        t_clk = 1;
        t_rst = 1;
        t_read_or_write = 2'b00;
        #5;
        
        // remove reset and enable whole RF
        t_rst = 0;
        
        // write f0f0f0f0 to R1 and read it to first output
        t_write_addr = 5'b00001;
        t_write_data = 32'b11110000111100001111000011110000;
        t_read_addr_1 = 5'b00001;
        #10
        // cannot read or write, so output should be 0
        if (t_read_data_1 != 32'b0) begin
            $display("Incorrect write and read");
            $stop;
        end
        // read only and cannot write
        t_read_or_write = 2'b01;
        #10;
        if (t_read_data_1 != 32'b0) begin
            $display("Incorrect write and read");
            $stop;
        end
        // write enable
        t_read_or_write = 2'b10;        
        #10;        
        if (t_read_data_1 != 32'b0) begin
            $display("Incorrect write and read");
            $stop;
        end
        // read enable, and output will be same as input
        t_read_or_write = 2'b01;
        #10; 
        if (t_read_data_1 != 32'b11110000111100001111000011110000) begin
            $display("Incorrect write and read");
            $stop;
        end
        #10;        

        // write 0f0f0f0f to R31 and read it to second output
        t_write_addr = 5'b11111;
        t_write_data = 32'b00001111000011110000111100001111;
        t_read_addr_2 = 5'b11111;
        #10
        // cannot read or write, so output should be 0
        if (t_read_data_2 != 32'b0) begin
            $display("Incorrect write and read");
            $stop;
        end
        // read only and cannot write
        t_read_or_write = 2'b01;
        #10;
        if (t_read_data_2 != 32'b0) begin
            $display("Incorrect write and read");
            $stop;
        end
        // write enable
        t_read_or_write = 2'b10;        
        #10;        
        if (t_read_data_2 != 32'b0) begin
            $display("Incorrect write and read");
            $stop;
        end
        // read enable, and output will be same as input
        t_read_or_write = 2'b01;
        #10; 
        if (t_read_data_2 != 32'b00001111000011110000111100001111) begin
            $display("Incorrect write and read");
            $stop;
        end
        #10;
        
        // write 0f0f0f0f to R0 and read it to second output. R0 should always be 0 and cannot be write in other data.
        t_write_addr = 5'b00000;
        t_write_data = 32'b00001111000011110000111100001111;
        t_read_addr_2 = 5'b00000;
        t_read_or_write = 2'b10;
        #10;
        // enable read
        t_read_or_write = 2'b01;
        #10; 
        if (t_read_data_2 != 32'b0) begin
            $display("Incorrect, R0 has been written in");
            $stop;
        end
        #10;

        // reset all registers and test
        t_rst = 1;
        #10;
        // stop reset (otherwise read_data will always be 0)
        t_rst = 0;
        #10;
        // enable read
        t_read_or_write = 2'b01;
        for (i = 0; i < 32; i = i + 1) begin
            t_read_addr_1 = i;
            t_read_addr_2 = i;
            #10
            if (t_read_data_1 != 32'b0 | t_read_data_2 != 32'b0) begin
                $display("Incorrect reset");
                $stop;
            end
        end       
        
        $display("all tests passed");
        $finish;
        
    end
    
endmodule
