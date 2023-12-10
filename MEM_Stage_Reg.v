module MEM_Stage_Reg(
	input clk, rst,
	input [31:0] PC_in,
	output reg [31:0] PC,
	
	input wire wb_en_in,
	input wire mem_r_en_in,
	input wire [31:0] alu_res_in,
	input wire [31:0] mem_result_in,
	input wire [3:0] dest_in,
	
	output reg wb_en_out,
	output reg mem_r_en_out,
	output reg [31:0] alu_res_out,
	output reg [31:0] mem_result_out,
	output reg [3:0] dest_out
);
	always @(posedge clk, posedge rst) begin
		if (rst) begin
			PC <= 32'd0;
			wb_en_out <= 1'b0;
			mem_r_en_out <= 1'b0;
			alu_res_out <= 32'b0;
			mem_result_out <= 32'b0;
			dest_out <= 4'b0;
		end else begin
			PC <= PC_in;
			wb_en_out <= wb_en_in;
			mem_r_en_out <= mem_r_en_in;
			alu_res_out <=  alu_res_in; 
			mem_result_out <=  mem_result_in; 
			dest_out <= dest_in;
		end
	end
endmodule