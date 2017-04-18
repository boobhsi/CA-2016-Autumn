module MUX32_3
(
	data1_i,
	data2_i,
	data3_i,
	select_i,
	data_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
input	[31:0]		data3_i;
output	[31:0]		data_o;
input 	[1:0]		select_i;

assign 	data_o		=	(select_i == 2'b00) ? data1_i :
						(select_i == 2'b01) ? data2_i :
						(select_i == 2'b10) ? data3_i :
						32'bx;
						
endmodule