module ForwardingUnit(
    input [3:0] src1,
    input [3:0] src2,
    input [3:0] dest_mem_stage,
    input [3:0] dest_wb_stage,
    input wb_en_mem_stage,
    input wb_en_wb_stage,

    output reg [1:0] sel_src1,
    output reg [1:0] sel_src2
);

    always @(*) begin
        sel_src1 = 2'b00;
        sel_src2 = 2'b00;
        if(wb_en_mem_stage & (src1 == dest_mem_stage))begin
            sel_src1 = 2'b01;
        end else if (wb_en_wb_stage & (src1 == dest_wb_stage))begin
            sel_src1 = 2'b10;
        end

        if(wb_en_mem_stage & (src2 == dest_mem_stage))begin
            sel_src2 = 2'b01;
        end else if (wb_en_wb_stage & (src2 == dest_wb_stage))begin
            sel_src2 = 2'b10;
        end
    end
endmodule