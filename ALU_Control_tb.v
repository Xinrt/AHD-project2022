`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/17 22:38:38
// Design Name: 
// Module Name: ALU_Control_tb
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


module ALU_Control_tb();

    reg t_clk;
    reg t_rst;
    
    reg [1:0] t_ALUOP;
    reg t_f7b2;
    reg [2:0] t_f3;
    
    wire [3:0] t_ALU_Control;
    
    ALU_Control ALU_Control_tb(
        .clk(t_clk),
        .rst(t_rst),
        .ALUOP(t_ALUOP),
        .funct7_bit2(t_f7b2),
        .funct3(t_f3),
        .ALU_Control(t_ALU_Control)
    );

    always begin
        #5 
        t_clk = ~t_clk;
    end
    
    initial begin
        t_clk = 1;
        t_rst = 1;
        #5;
        t_rst = 0;

        // test reset
        #10;
        if (t_ALU_Control != 4'b0) begin
            $display("Incorrect reset");
            $stop;        
        end
        
        // load/store instruction or LUI/AUIPC/JAL/JALR instruction
        t_ALUOP = 2'b00;
        #10;
        if (t_ALU_Control != 4'b0) begin
            $display("Incorrect ALU Control for ALUOP 00");
            $stop;        
        end             
        
        // Branch instruction
        t_ALUOP = 2'b01;
        #10;
        // BEQ
        t_f3 = 3'b000;
        #10;
        if (t_ALU_Control != 4'b1000) begin
            $display("Incorrect ALU Control for ALUOP 01");
            $stop;        
        end
        // BNE
        t_f3 = 3'b001;
        #10;
        if (t_ALU_Control != 4'b1001) begin
            $display("Incorrect ALU Control for ALUOP 01");
            $stop;        
        end
        // BLT
        t_f3 = 3'b100;
        #10;
        if (t_ALU_Control != 4'b1100) begin
            $display("Incorrect ALU Control for ALUOP 01");
            $stop;        
        end
        // BGE
        t_f3 = 3'b101;
        #10;
        if (t_ALU_Control != 4'b1101) begin
            $display("Incorrect ALU Control for ALUOP 01");
            $stop;        
        end
        // BLTU
        t_f3 = 3'b110;
        #10;
        if (t_ALU_Control != 4'b1110) begin
            $display("Incorrect ALU Control for ALUOP 01");
            $stop;        
        end
        // BGEU
        t_f3 = 3'b111;
        #10;
        if (t_ALU_Control != 4'b1111) begin
            $display("Incorrect ALU Control for ALUOP 01");
            $stop;        
        end
                
        // I-type instruction or R-type instruction
        t_ALUOP = 2'b10;
        t_f7b2 = 1'b0;
        #10;
        // add
        t_f3 = 3'b000;
        #10;       
        if (t_ALU_Control != 4'b0000)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end
        // shift left logical
        t_f3 = 3'b001;
        #10;       
        if (t_ALU_Control != 4'b0001)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end
        // set less than (signed)
        t_f3 = 3'b010;
        #10;       
        if (t_ALU_Control != 4'b0010)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end
        // set less than (unsigned) 
        t_f3 = 3'b011;
        #10;       
        if (t_ALU_Control != 4'b0011)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end
        // XOR
        t_f3 = 3'b100;
        #10;       
        if (t_ALU_Control != 4'b0100)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end
        // shift right logical 
        t_f3 = 3'b101;
        #10;       
        if (t_ALU_Control != 4'b0101)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end
        // OR
        t_f3 = 3'b110;
        #10;       
        if (t_ALU_Control != 4'b0110)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end
        // AND
        t_f3 = 3'b111;
        #10;       
        if (t_ALU_Control != 4'b0111)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end

        // substract
        t_f7b2 = 1'b1;
        t_f3 = 3'b000;
        #10;       
        if (t_ALU_Control != 4'b1010)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end
        // shift right arithetic
        t_f3 = 3'b101;
        #10;       
        if (t_ALU_Control != 4'b1011)begin
            $display("Incorrect ALU Control for ALUOP 10");
            $stop; 
        end
                          
        $display("all tests passed");
        $finish;         
    end

endmodule
