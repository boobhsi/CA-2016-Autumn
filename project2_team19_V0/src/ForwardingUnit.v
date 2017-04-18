module ForwardingUnit
(
	RegWrite1_i,
	RegWrite2_i,
	RegRd1_i,
	RegRd2_i,
	RegRs_i,
	RegRt_i,
	Data1Ctrl_o,
	Data2Ctrl_o
);

input				RegWrite1_i;
input				RegWrite2_i;
input	[4:0]		RegRd1_i;
input	[4:0]		RegRd2_i;
input	[4:0]		RegRs_i;
input	[4:0]		RegRt_i;
output	[1:0]		Data1Ctrl_o;
output	[1:0]		Data2Ctrl_o;

reg		[1:0]		Data1Ctrl_o;
reg		[1:0]		Data2Ctrl_o;	

always@(RegRd1_i or RegRd2_i or RegRs_i or RegRt_i or RegWrite1_i or RegWrite2_i) begin
	Data1Ctrl_o <= 2'b00;
	Data2Ctrl_o <= 2'b00;
	if(RegWrite1_i == 1'b1 && (RegRd1_i != 5'b0)) begin
		if(RegRd1_i == RegRs_i) 
			Data1Ctrl_o <= 2'b10;
		if(RegRd1_i == RegRt_i)
			Data2Ctrl_o <= 2'b10;
	end
	if(RegWrite2_i == 1'b1 && (RegRd2_i != 5'b0)) begin
		if((RegRd2_i == RegRs_i) && !(RegWrite1_i == 1'b1 && (RegRd1_i != 5'b0) && (RegRd1_i == RegRs_i)))
			Data1Ctrl_o <= 2'b01;
		if((RegRd2_i == RegRt_i) && !(RegWrite1_i == 1'b1 && (RegRd1_i != 5'b0) && (RegRd1_i == RegRt_i)))
			Data2Ctrl_o <= 2'b01;
	end
end

endmodule