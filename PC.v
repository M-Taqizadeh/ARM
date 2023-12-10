module PC (clk, rst, pc_in, freeze, pc_out);
  input [31:0] pc_in;
  input rst, clk, freeze;
  output reg[31:0] pc_out;
  
  always @(posedge clk, posedge rst)
  begin
	if (rst)
		pc_out <= 32'd0;
	else if (freeze == 1'b0)
      pc_out <= pc_in;
  end
endmodule