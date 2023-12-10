module IF_Stage(
	input clk, rst, freeze, branch_taken,
	input[31:0] BranchAddr,
	output [31:0] PC, Instruction
);

wire [31:0] adder_out, pc_out, mux_out;
assign PC = adder_out;
wire cout;
	PC_reg pc(
		.clk(clk),
		.rst(rst),
		.pc_in(mux_out),
		.freeze(freeze),
		.pc_out(pc_out)
	);
	adder_32b A1(
	.a(pc_out) ,
	.b(32'd4), 
	.cin(1'b0), 
	.cout(cout),
	.sum(adder_out)
	);
	mux2to1_32b M1(
	.i0(adder_out), 
	.i1(BranchAddr), 
	.sel(branch_taken), 
	.y(mux_out)
	);
	
	instruction_mem IM(
	.addr(pc_out),
    .instruction(Instruction)
	);
endmodule 