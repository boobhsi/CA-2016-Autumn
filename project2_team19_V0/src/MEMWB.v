module MEMWB
(
	clk_i,
	WBCtrl_i,
	Memdata_i,
	ALU_i,
	stall_i,
	RegRd_i,
	RegRd_o,
	MemRead_o,
	ALU_o,
	MemtoReg_o,
	RegWrite_o
);

input				stall_i;
input				clk_i;
input	[1:0]		WBCtrl_i;
input	[31:0]		Memdata_i;
input	[31:0]		ALU_i;
input	[4:0]		RegRd_i;
output	[4:0]		RegRd_o;
output	[31:0]		MemRead_o;
output	[31:0]		ALU_o;
output				MemtoReg_o;
output				RegWrite_o;

reg	[4:0]		RegRd_o;
reg	[31:0]		MemRead_o;
reg	[31:0]		ALU_o;
reg				MemtoReg_o;
reg				RegWrite_o;

always@(posedge clk_i) begin
	if(stall_i) begin
		MemtoReg_o <= MemtoReg_o;
		RegWrite_o <= RegWrite_o;
		ALU_o <= ALU_o;
		MemRead_o <= MemRead_o;
		RegRd_o <= RegRd_o;
	end
	else begin
		MemtoReg_o <= WBCtrl_i[0];
		RegWrite_o <= WBCtrl_i[1];
		ALU_o <= ALU_i;
		MemRead_o <= Memdata_i;
		RegRd_o <= RegRd_i;
	end
end

endmodule