module EXMEM
(
	clk_i,
	WBCtrl_i,
	MemCtrl_i,
	ALU_i,
	Data2_i,
	RegRd_i,
	stall_i,
	WBCtrl_o,
	ALU_o,
	RegRd_o,
	MemRead_o,
	MemWrite_o,
	Data2_o
);

input				clk_i;
input				stall_i;
input	[1:0]		WBCtrl_i;
input	[1:0]		MemCtrl_i;
input	[31:0]		ALU_i;
input	[31:0]		Data2_i;
input	[4:0]		RegRd_i;
output	[1:0]		WBCtrl_o;
output	[31:0]		ALU_o;
output	[4:0]		RegRd_o;
output				MemRead_o;
output				MemWrite_o;
output	[31:0]		Data2_o;

reg		[1:0]		WBCtrl_o;
reg					MemWrite_o;
reg					MemRead_o;
reg		[31:0]		ALU_o;
reg		[31:0]		Data2_o;
reg		[4:0]		RegRd_o;

always@(posedge clk_i) begin
	if(stall_i) begin
		WBCtrl_o <= WBCtrl_o;
		ALU_o <= ALU_o;
		RegRd_o <= RegRd_o;
		Data2_o <= Data2_o;
		MemRead_o <= MemRead_o;
		MemWrite_o <= MemWrite_o;
	end
	else begin
		WBCtrl_o <= WBCtrl_i;
		ALU_o <= ALU_i;
		RegRd_o <= RegRd_i;
		Data2_o <= Data2_i;
		MemRead_o <= MemCtrl_i[0];
		MemWrite_o <= MemCtrl_i[1];
	end
end

endmodule