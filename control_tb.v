`timescale 1ns / 1ps

module control_tb();
reg t_clk, t_rst;   //test inputs
reg [6:0]t_opcode;
wire t_pcW, t_imemR, t_br, t_ALUsrc1, t_ALUsrc2;    //test outputs
wire [1:0]t_dmemRW;
wire [1:0]t_dmem2Reg;
wire [1:0]t_regRW;
wire [1:0]t_ALUOp;
reg [6:0]f_opcode;  //test data from file
reg [12:0]ife;
reg [12:0]exe;
reg [12:0]mem;
reg [12:0]wb;
reg [12:0]signals;
integer f, r, i;    //for reading from file and iteration
reg [12:0]stages[0:3];  //for storing each stages' signals
control dut(
    .clk(t_clk),
    .rst(t_rst),
    .opcode(t_opcode),
    .br(t_br),
    .dmemRW(t_dmemRW),
    .dmem2Reg(t_dmem2Reg),
    .ALUOp(t_ALUOp),
    .ALUsrc1(t_ALUsrc1),
    .ALUsrc2(t_ALUsrc2),
    .regRW(t_regRW),
    .pcW(t_pcW),
    .imemR(t_imemR));
    
always #5 t_clk = ~t_clk;   //make clock

initial begin
    f = $fopen("control_tb.csv","r");
    t_clk <= 0;
    t_rst <= 1; //reset to start
    #1
    t_rst <= 0;
    while(!$feof(f)) begin
        r = $fscanf(f, "%b,%b,%b,%b,%b", f_opcode,ife,exe,mem,wb);  //get data from file
        stages[0] = ife;
        stages[1] = exe;
        stages[2] = mem;
        stages[3] = wb;
        t_opcode <= f_opcode;
        $display("testing opcode: %b",t_opcode);    //display current opcode under test
        for (i = 0; i < 4; i = i+1) begin
            signals = stages[i];
            if (i == 0) $display("  testing IF stage...");  //display current stage under test
            if (i == 1) $display("  testing EXE stage...");
            if (i == 2) $display("  testing MEM stage...");
            if (i == 3) $display("  testing WB stage...");
            if (signals != 13'b1111111111111) begin //skip MEM stage if needed
                if (t_br != signals[12]) begin
                    $display("Incorrect branch control signal.");
                    $stop;
                end
                if (t_dmemRW != signals[11:10]) begin
                    $display("Incorrect DMEM read/write signal.");
                    $stop;
                end
                if (t_dmem2Reg != signals[9:8]) begin
                    $display("Incorrect write back source selection.");
                    $stop;
                end
                if (t_ALUOp != signals[7:6]) begin
                    $display("Incorrect ALU operation type.");
                    $stop;
                end
                if (t_ALUsrc1 != signals[5]) begin
                    $display("Incorrect ALU source1 selection.");
                    $stop;
                end
                if (t_ALUsrc2 != signals[4]) begin
                    $display("Incorrect ALU source2 selection.");
                    $stop;
                end
                if (t_regRW != signals[3:2]) begin
                    $display("Incorrect RF read/write signal.");
                    $stop;
                end
                if (t_pcW != signals[1]) begin
                    $display("Incorrect PC write signal.");
                    $stop;
                end
                if (t_imemR != signals[0]) begin
                    $display("Incorrect IMEM read signal.");
                    $stop;
                end
                #10 $display("  stage passed");
            end
            else $display(" MEM stage skipped");
        end
    end
    $display("All tests passed.");
    $stop;
end
endmodule
