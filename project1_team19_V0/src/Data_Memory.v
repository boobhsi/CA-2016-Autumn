module Data_Memory
(
	Address_i,
	Write_i,
	MemWrite_i,
	MemRead_i,
	Read_o
);

input	[31:0]		Address_i;
input	[31:0]		Write_i;
input				MemWrite_i;
input				MemRead_i;
output	[31:0]		Read_o;

reg		[31:0]		memory	[0:7];
reg		[31:0]		Read_o;	

always@(MemWrite_i or MemRead_i or Address_i or Write_i) begin
	if(MemWrite_i)
		memory[Address_i>>2] <= Write_i;
	if(MemRead_i)
		Read_o <= memory[Address_i>>2];
end

endmodule