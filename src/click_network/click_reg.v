// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: click_reg.v
//	* Description	: 
// ===================================================

module click_reg 
(
	output		o_click,
	output		out_ackL,
	output		out_reqR,
	input		in_reqL,
	input		in_ackR
);

	wire		xor_outL, xnor_outR, and_out;
	reg			dff_outL, dff_outR;

	assign		xor_outL	= in_reqL ^ dff_outL;
	assign		xnor_outR	= ~(dff_outR ^ in_ackR);
	assign		and_out		= xor_outL & xnor_outR;

	always @(posedge and_out) begin
		dff_outL	<= ~dff_outL;
		dff_outR	<= ~dff_outR;
	end
	
	assign	o_click		= and_out;
	assign	out_reqR	= dff_outR;
	assign	out_ackL	= dff_outL;

endmodule
