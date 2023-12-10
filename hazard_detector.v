module hazard_detector (
        input mem_wb_en,
        input exe_wb_en,
        input two_src,
        input [3:0] mem_dest,
        input [3:0] exe_dest,
        input [3:0] src1,
        input [3:0] src2,
        input forwarding_en,
        input mem_r_en_mem_stage,

        output hazard
    );
    wire hazard1, hazard2, hazard3, hazard4;
    wire hazard_without_forwarding;
    wire hazard_with_forwarding;

    assign hazard1 = src1 == exe_dest && exe_wb_en;
    assign hazard2 = src1 == mem_dest && mem_wb_en;
    assign hazard3 = src2 == exe_dest && exe_wb_en && two_src;
    assign hazard4 = src2 == mem_dest && mem_wb_en && two_src;

    assign hazard_without_forwarding = hazard1 | hazard2 | hazard3 | hazard4;
    assign hazard_with_forwarding = hazard_without_forwarding & mem_r_en_mem_stage;

    assign hazard = forwarding_en ? hazard_with_forwarding : hazard_without_forwarding;
endmodule