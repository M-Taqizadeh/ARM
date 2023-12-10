module IF_Stage_Reg(
	input clk, rst, freeze, flush,
	input[31:0] PC_in, Instruction_in,
	output reg [31:0] PC, Instruction
);
always @(posedge clk, posedge rst)
  begin
	if (rst)
		{PC, Instruction} <= 64'd0;
	else if (flush)
		{PC, Instruction} <= 64'd0;
	else if (freeze == 1'b0) begin
		PC <= PC_in;
		Instruction <= Instruction_in;
	end
  end
endmodule 