module MUX5
(
	data1_i,
	data2_i,
	select_i,
	data_o
);

input	[4:0]		data1_i;
input	[4:0]		data2_i;
output	[4:0]		data_o;
input 				select_i;

assign 	data_o		=	(select_i) ? data2_i : data1_i;

endmodule