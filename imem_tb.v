`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/16 19:52:35
// Design Name: 
// Module Name: imem_tb
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


module imem_tb();
    reg  t_clk;
    reg  t_rst;
    reg  t_en;
    reg  [31:0] t_addr;
    wire [31:0] t_instr_out;
    
    imem dut(
        .clk(t_clk),
        .rst(t_rst),
        .en(t_en),
        .addr(t_addr),
        .instr_out(t_instr_out)
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
        t_en = 1;
        t_rst = 1;
        #5;
        // test initial reset
        t_addr = 32'h01000000;
        if(t_instr_out != 32'h00100093) begin
            $display("Incorrect initial reset");
            $stop;
        end
        
//        $display(t_clk);
        t_rst = 0;    
        t_addr = 32'h01000000;
//        $display(t_addr);
//        $display(t_instr_out);
        #5;
        if(t_instr_out!=32'h00100093) begin
            $display("Not reading the value at desired address correctly");
            $stop; 
        end        
        #5;
        
//        $display(t_clk);
        t_rst = 0;    
        t_addr = 32'h01000004;
//        $display(t_addr);
//        $display(t_instr_out);
        #5;
        if(t_instr_out!=32'h00200113) begin
            $display("Not reading the value at desired address correctly");
            $stop; 
        end       
        #5;
                
        t_rst = 0;    
        t_addr = 32'h01000008;
//        $display(t_addr);
//        $display(t_instr_out);
        #5;
        if(t_instr_out!=32'h002080b3) begin
            $display("Not reading the value at desired address correctly");
            $stop; 
        end
        
        #5;
        t_rst = 0;    
        t_addr = 32'h0100000c;
//        $display(t_addr);
//        $display(t_instr_out);
        #5;
        if(t_instr_out!=32'hffdff06f) begin
            $display("Not reading the value at desired address correctly");
            $stop; 
        end
        
        // test enable signal
        #5;
        t_en = 0;
        t_rst = 0;    
        t_addr = 32'h0100000c;
//        $display(t_addr);
//        $display(t_instr_out);
        #5;
        if(t_instr_out!=32'h00000000) begin
            $display("Enable signal not work correctly");
            $stop; 
        end

      
        $display("All tests passed");
        $finish;
    end 
   
endmodule
