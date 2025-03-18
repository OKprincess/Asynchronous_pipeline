// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: source_type.v
//	* Description	: 
// ===================================================
`include	"dff_async.v"
`include	"def_delay.v"

module source_type 
(
	output	o_click,
	output	o_out_req,
	input	i_out_ack,

	input	i_rstn
);

	wire	xnor_out, dff_out, n_dff_out;

	xnor	#(`T_XNOR)(xnor_out, i_out_ack, dff_out);
	not		#(`T_NOT)(n_dff_out, dff_out);

	dff_async
	#(		.BW_DATA	(1				)
	)
	u_dff(
		.o_q			(dff_out		),
		.i_d			(n_dff_out		),
		.i_clk			(xnor_out		),
		.i_rstn			(i_rstn			)
	);

	assign	o_click		= xnor_out;
	assign	o_out_req	= dff_out;
	
endmodule
