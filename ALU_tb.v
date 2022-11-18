`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/17 22:38:12
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();
    
    reg t_clk;
    reg t_rst;
    
    reg [3:0] t_ALU_Control;
    
    reg [31:0] t_oprand_1;
    reg [31:0] t_oprand_2;
    
    reg [31:0] t_data_in_1;
    reg [31:0] t_data_in_2;
    
    wire [31:0] t_data_out;
    wire t_branch_or_not;
    
    ALU ALU_tb(
        .clk(t_clk),
        .rst(t_rst),
        .ALU_Control(t_ALU_Control),
        .oprand_1(t_oprand_1),
        .oprand_2(t_oprand_2),
        .rs_data_in_1(t_data_in_1),
        .rs_data_in_2(t_data_in_2),
        .data_out(t_data_out),
        .branch_or_not(t_branch_or_not)
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
        if (t_data_out != 32'b0 | t_branch_or_not != 1'b0) begin
            $display("Incorrect reset");
            $stop;        
        end    
        
        // test add
        t_ALU_Control = 4'b0000;
        t_oprand_1 = 32'b00000000000000000000000000000001;
        t_oprand_2 = 32'b01000000000000000000000000000001;
        #10;
        if (t_data_out != 32'b01000000000000000000000000000010 | t_branch_or_not != 1'b0) begin
            $display("Incorrect add");
            $stop;        
        end 
        
        // test shift left logical
        t_ALU_Control = 4'b0001;
        t_oprand_1 = 32'b00001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b00010000010000100010010100000000 | t_branch_or_not != 1'b0) begin
            $display("Incorrect shift left logical");
            $stop;        
        end
            
        // set less than (signed)
        t_ALU_Control = 4'b0010;
        t_oprand_1 = 32'b00001000000100000100001000100101;
        t_oprand_2 = 32'b10001000000100000100001000100101;
        #10;
        if (t_data_out != 32'b00000000000000000000000000000000 | t_branch_or_not != 1'b0) begin
            $display("Incorrect set less than (signed)");
            $stop;        
        end
        t_oprand_1 = 32'b10001000000100000100001000100100;
        t_oprand_2 = 32'b10001000000100000100001000100101;
        #10;
        if (t_data_out != 32'b00000000000000000000000000000001 | t_branch_or_not != 1'b0) begin
            $display("Incorrect set less than (signed)");
            $stop;        
        end        
    
        // set less than (unsigned)
        t_ALU_Control = 4'b0011;
        t_oprand_1 = 32'b00001000000100000100001000100101;
        t_oprand_2 = 32'b10001000000100000100001000100101;
        #10;
        if (t_data_out != 32'b00000000000000000000000000000001 | t_branch_or_not != 1'b0) begin
            $display("Incorrect set less than (unsigned)");
            $stop;        
        end
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b10001000000100000100001000100100;
        #10;
        if (t_data_out != 32'b00000000000000000000000000000000 | t_branch_or_not != 1'b0) begin
            $display("Incorrect set less than (unsigned)");
            $stop;        
        end  
          
        // XOR
        t_ALU_Control = 4'b0100;
        t_oprand_1 = 32'b00001000000100000100001000100101;
        t_oprand_2 = 32'b00010000001000001000010001001011;
        #10;
        if (t_data_out != 32'b00011000001100001100011001101110 | t_branch_or_not != 1'b0) begin
            $display("Incorrect XOR");
            $stop;        
        end
            
        // shift right logical
        t_ALU_Control = 4'b0101;
        t_oprand_1 = 32'b00001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b00000000000010000001000001000010 | t_branch_or_not != 1'b0) begin
            $display("Incorrect shift right logical");
            $stop;        
        end
            
        // OR
        t_ALU_Control = 4'b0110;
        t_oprand_1 = 32'b00001000000100000100001000100101;
        t_oprand_2 = 32'b00010000001000001000010001001011;
        #10;
        if (t_data_out != 32'b00011000001100001100011001101111 | t_branch_or_not != 1'b0) begin
            $display("Incorrect OR");
            $stop;        
        end
        
        // AND
        t_ALU_Control = 4'b0111;
        t_oprand_1 = 32'b00001000000100000100001000100101;
        t_oprand_2 = 32'b00010000001000001000010001001011;
        #10;
        if (t_data_out != 32'b00000000000000000000000000000001 | t_branch_or_not != 1'b0) begin
            $display("Incorrect AND");
            $stop;        
        end
            
        // substract
        t_ALU_Control = 4'b1010;
        t_oprand_1 = 32'b00000000000000000000000000000001;
        t_oprand_2 = 32'b01000000000000000000000000000001;
        #10;
        if (t_data_out != 32'b11000000000000000000000000000000 | t_branch_or_not != 1'b0) begin
            $display("Incorrect substract");
            $stop;        
        end 
            
        // shift right arithmetic
        t_ALU_Control = 4'b1011;
        t_oprand_1 = 32'b00001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b00000000000010000001000001000010 | t_branch_or_not != 1'b0) begin
            $display("Incorrect shift right arithmetic");
            $stop;        
        end
        
        t_ALU_Control = 4'b1011;
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11111111100010000001000001000010 | t_branch_or_not != 1'b0) begin
            $display("Incorrect shift right arithmetic");
            $stop;        
        end
                        
        // BEQ: branch if data 1 equal to data 2
        t_ALU_Control = 4'b1000;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100101;
        t_data_in_2 = 32'b10001000000100000100001000100101;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b1) begin
            $display("Incorrect BEQ");
            $stop;        
        end
        t_ALU_Control = 4'b1000;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100101;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b0) begin
            $display("Incorrect BEQ");
            $stop;        
        end
                        
        // BNE: branch if data 1 not equal to data 2
        t_ALU_Control = 4'b1001;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100101;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b1) begin
            $display("Incorrect BNE");
            $stop;        
        end
        t_ALU_Control = 4'b1001;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100101;
        t_data_in_2 = 32'b10001000000100000100001000100101;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b0) begin
            $display("Incorrect BNE");
            $stop;        
        end
            
        // BLT: branch if data 1 less than data 2
        t_ALU_Control = 4'b1100;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100101;
        t_data_in_2 = 32'b00001000000100000100001000100101;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b1) begin
            $display("Incorrect BLT");
            $stop;        
        end
        t_ALU_Control = 4'b1100;
        // data that will be compared
        t_data_in_1 = 32'b00001000000100000100001000100101;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b0) begin
            $display("Incorrect BLT");
            $stop;        
        end
        t_ALU_Control = 4'b1100;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100100;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b0) begin
            $display("Incorrect BLT");
            $stop;        
        end

        // BGE: branch if data 1 greater than or equal to data 2
        t_ALU_Control = 4'b1101;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100101;
        t_data_in_2 = 32'b00001000000100000100001000100101;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b0) begin
            $display("Incorrect BGE");
            $stop;        
        end
        t_ALU_Control = 4'b1101;
        // data that will be compared
        t_data_in_1 = 32'b00001000000100000100001000100101;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b1) begin
            $display("Incorrect BGE");
            $stop;        
        end
        t_ALU_Control = 4'b1101;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100100;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b1) begin
            $display("Incorrect BGE");
            $stop;        
        end
            
        // BLTU: branch if unsigned data 1 less than unsigned data 2
        t_ALU_Control = 4'b1110;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100101;
        t_data_in_2 = 32'b00001000000100000100001000100101;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b0) begin
            $display("Incorrect BLTU");
            $stop;        
        end
        t_ALU_Control = 4'b1110;
        // data that will be compared
        t_data_in_1 = 32'b00001000000100000100001000100101;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b1) begin
            $display("Incorrect BLTU");
            $stop;        
        end
        t_ALU_Control = 4'b1110;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100100;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b0) begin
            $display("Incorrect BLTU");
            $stop;        
        end    
    
        // BGEU: branch if unsigned data 1 greater than or equal to data 2
        t_ALU_Control = 4'b1111;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100101;
        t_data_in_2 = 32'b00001000000100000100001000100101;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b1) begin
            $display("Incorrect BGEU");
            $stop;        
        end
        t_ALU_Control = 4'b1111;
        // data that will be compared
        t_data_in_1 = 32'b00001000000100000100001000100101;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b0) begin
            $display("Incorrect BGEU");
            $stop;        
        end
        t_ALU_Control = 4'b1111;
        // data that will be compared
        t_data_in_1 = 32'b10001000000100000100001000100100;
        t_data_in_2 = 32'b10001000000100000100001000100100;
        // oprands are PC and immediate
        t_oprand_1 = 32'b10001000000100000100001000100101;
        t_oprand_2 = 32'b01000000000000000000000000001000;
        #10;
        if (t_data_out != 32'b11001000000100000100001000101101 | t_branch_or_not != 1'b1) begin
            $display("Incorrect BGEU");
            $stop;        
        end    
    
    
        $display("all tests passed");
        $finish;         
    end
    

endmodule
