module CPU
(
	clk_i,
	rst_i,
	start_i,
   
	mem_data_i, 
	mem_ack_i, 	
	mem_data_o, 
	mem_addr_o, 	
	mem_enable_o, 
	mem_write_o
);

//input
input clk_i;
input rst_i;
input start_i;

wire	[31:0]		inst_addr;
wire	[31:0]		inst_line;

wire				nextPC_slt;
wire				IFID_flush;
wire				equal;

assign	nextPC_slt = Control.Ctrl_o[8] & equal;
assign	IFID_flush = nextPC_slt | Control.Ctrl_o[9];
assign	equal = (Registers.RSdata_o == Registers.RTdata_o);

//
// to Data Memory interface		
//
input	[256-1:0]	mem_data_i; 
input				mem_ack_i; 	
output	[256-1:0]	mem_data_o; 
output	[32-1:0]	mem_addr_o; 	
output				mem_enable_o; 
output				mem_write_o; 

//
// add your project1 here!
//

Control Control(
    .Op_i       (inst_line[31:26]),
    .Ctrl_o   	()
);

Adder Add_PC(
    .data1_in  	(inst_addr),
    .data2_in   (32'd4),
    .data_o     ()
);

Adder Add_brn(
	.data1_in	(L2Shifter1.data_o),
	.data2_in	(IFID.nextPC_o),
	.data_o		()
);

MUX8 Mux8(
	.data1_i	(Control.Ctrl_o[7:0]),
	.data2_i	(8'b0),
	.select_i	(HD.IDEXFlush_o),
	.data_o		()
);

PC PC
(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.start_i(start_i),
	.stall_i(dcache.p1_stall_o),
	.pcEnable_i(HD.PCWrite_o),
	.pc_i(PC_In.data_o),
	.pc_o(inst_addr)
);

Instruction_Memory Instruction_Memory(
	.addr_i(inst_addr), 
	.instr_o()
);

Registers Registers(
	.clk_i(clk_i),
	.RSaddr_i(inst_line[25:21]),
	.RTaddr_i(inst_line[20:16]),
	.RDaddr_i(MEMWB.RegRd_o), 
	.RDdata_i(WriteData.data_o),
	.RegWrite_i(MEMWB.RegWrite_o), 
	.RSdata_o(), 
	.RTdata_o() 
);

MUX5 MUX_RegDst(
    .data1_i    (IDEX.RegRt_o),
    .data2_i    (IDEX.RegRd_o),
    .select_i   (IDEX.RegDst_o),
    .data_o     ()
);

MUX32 WriteData (
	.data1_i	(MEMWB.ALU_o),
	.data2_i	(MEMWB.MemRead_o),
	.select_i	(MEMWB.MemtoReg_o),
	.data_o		()
);

MUX32_3 Data1(
	.data1_i	(IDEX.Data1_o),
	.data2_i	(WriteData.data_o),
	.data3_i	(EXMEM.ALU_o),
	.select_i	(FW.Data1Ctrl_o),
	.data_o		()
);

MUX32_3 Data2(
	.data1_i	(IDEX.Data2_o),
	.data2_i	(WriteData.data_o),
	.data3_i	(EXMEM.ALU_o),
	.select_i	(FW.Data2Ctrl_o),
	.data_o		()
);

MUX32 MUX_ALUSrc(
    .data1_i    (Data2.data_o),
    .data2_i    (IDEX.SignExt_o),
    .select_i   (IDEX.ALUSrc_o),
    .data_o     ()
);

Sign_Extend Sign_Extend(
    .data_i     (inst_line[15:0]),
    .data_o     ()
);

L2Shifter L2Shifter1(
	.data_i		(Sign_Extend.data_o),
	.data_o		()
);

L2Shifter L2Shifter2(
	.data_i		({6'b0, inst_line[25:0]}),
	.data_o		()
);

MUX32 NextPC(
	.data1_i	(Add_PC.data_o),
	.data2_i	(Add_brn.data_o),
	.select_i	(nextPC_slt),
	.data_o		()
);

MUX32 PC_In(
	.data1_i	(NextPC.data_o),
	.data2_i	({NextPC.data_o[31:28], L2Shifter2.data_o[27:0]}),
	.select_i	(Control.Ctrl_o[9]),
	.data_o		()
);

ALU ALU(
    .data1_i    (Data1.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (IDEX.SignExt_o[5:0]),
    .ALUOp_i    (IDEX.ALUOp_o),
    .ALUCtrl_o  ()
);

IFID IFID(
	.clk_i		(clk_i),
	.start_i	(start_i),
	.inst_i		(Instruction_Memory.instr_o),
	.nextPC_i	(Add_PC.data_o),
	.IFFlush_i	(IFID_flush),
	.IFID_i		(HD.IFID_o),
	.stall_i	(dcache.p1_stall_o),
	.nextPC_o	(),
	.inst_o		(inst_line)
);

IDEX IDEX(
	.clk_i		(clk_i),
	.WBCtrl_i	(Mux8.data_o[1:0]),
	.MemCtrl_i	(Mux8.data_o[3:2]),
	.ExCtrl_i	(Mux8.data_o[7:4]),
	.Data1_i	(Registers.RSdata_o),
	.Data2_i	(Registers.RTdata_o),
	.SignExt_i	(Sign_Extend.data_o),
	.RegRd_i	(inst_line[15:11]),
	.RegRs_i	(inst_line[25:21]),
	.RegRt_i	(inst_line[20:16]),
	.stall_i	(dcache.p1_stall_o),
	.WBCtrl_o	(),
	.MemCtrl_o	(),
	.ALUSrc_o	(),
	.ALUOp_o	(),
	.RegDst_o	(),
	.Data1_o	(),
	.Data2_o	(),
	.RegRs_o	(),
	.RegRt_o	(),
	.RegRd_o	(),
	.SignExt_o	()
);

EXMEM EXMEM(
	.clk_i		(clk_i),
	.WBCtrl_i	(IDEX.WBCtrl_o),
	.MemCtrl_i	(IDEX.MemCtrl_o),
	.ALU_i		(ALU.data_o),
	.Data2_i	(Data2.data_o),
	.RegRd_i	(MUX_RegDst.data_o),
	.stall_i	(dcache.p1_stall_o),
	.WBCtrl_o	(),
	.ALU_o		(),
	.RegRd_o	(),
	.MemRead_o	(),
	.MemWrite_o	(),
	.Data2_o	()
);

MEMWB MEMWB(
	.clk_i		(clk_i),
	.WBCtrl_i	(EXMEM.WBCtrl_o),
	.Memdata_i	(dcache.p1_data_o),
	.ALU_i		(EXMEM.ALU_o),
	.RegRd_i	(EXMEM.RegRd_o),
	.stall_i	(dcache.p1_stall_o),
	.RegRd_o	(),
	.MemRead_o	(),
	.ALU_o		(),
	.MemtoReg_o	(),
	.RegWrite_o	()
);

HazardDetector	HD(
	.IFID_o		(),
	.PCWrite_o	(),
	.IDEXFlush_o (),
	.RegRs_i	(inst_line[25:21]),
	.RegRt_i	(inst_line[20:16]),
	.MemRead_i	(IDEX.MemCtrl_o[0]),
	.IDEXRegRt_i (IDEX.RegRt_o),
	.start_i	(start_i)
);

ForwardingUnit	FW(
	.Data1Ctrl_o	(),
	.Data2Ctrl_o	(),
	.RegWrite2_i	(MEMWB.RegWrite_o),
	.RegRd2_i		(MEMWB.RegRd_o),
	.RegRd1_i		(EXMEM.RegRd_o),
	.RegRs_i		(IDEX.RegRs_o),
	.RegRt_i		(IDEX.RegRt_o),
	.RegWrite1_i	(EXMEM.WBCtrl_o[1])
);

//data cache
dcache_top dcache
(
    // System clock, reset and stall
	.clk_i(clk_i), 
	.rst_i(rst_i),
	
	// to Data Memory interface		
	.mem_data_i(mem_data_i), 
	.mem_ack_i(mem_ack_i), 	
	.mem_data_o(mem_data_o), 
	.mem_addr_o(mem_addr_o), 	
	.mem_enable_o(mem_enable_o), 
	.mem_write_o(mem_write_o), 
	
	// to CPU interface	
	.p1_data_i(EXMEM.Data2_o), 
	.p1_addr_i(EXMEM.ALU_o), 	
	.p1_MemRead_i(EXMEM.MemRead_o), 
	.p1_MemWrite_i(EXMEM.MemWrite_o), 
	.p1_data_o(), 
	.p1_stall_o()
);

endmodule