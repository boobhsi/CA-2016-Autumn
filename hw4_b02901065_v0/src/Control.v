module Control
(
	Op_i,
	RegDst_o,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o
);

input	[5:0]		Op_i;
output	[1:0]		ALUOp_o;
output				ALUSrc_o;
output				RegWrite_o;
output				RegDst_o;

wire		[4:0]		temp;

assign	ALUOp_o		=	temp[4:3];
assign	ALUSrc_o	=	temp[2];
assign	RegWrite_o	=	temp[1];
assign	RegDst_o	=	temp[0];

assign temp			=	(Op_i == 6'b000000) ? 5'b11011 :
						(Op_i == 6'b001000) ? 5'b01110 :
						5'b00000;

endmodule