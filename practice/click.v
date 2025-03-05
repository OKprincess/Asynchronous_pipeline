// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: click.v
//	* Date			: 2025-03-05 
//	* Description	: 
// ===================================================
`include		"dff.v"

module click 
(
	output		o_click,
	output		o_reqR,
	output		o_ackL,
	input 		i_reqL,
	input 		i_ackR,

	input 		i_rstn
);


	wire		xor_out, xnor_out, and_out;
	wire		dff_outL, dff_outR;

	xor		#(6)(xor_out, i_reqL, dff_outL);
	xnor	#(9)(xnor_out, dff_outR, i_ackR);
	and		#(4)(and_out, xor_out, xnor_out);

	wire		n_dff_outL, n_dff_outR;
	not		#(3)(n_dff_outL, dff_outL);
	not		#(3)(n_dff_outR, dff_outR);

	dff
	u_dffL(
		.o_q	(dff_outL	),
		.i_d	(n_dff_outL	),
		.i_clk	(and_out	),
		.i_rstn	(i_rstn		)
	);
	
	dff
	u_dffR(
		.o_q	(dff_outR	),
		.i_d	(n_dff_outR	),
		.i_clk	(and_out	),
		.i_rstn	(i_rstn		)
	);

	assign		o_click	= and_out;
	assign		o_reqR	= dff_outR;
	assign		o_ackL	= dff_outL;
	
endmodule
