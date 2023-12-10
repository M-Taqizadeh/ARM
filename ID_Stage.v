module ID_Stage(
	/* INPUT */
	clk, rst,
	// WB
	wb_en_in, wb_dest, wb_value,
	// STATUS REGISTER
	sr,
	// Hazard
	hazard,
	// PC - Instruction
	PC_in, Instruction,

	/* OUTPUT */
	// Controller
	wb_en_out, mem_r_enable, mem_w_enable, b, s_out, exe_cmd,
	// REGISTER FILE
	val_rn, val_rm,
	// Instruction
	imm, shift_operand, signed_imm_24, dest,
	// Hazard
	src1, src2, two_src,
	// PC
	PC
);
input clk, rst, wb_en_in, hazard;
input[31:0] PC_in, Instruction, wb_value;
input [3:0] wb_dest, sr;
output wb_en_out, mem_r_enable, mem_w_enable, b, s_out, imm, two_src;
output [3:0] exe_cmd, dest, src1, src2;
output [11:0] shift_operand;
output [23:0] signed_imm_24;
output [31:0] PC, val_rm, val_rn;

wire condition_check, mux9_select;
wire [1:0] mode;
wire [3:0] rn_addr, rm_addr, rd_addr, rd_rm_mux_addr, opcode;

assign imm = Instruction[25];
assign shift_operand = Instruction[11:0];
assign signed_imm_24 = Instruction[23:0];
assign dest = Instruction[15:12];
assign rn_addr = Instruction[19:16];
assign rm_addr = Instruction[3:0];
assign rd_addr = Instruction[15:12];
assign rd_rm_mux_addr = mem_w_enable ? rd_addr : rm_addr;
assign opcode = Instruction[24:21];
assign mode = Instruction[27:26];
assign mux9_select = hazard | (~condition_check);
assign two_src = mem_w_enable | (~imm);
assign src1 = rn_addr;
assign src2 = rd_rm_mux_addr;

wire wb_en_out_cu, mem_r_enable_cu, mem_w_enable_cu, b_cu, s_out_cu;
wire [3:0] exe_cmd_cu;
assign {wb_en_out, mem_r_enable, mem_w_enable, exe_cmd, b, s_out } = mux9_select ? 
							 9'b0: {wb_en_out_cu, mem_r_enable_cu, mem_w_enable_cu, exe_cmd_cu, b_cu, s_out_cu};

ID_controller id_cntrl(
	.opcode(opcode), 
	.mode(mode), 	
	.s_in(Instruction[20]), 
	.wb_en(wb_en_out_cu), 	
	.mem_r_enable(mem_r_enable_cu), 
	.mem_w_enable(mem_w_enable_cu), 
	.exe_cmd(exe_cmd_cu), 
	.b(b_cu), 
	.s_out(s_out_cu)
);

register_file rfile(
	.clk(clk),
    .rst(rst),
    .addr1(rn_addr),
    .addr2(rd_rm_mux_addr),
    .wb_dest(wb_dest),
    .wb_value(wb_value),
    .wb_en(wb_en_in),
    .out1(val_rn),
    .out2(val_rm)
);

condition_check CCheck(
	.sr(sr),
    .cond(Instruction[31:28]),
    .out(condition_check)
);

assign PC = PC_in;

endmodule 