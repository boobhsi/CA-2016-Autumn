module ALU
(
	data1_i,
	data2_i,
	ALUCtrl_i,
	data_o,
	Zero_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
output	[31:0]		data_o;
input 	[2:0]		ALUCtrl_i;
output				Zero_o;

assign	data_o		=	(ALUCtrl_i == 3'b010) ? data1_i + data2_i :
						(ALUCtrl_i == 3'b110) ? data1_i - data2_i :
						(ALUCtrl_i == 3'b001) ? data1_i | data2_i :
						(ALUCtrl_i == 3'b000) ? data1_i & data2_i :
						(ALUCtrl_i == 3'b100) ? data1_i * data2_i :
						3'bx;

/*
always@(ALUCtrl_i) begin
	case(ALUCtrl_i)
		3'b010:	temp <= data1_i + data2_i;
		3'b110:	temp <= data1_i - data2_i;
		3'b001: temp <= data1_i | data2_i;
		3'b000:	temp <= data1_i & data2_i;
	endcase
end
*/
endmodule