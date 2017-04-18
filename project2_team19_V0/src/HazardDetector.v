module HazardDetector
(
	RegRs_i,
	RegRt_i,
	MemRead_i,
	IDEXRegRt_i,
	IDEXFlush_o,
	PCWrite_o,
	IFID_o,
	start_i
);

input				start_i;
input	[4:0]		RegRs_i;
input	[4:0]		RegRt_i;
input 	[4:0]		IDEXRegRt_i;
input				MemRead_i;
output				IDEXFlush_o;
output				PCWrite_o;
output				IFID_o;

reg		[2:0]		temp;

assign	IDEXFlush_o = 	temp[0];
assign	PCWrite_o	= 	temp[1];
assign	IFID_o		=	temp[2];

initial begin
	temp <= 3'b111; //使null instruction可以被flush掉
end

always@(MemRead_i or RegRs_i or RegRt_i or IDEXRegRt_i) begin
	if(start_i) begin
		if(MemRead_i && ((RegRt_i == IDEXRegRt_i) || (RegRs_i == IDEXRegRt_i)))
			temp <= 3'b001;
		else
			temp <= 3'b110;
	end
end

endmodule