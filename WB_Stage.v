module WB_Stage(
	input clk, rst,
	input[31:0] PC_in,
	output [31:0] PC,

	input mem_r_en,
	input [31:0] alu_result,
	input [31:0] mem_result,
	output [31:0] out
);
	assign PC = PC_in;
	assign out = mem_r_en ? mem_result : alu_result;
endmodule 