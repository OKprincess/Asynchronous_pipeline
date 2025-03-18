// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: click_three.v
//	* Description	: 
// ===================================================
`include			"click.v"

module click_three 
(
	output	o_click1,
	output	o_click2,
	output	o_click3,

	input	i_start,
	input	i_rstn
);
	
	wire	ack1, ack2, ack3;
	reg		req1;
	wire	req, req2, req3;
	wire	req_ack;

	click
	u_click1(
		.o_click	(o_click1	),
		.o_reqR		(req2		),
		.o_ackL		(ack1		),
		.i_reqL		(req1),
		.i_ackR		(ack2		),
		.i_rstn		(i_rstn		)
	);

	always @(*) begin
		if(ack1)
			req1 = ~req1;
		else
			req1 = i_start;
	end

	buf #(3) (req, ~req1);
	click
	u_click2(
		.o_click	(o_click2	),
		.o_reqR		(req3		),
		.o_ackL		(ack2		),
		.i_reqL		(req2		),
		.i_ackR		(ack3		),
		.i_rstn		(i_rstn		)
	);

	click
	u_click3(
		.o_click	(o_click3	),
		.o_reqR		(req_ack	),
		.o_ackL		(ack3		),
		.i_reqL		(req3		),
		.i_ackR		(req_ack),
		.i_rstn		(i_rstn		)
	);
endmodule
