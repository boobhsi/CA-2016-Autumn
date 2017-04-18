module MUX32
(
	data1_i,
	data2_i,
	select_i,
	data_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;

output	[31:0]		data_o;
input				select_i;

assign data_o		=	(select_i) ? data2_i : data1_i;

endmodule
