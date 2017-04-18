module CPU
(
    clk_i, 
    start_i
);

// Ports
input               clk_i;
input               start_i;

wire	[31:0]		inst_addr;
wire	[31:0]		inst_line;

wire				nextPC_slt;
wire				IFID_flush;
wire				equal;

assign	nextPC_slt = Control.Ctrl_o[8] & equal;
assign	IFID_flush = nextPC_slt | Control.Ctrl_o[9];
assign	equal = (Registers.RSdata_o == Registers.RTdata_o) ? 1 : 0;

Control Control(
    .Op_i       (inst_line[31:26]),
    .Ctrl_o   	()
); //ok

Adder Add_PC(
    .data1_in  	(inst_addr),
    .data2_in   (32'd4),
    .data_o     ()
); //ok

Adder Add_brn(
	.data1_in	(L2Shifter1.data_o),
	.data2_in	(IFID.nextPC_o),
	.data_o		()
); //ok

MUX8 Mux8(
	.data1_i	(Control.Ctrl_o[7:0]),
	.data2_i	(8'b0),
	.select_i	(HD.IDEXFlush_o),
	.data_o		()
); //ok



PC PC(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .pc_i       (PC_In.data_o),
	.pcWrite_i	(HD.PCWrite_o),
    .pc_o       (inst_addr)
); //ok


Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    ()
); //ok

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst_line[25:21]),
    .RTaddr_i   (inst_line[20:16]),
    .RDaddr_i   (MEMWB.RegRd_o), 
    .RDdata_i   (WriteData.data_o),
    .RegWrite_i (MEMWB.RegWrite_o), 
    .RSdata_o   (), 
    .RTdata_o   () 
); //ok


MUX5 MUX_RegDst(
    .data1_i    (IDEX.RegRt_o),
    .data2_i    (IDEX.RegRd_o),
    .select_i   (IDEX.RegDst_o),
    .data_o     ()
); //ok

MUX32 WriteData (
	.data1_i	(MEMWB.ALU_o),
	.data2_i	(MEMWB.MemRead_o),
	.select_i	(MEMWB.MemtoReg_o),
	.data_o		()
); //ok

MUX32_3 Data1(
	.data1_i	(IDEX.Data1_o),
	.data2_i	(WriteData.data_o),
	.data3_i	(EXMEM.ALU_o),
	.select_i	(FW.Data1Ctrl_o),
	.data_o		()
); //ok


MUX32_3 Data2(
	.data1_i	(IDEX.Data2_o),
	.data2_i	(WriteData.data_o),
	.data3_i	(EXMEM.ALU_o),
	.select_i	(FW.Data2Ctrl_o),
	.data_o		()
); //ok


MUX32 MUX_ALUSrc(
    .data1_i    (Data2.data_o),
    .data2_i    (IDEX.SignExt_o),
    .select_i   (IDEX.ALUSrc_o),
    .data_o     ()
); //ok



Sign_Extend Sign_Extend(
    .data_i     (inst_line[15:0]),
    .data_o     ()
); //ok


L2Shifter L2Shifter1(
	.data_i		(Sign_Extend.data_o),
	.data_o		()
); //ok

L2Shifter L2Shifter2(
	.data_i		({6'b0, inst_line[25:0]}),
	.data_o		()
); //ok


MUX32 NextPC(
	.data1_i	(Add_PC.data_o),
	.data2_i	(Add_brn.data_o),
	.select_i	(nextPC_slt),
	.data_o		()
); //ok

MUX32 PC_In(
	.data1_i	(NextPC.data_o),
	.data2_i	({NextPC.data_o[31:28], L2Shifter2.data_o[27:0]}),
	.select_i	(Control.Ctrl_o[9]),
	.data_o		()
); //ok

ALU ALU(
    .data1_i    (Data1.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     ()
); //ok



ALU_Control ALU_Control(
    .funct_i    (IDEX.SignExt_o[5:0]),
    .ALUOp_i    (IDEX.ALUOp_o),
    .ALUCtrl_o  ()
); //ok



IFID IFID(
	.clk_i		(clk_i),
	.start_i	(start_i),
	.inst_i		(Instruction_Memory.instr_o),
	.nextPC_i	(Add_PC.data_o),
	.IFFlush_i	(IFID_flush),
	.IFID_i		(HD.IFID_o),
	.nextPC_o	(),
	.inst_o		(inst_line)
); //ok



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
); //ok



EXMEM EXMEM(
	.clk_i		(clk_i),
	.WBCtrl_i	(IDEX.WBCtrl_o),
	.MemCtrl_i	(IDEX.MemCtrl_o),
	.ALU_i		(ALU.data_o),
	.Data2_i	(Data2.data_o),
	.RegRd_i	(MUX_RegDst.data_o),
	.WBCtrl_o	(),
	.ALU_o		(),
	.RegRd_o	(),
	.MemRead_o	(),
	.MemWrite_o	(),
	.Data2_o	()
); //ok

Data_Memory Data_Memory(
	.Address_i	(EXMEM.ALU_o),
	.Write_i	(EXMEM.Data2_o),
	.MemWrite_i	(EXMEM.MemWrite_o),
	.MemRead_i	(EXMEM.MemRead_o),
	.Read_o		()
); //ok



MEMWB MEMWB(
	.clk_i		(clk_i),
	.WBCtrl_i	(EXMEM.WBCtrl_o),
	.Memdata_i	(Data_Memory.Read_o),
	.ALU_i		(EXMEM.ALU_o),
	.RegRd_i	(EXMEM.RegRd_o),
	.RegRd_o	(),
	.MemRead_o	(),
	.ALU_o		(),
	.MemtoReg_o	(),
	.RegWrite_o	()
); //ok



HazardDetector	HD(
	.IFID_o		(),
	.PCWrite_o	(),
	.IDEXFlush_o (),
	.RegRs_i	(inst_line[25:21]),
	.RegRt_i	(inst_line[20:16]),
	.MemRead_i	(IDEX.MemCtrl_o[0]),
	.IDEXRegRt_i (IDEX.RegRt_o),
	.start_i	(start_i)
); //ok

ForwardingUnit	FW(
	.Data1Ctrl_o	(),
	.Data2Ctrl_o	(),
	.RegWrite2_i	(MEMWB.RegWrite_o),
	.RegRd2_i		(MEMWB.RegRd_o),
	.RegRd1_i		(EXMEM.RegRd_o),
	.RegRs_i		(IDEX.RegRs_o),
	.RegRt_i		(IDEX.RegRt_o),
	.RegWrite1_i	(EXMEM.WBCtrl_o[1])
); //ok




endmodule

