// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: reg_type.v
//	* Date			: 2025-03-18 
//	* Description	: 
// ===================================================
`include	"def_delay.v"
`include	"dff_async.v"

module reg_type 
(
	output	o_click,
	// output channel
	output	o_out_req,
	input	i_out_ack,
	// input channel
	input	i_in_req,
	output	o_in_ack,

	input	i_rstn
);
	
	wire	xor_out, xnor_out, and_out;
	wire	dff_outL, dff_outR;

	xor		#(`T_XOR)(xor_out, i_in_req, dff_outL);
	xnor	#(`T_XNOR)(xnor_out, i_out_ack, dff_outR);
	and		#(`T_AND)(and_out, xor_out, xnor_out);

	wire	n_dff_outL, n_dff_outR;
	not		#(`T_NOT)(n_dff_outL, dff_outL);
	not		#(`T_NOT)(n_dff_outR, dff_outR);

	dff_async
	#(
		.BW_DATA	(1				)
	)
	u_dffL(
		.o_q		(dff_outL		),
		.i_d		(n_dff_outL		),
		.i_clk		(and_out		),
		.i_rstn		(i_rstn			)
	);

	dff_async
	#(
		.BW_DATA	(1				)
	)
	u_dffR(
		.o_q		(dff_outR		),
		.i_d		(n_dff_outR		),
		.i_clk		(and_out		),
		.i_rstn		(i_rstn			)
	);

	assign	o_click		= and_out;
	assign	o_out_req	= dff_outR;
	assign	o_in_ack	= dff_outL;

endmodule
