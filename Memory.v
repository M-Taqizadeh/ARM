module Memory #(
    parameter depth = 256,
    parameter lengt = 4*8
)
(
    input wire clk,
    input wire rst,
    input wire mem_read,
    input wire mem_write,
    input wire [31:0] addr,
    input wire [31:0] data,
    output [31:0] mem_out
);
    reg [lengt - 1 : 0] mem [0 : depth - 1];
    wire [31:0] addr_per_4;
    assign addr_per_4 =  (addr - 1024) >> 2;
    assign mem_out = mem[addr_per_4];
    always @(negedge clk) begin
        if (mem_write) begin
            mem[addr_per_4] = data;
        end
    end
endmodule