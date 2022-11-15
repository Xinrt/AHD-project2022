`timescale 1ps / 1ps
module pc_tb();
reg t_clk, t_rst;
reg [31:0]t_addr_in;
wire [31:0]t_addr_out;
pc dut_pc(
    .clk(t_clk),
    .rst(t_rst),
    .addr_in(t_addr_in),
    .addr_out(t_in_out)
);
always #1 t_clk = ~t_clk;

initial begin
    t_addr_in = 32'h0;
    t_clk = 0;
    t_rst = 1;
    #2
    if (t_addr_out != 32'h01000000) begin   //test asynchronous reset
        $display("Incorrect pc reset behavior.");
        $stop;
    end
    t_rst = 0;
    #2
    if (t_addr_out != 32'h0) begin          //test address 0
        $display("Incorrect pc output.");
        $stop;
    end
    t_addr_in = 32'hff;
    #3
    if (t_addr_out != 32'hff) begin         //test random address
        $display("Incorrect pc output.");
        $stop;
    end
    t_rst = 1;
    #1
    if (t_addr_out != 32'h01000000) begin   //test reset again
        $display("Incorrect pc reset behavior.");
        $stop;
    end
    $display("All tests passed.");
    $stop;
end
endmodule
