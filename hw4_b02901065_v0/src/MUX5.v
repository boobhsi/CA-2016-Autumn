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

/*
always@(data1_i or data2_i or select_i) begin
	if(select_i)
		temp <= data2_i;
	else
		temp <= data1_i;
end
*/
endmodule