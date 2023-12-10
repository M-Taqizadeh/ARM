`define EQ 4'b0000
`define NE 4'b0001
`define CS_HS 4'b0010
`define CC_LO 4'b0011
`define MI 4'b0100
`define PL 4'b0101
`define VS 4'b0110
`define VC 4'b0111
`define HI 4'b0000
`define LS 4'b1001
`define GE 4'b1010
`define LT 4'b1011
`define GT 4'b1100
`define LE 4'b1101
`define AL 4'b1110
`define NO 4'b1111

module condition_check(
    input wire [3:0] sr,
    input wire [3:0] cond,
    output reg out
);

wire n, z, c, v;
assign v = sr[0];
assign c = sr[1];
assign z = sr[2];
assign n = sr[3];

always @(sr or cond) begin
    out = 1'b0;
    case(cond)
        `EQ: out = z == 1'b1;
        `NE: out = z == 1'b0;
        `CS_HS: out = c == 1'b1;
        `CC_LO: out = c == 1'b0;
        `MI: out = n == 1'b1;
        `PL: out = n == 1'b0;
        `VS: out = v == 1'b1;
        `VC: out = v == 1'b0;
        `HI: out = {c, z} == 2'b10;
        `LS: out = c == 1'b0 || z == 1'b1;
        `GE: out = n == v;
        `LT: out = n != v;
        `GT: out = (z == 1'b0) && (n == v);
        `LE: out = (z == 1'b1) || (n != v);
        `AL: out = 1'b1;
        `NO: out = 1'b0;
        default: out = 1'b0;
    endcase
end
endmodule