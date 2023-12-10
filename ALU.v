`define MOV 4'b0001
`define MVN 4'b1001
`define ADD 4'b0010
`define ADC 4'b0011
`define SUB 4'b0100
`define SBC 4'b0101
`define AND 4'b0110
`define ORR 4'b0111
`define EOR 4'b1000
`define CMP 4'b0100
`define TST 4'b0110
`define LDR 4'b0010
`define STR 4'b0010

module ALU (
    input wire signed [31:0] val_1,
    input wire signed [31:0] val_2,
    input wire [3:0] sr_in,
    input wire [3:0] exe_cmd,
    output reg signed  [31:0] alu_res,
    output [3:0] sr_out
);
    wire C_in = sr_in[1];
    wire v_add, v_sub, z, n;
    reg c, v;
    assign sr_out = {n, z, c, v};
    assign n = alu_res[31];
    assign z = alu_res == 32'b0;
    assign v_add = (val_1[31] && val_2[31] && ~alu_res[31]) || (~val_1[31] && ~val_2[31] && alu_res[31]);
    assign v_sub = (val_1[31] && ~val_2[31] && ~alu_res[31]) || (~val_1[31] && val_2[31] && alu_res[31]);
    always @(*) begin
        alu_res = 32'b0;
        c = 1'b0;
        v = 1'b0;
        case(exe_cmd)
            `MOV : alu_res = val_2;
            `MVN : alu_res = ~val_2;
            `ADD : begin {c, alu_res} = val_1 + val_2; v = v_add;end
            `ADC : begin {c, alu_res} = val_1 + val_2 + C_in; v = v_add;end
            `SUB : begin alu_res = val_1 - val_2; v = v_sub;end
            `SBC : begin alu_res = val_1 - val_2 - !C_in; v = v_sub;end
            `AND : alu_res = val_1 & val_2;
            `ORR : alu_res = val_1 | val_2;
            `EOR : alu_res = val_1 ^ val_2;
            `CMP : alu_res = val_1 - val_2;
            `TST : alu_res = val_1 & val_2;
            `LDR : begin {c, alu_res} = val_1 + val_2; v = v_add;end
            `STR : begin {c, alu_res} = val_1 + val_2; v = v_add;end
            default : {v, c, alu_res} = 34'b0;
        endcase
    end
endmodule