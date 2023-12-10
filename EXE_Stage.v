// module EXE_Stage(
// 	input clk, rst,
// 	input[31:0] PC_in,
// 	output [31:0] PC
// );
// assign PC = PC_in;
// endmodule
module EXE_Stage(
	input clk, rst,
	input[31:0] PC_in,
	output [31:0] PC,

	input wb_en_in,
	input mem_r_en_in,
	input mem_w_en_in,
	input [3:0] exe_cmd,
	input branch_taken_in,
	input [31:0] val_rn,
	input [31:0] val_rm_in,
	input imm,
	input [11:0] shift_operand,
	input [23:0] signed_imm_24,
	input [3:0] dest_in,
	input [3:0] sr_in,

	input [31:0] forwarded_from_exe_reg,
	input [31:0] forwarded_from_wb,
	input [1:0] sel_src1,
	input [1:0] sel_src2,

	output branch_taken_out,
	output wb_en_out,
	output mem_r_en_out,
	output mem_w_en_out,
	output [31:0] alu_res,
	output [31:0] val_rm_out,
	output [3:0] dest_out,
	output [31:0] branch_address,
	output [3:0] sr_out
);
	assign PC = PC_in;
	assign branch_taken_out = branch_taken_in;
	assign wb_en_out =wb_en_in;
	assign mem_r_en_out = mem_r_en_in;
	assign mem_w_en_out = mem_w_en_in;
	wire mem_en;
	assign mem_en = mem_r_en_in || mem_w_en_in;
	wire [31:0] val2;

	reg [31:0] val_rm_selected;
	always @(*) begin
		val_rm_selected = 32'b0;
		case(sel_src2)
			2'b00 : val_rm_selected = val_rm_in;
			2'b01 : val_rm_selected = forwarded_from_exe_reg;
			2'b10 : val_rm_selected = forwarded_from_wb;
			default : val_rm_selected = 32'b0;
		endcase
	end
	
	val2_generator v2g (
    .imm(imm),
    .val_rm(val_rm_selected),
    .shift_operand(shift_operand),
    .mem_en(mem_en),
    .val2(val2)
	);

	reg [31:0] val1;
	always @(*) begin
		val1 = 32'b0;
		case(sel_src1)
			2'b00 : val1 = val_rn;
			2'b01 : val1 = forwarded_from_exe_reg;
			2'b10 : val1 = forwarded_from_wb;
			default : val1 = 32'b0;
		endcase
	end

	ALU alu (
		.val_1(val1),
		.val_2(val2),
		.sr_in(sr_in),
		.exe_cmd(exe_cmd),
		.alu_res(alu_res),
    	.sr_out(sr_out)
	);
	assign val_rm_out = val_rm_selected;
	assign branch_address =  {{6{signed_imm_24[23]}}, signed_imm_24, 2'b00} + PC_in;
	assign dest_out = dest_in;
endmodule 