`timescale 1ns/1ns
`define HALF_CLK 5
`define CLK 10
module arm_tb();
    reg clk, rst;
    wire [31:0] pc_out;
    
    initial clk = 1'b0;
    always #`HALF_CLK clk = ~clk;
    
    arm_wrap AWS_NF(
        .clk(clk),
        .rst(rst),
        .pc_out(pc_out),
        .forwarding_en(1'b0)
    );
    
    arm_wrap AWS_F(
        .clk(clk),
        .rst(rst),
        .pc_out(pc_out),
        .forwarding_en(1'b1)
    );
    
    initial begin
        rst = 1'b1;
        #`CLK rst = 1'b0;
        #(500 * `CLK) 
        $stop;
    end
endmodule
