module status_reg (
    input wire clk,
    input wire rst,
    input wire s,
    input wire [3:0] sr_in,
    output reg [3:0] sr_out
);
    // sr[3:0] = n, z, c, v
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            sr_out <= 4'b0;
        end else begin
            if (s) begin
                sr_out <= sr_in;
            end
        end
    end
endmodule