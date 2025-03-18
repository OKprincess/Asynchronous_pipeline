// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: mux.v
//	* Description	: 
// ===================================================
module mux #(
	parameter	DATA_WIDTH = 32
)(
	output	reg						o_outC_req,
	output	reg	[DATA_WIDTH-1:0]	o_outC_data,
	input							i_outC_ack,

	input							i_inA_req,
	input		[DATA_WIDTH-1:0]	i_inA_data,
	output	reg						o_inA_ack,

	input							i_inB_req,
	input		[DATA_WIDTH-1:0]	i_inB_data,
	output	reg						o_inB_ack,

	input							i_inSel_req,
	output	reg						o_inSel_ack,
	input							i_selector,

	input							i_rstn
);

	(*dont_touch = "true" *) reg	phase_c, phase_sel, inSel_token;
	(*dont_touch = "true" *) reg	phase_a, phase_b;
	(*dont_touch = "true" *) wire	click_req, click_ack;
	(*dont_touch = "true" *) wire	inA_token, inB_token;

	// Control Path
	always @(*) begin
		
	end
endmodule
