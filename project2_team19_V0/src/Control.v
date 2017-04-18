module Control
(
	Op_i,
	Ctrl_o
);

input	[5:0]		Op_i;
output	[9:0]		Ctrl_o;

assign Ctrl_o		=	(Op_i == 6'b000000) ? 10'b0011100010 :
						(Op_i == 6'b001000) ? 10'b0000110010 :
						(Op_i == 6'b100011) ? 10'b0000110111 :
						(Op_i == 6'b101011) ? 10'b00x011100x :
						(Op_i == 6'b000100) ? 10'b01xxxx000x :
						(Op_i == 6'b000010) ? 10'b10xxxx000x :
						10'b00xxxx000x;

endmodule