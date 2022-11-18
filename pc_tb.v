`timescale 1ns / 1ps
module pc_tb();
reg t_clk, t_rst, t_pcW;
reg [31:0]t_addr_in;
wire [31:0]t_addr_out;
pc dut_pc(
    .clk(t_clk),
    .rst(t_rst),
    .pcW(t_pcW),
    .addr_in(t_addr_in),
    .addr_out(t_addr_out)
);
always #5 t_clk = ~t_clk;

initial begin
    t_addr_in <= 32'h88;
    t_clk <= 0;
    t_rst <= 1;
    t_pcW <= 1;
    #10
    if (t_addr_out != 32'h01000000) begin       //test reset
        $display("Incorrect pc reset behavior.");
        $stop;
    end
    t_rst <= 0;
    #10
    if (t_addr_out != 32'h88) begin              //test random address
        $display("Incorrect pc output.");
        $stop;
    end
    t_addr_in <= 32'hbeef;
    #15
    if (t_addr_out != 32'hbeef) begin           //test random address
        $display("Incorrect pc output.");
        $stop;
    end
    t_pcW <= 0;
    #5
    if (t_addr_out != 32'hbeef) begin           //test write pc disabled
        $display("Incorrect disabled pc behavior.");
        $stop;
    end
    $display("All tests passed.");
    $stop;
end
endmodule