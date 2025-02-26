// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		:click.v
//	* Date			: 2025-02-20 
//	* Description	: 
// ===================================================
`define		BW_DATA		1
`include	"dff.v"

module click
(
	output	out_click,
	output	out_ackL,
	output	out_reqR,
	input	in_reqL,
	input	in_ackR
);

	wire	xor_outL, xnor_outR, and_out, dff_outL,  dff_outR;

	assign	xor_outL	= in_reqL ^ dff_outL;
	assign	xnor_outR	= ~(dff_outR ^ in_ackR);	
	assign	and_out		= xor_outL & xnor_outR;

	dff
	#(
		.BW_DATA		(`BW_DATA		)
	)
	u_dffL(
		.o_q			(dff_outL		),
		.i_d			(~dff_outL		),
		.i_clk			(and_out		),
		.i_rstn			(				)
	);

	dff
	#(
		.BW_DATA		(`BW_DATA		)
	)
	u_dffR(
		.o_q			(dff_outR		),
		.i_d			(~dff_outR		),
		.i_clk			(and_out		),
		.i_rstn			(				)
	);

	assign	out_click	= and_out;
	assign	out_reqR	= dff_outR;
	assign	out_ackL	= dff_outL;

endmodule
