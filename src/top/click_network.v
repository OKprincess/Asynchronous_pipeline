// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: click_network.v
//	* Description	: 
// ===================================================
`include		"click.v"

module click_network 
(
	output		o_fire_IF,o_fire_ID, o_fire_EX, o_fire_MEM, o_fire_WB,
	output		o_ackL_IF, o_reqR_WB,
	input		i_reqL_IF, //i_ackR_WB,
	input		i_rstn
);
	
	wire		reqR_IF, reqL_ID;
	wire		reqR_ID, reqL_EX;
	wire		reqR_EX, reqL_MEM;
	wire		reqR_MEM,reqL_WB;
	wire		reqR_WB, reqL_IF;

	wire		ack_IF_ID;
	wire		ack_ID_EX;
	wire		ack_EX_MEM;
	wire		ack_MEM_WB;
	wire		ack_WB_IF;

	click 
	u_click_IF(
		.out_click	(o_fire_IF		),
		.out_ackL	(ack_WB_IF		),
		.out_reqR	(reqR_IF		),
		.in_reqL	(reqL_IF		),
		.in_ackR	(ack_IF_ID		)
	);

	click 
	u_click_ID(
		.out_click	(o_fire_ID		),
		.out_ackL	(ack_IF_ID		),
		.out_reqR	(reqR_ID		),
		.in_reqL	(reqL_ID		),
		.in_ackR	(ack_ID_EX		)
	);

	click 
	u_click_EX(
		.out_click	(o_fire_EX		),
		.out_ackL	(ack_ID_EX		),
		.out_reqR	(reqR_EX		),
		.in_reqL	(reqL_EX		),
		.in_ackR	(ack_EX_MEM		)
	);

	click 
	u_click_MEM(
		.out_click	(o_fire_MEM		),
		.out_ackL	(ack_EX_MEM		),
		.out_reqR	(reqR_MEM		),
		.in_reqL	(reqL_MEM		),
		.in_ackR	(ack_MEM_WB		)
	);

	click 
	u_click_WB(
		.out_click	(o_fire_WB		),
		.out_ackL	(ack_MEM_WB		),
		.out_reqR	(reqR_WB		),
		.in_reqL	(reqL_WB		),
		.in_ackR	(ack_WB_IF		)
	);



endmodule
