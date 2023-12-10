module register_file #(
    parameter depth = 15,
    parameter lengt = 32,
    parameter clog2_depth = $clog2(depth)
)
(
    input wire clk,
    input wire rst,
    input wire [clog2_depth - 1 : 0] addr1,
    input wire [clog2_depth - 1 : 0] addr2,
    input wire [clog2_depth - 1 : 0] wb_dest,
    input wire [lengt - 1 : 0] wb_value,
    input wire wb_en,
    output [lengt - 1 : 0] out1,
    output [lengt - 1 : 0] out2
);
    reg [lengt - 1 : 0] mem [0 : depth - 1];
    assign out1 = mem[addr1];
    assign out2 = mem[addr2];
    integer reg_count;
    always @(negedge clk or posedge rst) begin
        if(rst) begin
            for (reg_count = 0; reg_count < depth; reg_count = reg_count + 1) begin
                mem[reg_count] = reg_count;
            end
        end else begin
            if(wb_en)begin
                mem[wb_dest] = wb_value;
            end
        end
    end
endmodule

    