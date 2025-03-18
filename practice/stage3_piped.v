// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: stage3_piped.v
//	* Description	: 
// ===================================================

`include		"click_three.v"

module stage3_piped 
(
	input	i_rstn,
	input	i_start,
	input	[7:0]	i_data,
	output	reg	[7:0]	o_data
);


	wire	click1, click2, click3;
	click_three
	u_click_three(
		.i_rstn		(i_rstn		),
		.i_start	(i_start	),
		.o_click1	(click1		),
		.o_click2	(click2		),
		.o_click3	(click3		)
	);

	reg	[7:0]	data1, data2, data3;
	always @(*) begin
		data1=  i_data;
	end
	always @(posedge click1 or negedge i_rstn) begin
		if(!i_rstn)
			data2	<= 0;
		else
			data2	<= data1;
	end
	
	always @(posedge click2 or negedge i_rstn) begin
		if(!i_rstn)
			data3	<= 0;
		else
			data3	<= data2;
	end

	always @(posedge click3 or negedge i_rstn) begin
		if(!i_rstn)
			o_data	<= 0;
		else
			o_data	<= data3;

	end
endmodule
