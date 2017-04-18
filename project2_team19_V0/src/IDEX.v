module IDEX
(
	clk_i,
	WBCtrl_i,
	MemCtrl_i,
	ExCtrl_i,
	Data1_i,
	Data2_i,
	SignExt_i,
	RegRd_i,
	RegRs_i,
	RegRt_i,
	stall_i,
	WBCtrl_o,
	MemCtrl_o,
	ALUSrc_o,
	ALUOp_o,
	RegDst_o,
	Data1_o,
	Data2_o,
	RegRs_o,
	RegRt_o,
	RegRd_o,
	SignExt_o
);

input				clk_i;
input   			stall_i;
input	[1:0]		WBCtrl_i;
input	[1:0]		MemCtrl_i;
input	[3:0]		ExCtrl_i;
input	[31:0]		Data1_i;
input	[31:0]		Data2_i;
input	[31:0]		SignExt_i;
input	[4:0]		RegRd_i;
input	[4:0]		RegRs_i;
input	[4:0]		RegRt_i;
output	[1:0]		WBCtrl_o;
output	[1:0]		MemCtrl_o;
output				ALUSrc_o;
output	[1:0]		ALUOp_o;
output				RegDst_o;
output	[31:0]		Data1_o;
output	[31:0]		Data2_o;
output	[4:0]		RegRs_o;
output	[4:0]		RegRt_o;
output	[4:0]		RegRd_o;
output	[31:0]		SignExt_o;

reg		[1:0]		WBCtrl_o;
reg		[1:0]		MemCtrl_o;
reg					ALUSrc_o;
reg		[1:0]		ALUOp_o;
reg					RegDst_o;
reg		[31:0]		Data1_o;
reg		[31:0]		Data2_o;
reg		[4:0]		RegRs_o;
reg		[4:0]		RegRt_o;
reg		[4:0]		RegRd_o;
reg		[31:0]		SignExt_o;
		

always@(posedge clk_i) begin
	if(stall_i) begin
		WBCtrl_o <= WBCtrl_o;
		MemCtrl_o <= MemCtrl_o;
		ALUSrc_o <= ALUSrc_o;
		ALUOp_o <= ALUOp_o;
		RegDst_o <= RegDst_o;
		Data1_o <= Data1_o;
		Data2_o <= Data2_o;
		RegRs_o <= RegRs_o;
		RegRd_o <= RegRd_o;
		RegRt_o <= RegRt_o;
		SignExt_o <= SignExt_o;
	end
	else begin
		WBCtrl_o <= WBCtrl_i;
		MemCtrl_o <= MemCtrl_i;
		ALUSrc_o <= ExCtrl_i[0];
		ALUOp_o <= ExCtrl_i[2:1];
		RegDst_o <= ExCtrl_i[3];
		Data1_o <= Data1_i;
		Data2_o <= Data2_i;
		RegRs_o <= RegRs_i;
		RegRd_o <= RegRd_i;
		RegRt_o <= RegRt_i;
		SignExt_o <= SignExt_i;
	end
end

endmodule