module ALU
(
	data1_i,
	data2_i,
	ALUCtrl_i,
	data_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
output	[31:0]		data_o;
input 	[2:0]		ALUCtrl_i;

assign	data_o		=	(ALUCtrl_i == 3'b010) ? data1_i + data2_i :
						(ALUCtrl_i == 3'b110) ? data1_i - data2_i :
						(ALUCtrl_i == 3'b001) ? data1_i | data2_i :
						(ALUCtrl_i == 3'b000) ? data1_i & data2_i :
						(ALUCtrl_i == 3'b100) ? data1_i * data2_i :
						3'bx;


endmodule