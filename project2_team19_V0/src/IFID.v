module IFID
(
	clk_i,
	start_i,
	inst_i,
	nextPC_i,
	IFFlush_i,
	IFID_i,
	stall_i,
	nextPC_o,
	inst_o
);

input 				stall_i;
input				clk_i;
input				start_i;
input	[31:0]		inst_i;
input	[31:0]		nextPC_i;
input				IFFlush_i;
input				IFID_i;
output	[31:0]		nextPC_o;
output	[31:0]		inst_o;

reg		[31:0]		nextPC_o;
reg		[31:0]		inst_o;

always@(posedge clk_i or negedge start_i) begin
	if(IFID_i && start_i) begin
		if(IFFlush_i)
			inst_o <= 32'b0;
		else begin
			if(stall_i)
				inst_o <= inst_o;
			else
				inst_o <= inst_i;
		end
	end
	if(~start_i)
		inst_o <= 32'b11111100000000000000000000000000;
	if(stall_i)
		nextPC_o <= nextPC_o;
	else
		nextPC_o <= nextPC_i;
end

endmodule