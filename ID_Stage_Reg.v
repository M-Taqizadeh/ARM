module ID_Stage_Reg(
	input clk, rst, flush, wb_en_in, mem_r_enable_in,
			mem_w_enable_in, b_in, s_in, imm_in,
	input [3:0] exe_cmd_in, dest_in, sr_in, 
	input [11:0] shift_operand_in,
	input [23:0] signed_imm_24_in,
	input [31:0] PC_in, val_rn_in, val_rm_in,
	input [3:0] src1_in, src2_in,
	output reg [3:0] src1_out, src2_out,
	output reg wb_en_out, mem_r_enable_out, mem_w_enable_out,
			b_out, s_out, imm_out,
	output reg [3:0] exe_cmd_out, dest_out, sr_out,
	output reg [11:0] shift_operand_out,
	output reg [23:0] signed_imm_24_out,
	output reg [31:0] PC, val_rn_out, val_rm_out
);
always @(posedge clk, posedge rst)
  begin
	if (rst) begin
		{PC, val_rm_out, val_rn_out} <= 96'd0;
		{signed_imm_24_out} <= 24'd0;
		{shift_operand_out} <= 12'd0;
		{exe_cmd_out, dest_out, sr_out} <= 12'd0;
		{wb_en_out, mem_r_enable_out, mem_w_enable_out, b_out, s_out, imm_out} = 6'd0;
		src1_out <= 4'b0;
		src2_out <= 4'b0;
	end
	else if (flush) begin
		{PC, val_rm_out, val_rn_out} <= 96'd0;
		{signed_imm_24_out} <= 24'd0;
		{shift_operand_out} <= 12'd0;
		{exe_cmd_out, dest_out, sr_out} <= 12'd0;
		{wb_en_out, mem_r_enable_out, mem_w_enable_out, b_out, s_out, imm_out} = 6'd0;
		src1_out <= 4'b0;
		src2_out <= 4'b0;
	end
	else begin
      	{PC, val_rm_out, val_rn_out} <= {PC_in, val_rm_in, val_rn_in};
		{signed_imm_24_out} <= {signed_imm_24_in};
		{shift_operand_out} <= {shift_operand_in};
		{exe_cmd_out, dest_out, sr_out} <= {exe_cmd_in, dest_in, sr_in};
		{wb_en_out, mem_r_enable_out, mem_w_enable_out, b_out, s_out, imm_out} = {wb_en_in, mem_r_enable_in, mem_w_enable_in, b_in, s_in, imm_in};
		src1_out <= src1_in;
		src2_out <= src2_in;
	end
  end
endmodule 