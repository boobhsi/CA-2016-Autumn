module ALU_Control
(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);

input	[1:0]		ALUOp_i;
input	[5:0]		funct_i;
output	[2:0]		ALUCtrl_o;

assign	ALUCtrl_o	=	(ALUOp_i == 2'b01) ? 3'b010 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b0000)) ? 3'b010 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b1000)) ? 3'b100 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b0010)) ? 3'b110 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b0100)) ? 3'b000 :
						((ALUOp_i == 2'b11) && (funct_i[3:0] == 4'b0101)) ? 3'b001 :
						3'bx;

/*
always@(ALUOp_i) begin
	case(ALUOp_i)
		2'b00:	temp <= 3'b010;
		2'b01:	temp <= 3'b110;
		2'b10:	temp <= 3'b001;	
		2'b11:
			case(funct_i[3:0])
				4'b0000:	temp <= 3'b010;
				4'b0010:	temp <= 3'b110;
				4'b0100:	temp <= 3'b000;
				4'b0101:	temp <= 3'b001;
				4'b1010:	temp <= 3'b111;
			endcase
	endcase		
end
*/
endmodule