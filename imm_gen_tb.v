`timescale 1ns / 1ps
module imm_gen_tb();
reg t_clk;
reg [31:0]t_instr;
wire [31:0]t_imm_out;

imm_gen dut_imm_gen(
    .instr(t_instr),
    .imm_out(t_imm_out)
);

always #5 t_clk = ~t_clk;

initial begin
    t_clk <= 0;
    t_instr <= 32'h0;    //default output
    #10
    if (t_imm_out != 32'h0) begin
        $display("Incorrect default output.");
        $stop;
    end
    t_instr <= 32'h6cdff6e7; //I-type without shift positive
    #10
    if (t_imm_out != 32'h000006cd) begin
        $display("Incorrect I-type sign extension for postive value.");
        $stop;
    end
    t_instr <= 32'h8cdff603; //I-type without shift negative
    #10
    if (t_imm_out != 32'hfffff8cd) begin
        $display("Incorrect I-type sign extension for negative value.");
        $stop;
    end
    t_instr <= 32'h1465d13; //I-type shift
    #10
    if (t_imm_out != 32'h00000014) begin
        $display("Incorrect I-type sign extension for shift amount.");
        $stop;
    end
    t_instr <= 32'hc003b313; //I-type SLTIU
    #10
    if (t_imm_out != 32'h00000c00) begin
        $display("Incorrect I-type sign extension for shift amount.");
        $stop;
    end
    t_instr <= 32'h02dff6a3; //S-type positive
    #10
    if (t_imm_out != 32'h0000002d) begin
        $display("Incorrect S-type sign extension for positive value.");
        $stop;
    end
    t_instr <= 32'ha2dff623; //S-type negative
    #10
    if (t_imm_out != 32'hfffffa2c) begin
        $display("Incorrect S-type sign extension for negative value.");
        $stop;
    end
    t_instr <= 32'h75834863; //B-type positive
    #10
    if (t_imm_out != 32'h00000750) begin
        $display("Incorrect B-type sign extension for positive value.");
        $stop;
    end
    t_instr <= 32'hf1eed7e3; //B-type negative
    #10
    if (t_imm_out != 32'hffffff0e) begin
        $display("Incorrect B-type sign extension for negative value.");
        $stop;
    end
    t_instr <= 32'h12345637; //U-type positive
    #10
    if (t_imm_out != 32'h12345000) begin
        $display("Incorrect U-type sign extension for positive value.");
        $stop;
    end
    t_instr <= 32'habcdef97; //U-type negative
    #10
    if (t_imm_out != 32'habcde000) begin
        $display("Incorrect U-type sign extension for negative value.");
        $stop;
    end
    t_instr <= 32'h6669996f; //J-type positive
    #10
    if (t_imm_out != 32'h00099666) begin
        $display("Incorrect J-type sign extension for positive value.");
        $stop;
    end
    t_instr <= 32'h888888ef; //J-type negative
    #10
    if (t_imm_out != 32'hfff88088) begin
        $display("Incorrect J-type sign extension for negative value.");
        $stop;
    end   
    $display("All tests passed.");
    $stop;
end
endmodule