`define MOV 4'b1101
`define MVN 4'b1111
`define ADD 4'b0100
`define ADC 4'b0101
`define SUB 4'b0010
`define SBC 4'b0110
`define AND 4'b0000
`define OR  4'b1100
`define EOR 4'b0001
`define CMP 4'b1010
`define TST 4'b1000

`define RT 2'b00
`define MT 2'b01
`define BT 2'b10

`define LDR 1'b1
`define STR 1'b0

module ID_controller(opcode, mode, s_in, wb_en, 
		mem_r_enable, mem_w_enable, exe_cmd, b, s_out);
input [3:0] opcode;
input [1:0] mode;
input s_in;
output reg wb_en, mem_r_enable, mem_w_enable, b;
output s_out;
output reg [3:0] exe_cmd;

assign s_out = s_in;

always @(mode, opcode, s_in) begin
	{wb_en, mem_r_enable, mem_w_enable, b, exe_cmd} = 8'd0;
	case(mode)
	`RT : begin
			case(opcode)
				`MOV: begin exe_cmd = 4'b0001; wb_en = 1'b1; end
				`MVN: begin exe_cmd = 4'b1001; wb_en = 1'b1; end
				`ADD: begin exe_cmd = 4'b0010; wb_en = 1'b1; end
				`ADC: begin exe_cmd = 4'b0011; wb_en = 1'b1; end
				`SUB: begin exe_cmd = 4'b0100; wb_en = 1'b1; end
				`SBC: begin exe_cmd = 4'b0101; wb_en = 1'b1; end
				`AND: begin exe_cmd = 4'b0110; wb_en = 1'b1; end
				`OR:  begin exe_cmd = 4'b0111; wb_en = 1'b1; end
				`EOR: begin exe_cmd = 4'b1000; wb_en = 1'b1; end
				`CMP: exe_cmd = 4'b0100;
				`TST: exe_cmd = 4'b0110;
			endcase
		end
	`MT : begin
			case(s_in)
				`LDR : begin exe_cmd = 4'b0010; mem_r_enable = 1'b1; wb_en = 1'b1; end
				`STR : begin exe_cmd = 4'b0010; mem_w_enable = 1'b1; wb_en = 1'b0; end
			endcase
		end
	`BT : b = 1'b1;
	endcase
end
endmodule 