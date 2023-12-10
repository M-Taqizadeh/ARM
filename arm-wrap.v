module arm_wrap(
clk, rst, pc_out, forwarding_en
);
input clk, rst, forwarding_en;
output [31:0] pc_out;

 wire [31:0] pc_if,
                pc_if_reg_out,
                pc_id,
                pc_id_reg,
                pc_exe,
                pc_exe_reg,
                pc_mem,
                pc_mem_reg,
                pc_wb;

    wire [31:0] instruction_if, instruction_if_reg_out;            
    wire freeze, flush;
    // ID
    wire wb_en_id_out, mem_r_enable_id_out, mem_w_enable_id_out, b_id_out, s_id_out;
    wire [3:0] exe_cmd_id_out;
    wire [31:0] val_rm_id_out, val_rn_id_out;
    wire imm_id_out;
    wire [23:0] signed_imm_24_id_out;
    wire [3:0] dest_id_out;
    wire [11:0] shift_operand_id_out;

    wire two_src;
    wire [3:0] src1_id_out, src2_id_out;

    // Exec
    wire wb_en_exec_in, mem_r_enable_exec_in, mem_w_enable_exec_in,
         branch_taken_exec_in, s_exec_in, imm_exec_in;
	wire [3:0] exe_cmd_exec_in, dest_exec_in, sr_exec_in; 
	wire [11:0] shift_operand_exec_in;
	wire [23:0] signed_imm_24_exec_in;
	wire [31:0] val_rn_exec_in, val_rm_exec_in;

    wire branch_taken_exec_out, wb_en_exec_out,
        mem_r_en_exec_out, mem_w_en_exec_out;
    wire [3:0] dest_exec_out;
    wire [31:0] alu_res_exec_out, val_rm_exec_out;
	wire [31:0] branch_address_exec_out;
	wire [3:0] sr_exec_out;


    // Mem
    wire wb_en_mem_in, mem_r_en_mem_in, mem_w_en_mem_in;
    wire [31:0] alu_res_mem_in, val_rm_mem_in;
    wire [3:0] dest_mem_in;
    wire [31:0] data_memory_mem_out;

    // WB
    wire wb_en_wb_in, mem_r_en_wb_in;
    wire [31:0] alu_res_wb_in, data_memory_wb_in;
    wire [31:0] wb_value_wb_in;
    wire [3:0] wb_dest_wb_in;

    // SR
    wire [3:0] sr_out;

    // HZ
    wire hazard;

    //FORWARDING
    wire [3:0] src1_exe;
    wire [3:0] src2_exe;
    wire [1:0] sel_src1;
    wire [1:0] sel_src2;

    assign freeze = hazard;
    assign flush = branch_taken_exec_in;

    assign pc_out = pc_wb;

    IF_Stage IFS(
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .branch_taken(branch_taken_exec_in),
        .BranchAddr(branch_address_exec_out),
        .PC(pc_if),
        .Instruction(instruction_if)
    );

    IF_Stage_Reg IFSR (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .flush(flush),
        .PC_in(pc_if),
        .Instruction_in(instruction_if),
        .PC(pc_if_reg_out),
        .Instruction(instruction_if_reg_out)
    );

    /////////////////////////////////////////////////////

    ID_Stage IDS (
        .clk(clk),
        .rst(rst),
        .PC_in(pc_if_reg_out),
        .PC(pc_id),
        .Instruction(instruction_if_reg_out),
        .wb_en_in(wb_en_wb_in),
        .wb_dest(wb_dest_wb_in), 
        .wb_value(wb_value_wb_in),
        .sr(sr_out),
        .hazard(hazard),
        .wb_en_out(wb_en_id_out), 
        .mem_r_enable(mem_r_enable_id_out), 
        .mem_w_enable(mem_w_enable_id_out), 
        .b(b_id_out), 
        .s_out(s_id_out), 
        .exe_cmd(exe_cmd_id_out),
        .val_rn(val_rn_id_out), 
        .val_rm(val_rm_id_out),
        .imm(imm_id_out), 
        .shift_operand(shift_operand_id_out), 
        .signed_imm_24(signed_imm_24_id_out), 
        .dest(dest_id_out),
        .src1(src1_id_out), 
        .src2(src2_id_out), 
        .two_src(two_src)
    );

    ID_Stage_Reg IDSR (
        .clk(clk),
        .rst(rst),
        .PC_in(pc_id),
        .PC(pc_id_reg),
        .flush(flush), .wb_en_in(wb_en_id_out), .mem_r_enable_in(mem_r_enable_id_out),
        .mem_w_enable_in(mem_w_enable_id_out), .b_in(b_id_out), .s_in(s_id_out), .imm_in(imm_id_out),
        .exe_cmd_in(exe_cmd_id_out), .dest_in(dest_id_out), 
        .sr_in(sr_out), 
        .shift_operand_in(shift_operand_id_out),
        .signed_imm_24_in(signed_imm_24_id_out),
        .val_rn_in(val_rn_id_out), .val_rm_in(val_rm_id_out),
        .src1_in(src1_id_out),
        .src2_in(src2_id_out),

        .src1_out(src1_exe),
        .src2_out(src2_exe),
        .wb_en_out(wb_en_exec_in), .mem_r_enable_out(mem_r_enable_exec_in), .mem_w_enable_out(mem_w_enable_exec_in),
        .b_out(branch_taken_exec_in), .s_out(s_exec_in), .imm_out(imm_exec_in),
        .exe_cmd_out(exe_cmd_exec_in), .dest_out(dest_exec_in), .sr_out(sr_exec_in),
        .shift_operand_out(shift_operand_exec_in),
        .signed_imm_24_out(signed_imm_24_exec_in),
        .val_rn_out(val_rn_exec_in), .val_rm_out(val_rm_exec_in)
    );


    /////////////////////////////////////////////////////

    EXE_Stage EXES (
        .clk(clk),
        .rst(rst),
        .PC_in(pc_id_reg),
        .PC(pc_exe),
        .wb_en_in(wb_en_exec_in),
        .mem_r_en_in(mem_r_enable_exec_in),
        .mem_w_en_in(mem_w_enable_exec_in),
        .exe_cmd(exe_cmd_exec_in),
        .branch_taken_in(branch_taken_exec_in),
        .val_rn(val_rn_exec_in),
        .val_rm_in(val_rm_exec_in),
        .imm(imm_exec_in),
        .shift_operand(shift_operand_exec_in),
        .signed_imm_24(signed_imm_24_exec_in),
        .dest_in(dest_exec_in),
        .sr_in(sr_exec_in),

        .forwarded_from_exe_reg(alu_res_mem_in),
        .forwarded_from_wb(wb_value_wb_in),
        .sel_src1(sel_src1),
        .sel_src2(sel_src2),

        .branch_taken_out(branch_taken_exec_out),
        .wb_en_out(wb_en_exec_out),
        .mem_r_en_out(mem_r_en_exec_out),
        .mem_w_en_out(mem_w_en_exec_out),
        .alu_res(alu_res_exec_out),
        .val_rm_out(val_rm_exec_out),
        .dest_out(dest_exec_out),
        .branch_address(branch_address_exec_out),
        .sr_out(sr_exec_out)
    );

    EXE_Stage_Reg EXESR (
        .clk(clk),
        .rst(rst),
        .PC_in(pc_exe),
        .PC(pc_exe_reg),
        .wb_en_in(wb_en_exec_out),
        .mem_r_en_in(mem_r_en_exec_out),
        .mem_w_en_in(mem_w_en_exec_out),
        .alu_res_in(alu_res_exec_out),
        .val_rm_in(val_rm_exec_out),
        .dest_in(dest_exec_out),

        .wb_en_out(wb_en_mem_in),
        .mem_r_en_out(mem_r_en_mem_in),
        .mem_w_en_out(mem_w_en_mem_in),
        .alu_res_out(alu_res_mem_in),
        .val_rm_out(val_rm_mem_in),
        .dest_out(dest_mem_in)
    );

    // /////////////////////////////////////////////////////
    wire mem_r_en_mem_out, wb_en_mem_out;
    wire [31:0] alu_res_mem_out;
    wire [3:0] dest_mem_out;

    MEM_Stage MS (
        .clk(clk),
        .rst(rst),
        .PC_in(pc_exe_reg),
        .PC(pc_mem),
        .wb_en_in(wb_en_mem_in),
        .mem_r_en_in(mem_r_en_mem_in),
        .mem_w_en(mem_w_en_mem_in),
        .alu_res_in(alu_res_mem_in),
        .val_rm(val_rm_mem_in),
        .dest_in(dest_mem_in),

        .wb_en_out(wb_en_mem_out),
        .mem_r_en_out(mem_r_en_mem_out),
        .alu_res_out(alu_res_mem_out),
        .dest_out(dest_mem_out),
        .mem_result(data_memory_mem_out)
    );

    MEM_Stage_Reg MSR(
        .clk(clk),
        .rst(rst),
        .PC_in(pc_mem),
        .PC(pc_mem_reg),

        .wb_en_in(wb_en_mem_out),
        .mem_r_en_in(mem_r_en_mem_out),
        .alu_res_in(alu_res_mem_out),
        .mem_result_in(data_memory_mem_out),
        .dest_in(dest_mem_out),
        
        .wb_en_out(wb_en_wb_in),
        .mem_r_en_out(mem_r_en_wb_in),
        .alu_res_out(alu_res_wb_in),
        .mem_result_out(data_memory_wb_in),
        .dest_out(wb_dest_wb_in)
    );

    /////////////////////////////////////////////////////

    WB_Stage WBS(
        .clk(clk),
        .rst(rst),
        .PC_in(pc_mem_reg),
        .PC(pc_wb),
        .mem_r_en(mem_r_en_wb_in),
        .alu_result(alu_res_wb_in),
        .mem_result(data_memory_wb_in),

        .out(wb_value_wb_in)
    );

    /////////////////////////////////////////////////////

    status_reg SRARM(
        .clk(clk),
        .rst(rst),
        .s(s_exec_in),
        .sr_in(sr_exec_out),

        .sr_out(sr_out)
    );

    hazard_detector HD(
        .forwarding_en(forwarding_en),
        .mem_wb_en(wb_en_mem_in),
        .exe_wb_en(wb_en_exec_in),
        .two_src(two_src),
        .mem_dest(dest_mem_in),
        .exe_dest(dest_exec_in),
        .src1(src1_id_out),
        .src2(src2_id_out),
        .mem_r_en_mem_stage(mem_r_en_mem_in),

        .hazard(hazard)
    );

    ForwardingUnit FU(
        .src1(src1_exe),
        .src2(src2_exe),
        .dest_mem_stage(dest_mem_in),
        .dest_wb_stage(wb_dest_wb_in),
        .wb_en_mem_stage(wb_en_mem_in),
        .wb_en_wb_stage(wb_en_wb_in),

        .sel_src1(sel_src1),
        .sel_src2(sel_src2)
    );
endmodule 