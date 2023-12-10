module MEM_Stage(
	input clk, rst,
	input[31:0] PC_in,
	output [31:0] PC,

	input wb_en_in,
	input mem_r_en_in,
	input mem_w_en,
	input [31:0] alu_res_in,
	input [31:0] val_rm,
	input [3:0] dest_in,

	output wb_en_out,
	output mem_r_en_out,
	output [31:0] alu_res_out,
	output [3:0] dest_out,
	output [31:0] mem_result
);
	assign PC = PC_in;
	assign wb_en_out = wb_en_in;
	assign mem_r_en_out = mem_r_en_in;
	assign alu_res_out = alu_res_in;
	assign dest_out = dest_in;

	Memory mem(
		.clk(clk),
		.rst(rst),
		.mem_read(mem_r_en_in),
		.mem_write(mem_w_en),
		.addr(alu_res_in),
		.data(val_rm),
		.mem_out(mem_result)
	);
endmodule 