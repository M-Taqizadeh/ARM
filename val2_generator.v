module val2_generator (
    input wire imm,
    input wire [31:0] val_rm,
    input wire [11:0] shift_operand,
    input wire mem_en,
    output reg [31:0] val2
);
    wire [11:0] offset_12;
    assign offset_12 = shift_operand;
    wire [7:0] immed_8;
    assign immed_8 = shift_operand[7:0];
    wire [3:0] rotate_imm;
    assign rotate_imm = shift_operand[11:8];
    wire [4:0] shift_imm;
    assign shift_imm = shift_operand[11:7];
    wire [1:0] shift;
    assign shift = shift_operand[6:5];
    always @(*)begin
        val2 = 32'b0;
        if(mem_en)begin
            val2 = {{20{offset_12[11]}}, offset_12};
        end else begin
            case(imm)
                1'b1 : begin //32-bit immediate
                    val2 = ({24'b0, immed_8} >> (rotate_imm << 1)) | ({24'b0, immed_8} << (32 - (rotate_imm << 1))); //rotate right
                end
                1'b0 : begin
                    case(shift_operand[4])
                        1'b0 : begin//immediate shifts
                            case(shift)
                                2'b00 : val2 = val_rm << shift_imm;
                                2'b01 : val2 = val_rm >> shift_imm;
                                2'b10 : val2 = val_rm >>> shift_imm;
                                2'b11 : val2 = (val_rm >> shift_imm) | (val_rm << (32 - shift_imm)); //rotate right
                                default : val2 = 32'b0;
                            endcase
                        end
                        1'b1 : begin //register shifts
                            val2 = 32'b0;
                        end
                        default : val2 = 32'b0;
                    endcase
                end
                default : val2 = 32'b0;
            endcase
        end
    end
endmodule