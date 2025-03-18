// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: fork.v
//	* Description	: 
// ===================================================

module fork_type 
(
	output	reg	o_inA_ack,		// Input channel
	output		o_outB_req,		// Output channel 1
	output		o_outC_req,		// Output channel 2

	input		i_inA_req,		// Input channel
	input		i_outB_ack,		// Output channel 1
	input		i_outC_ack,		// Output channel 2

	input		i_rstn
);

	(* dont_touch = "true" *) wire		click;
	(* dont_touch = "true" *) reg		phase;

	
	// Control Path
	assign	o_outB_req 	= i_inA_req;
	assign	o_outC_req	= i_inA_req; 
	
	// Generate click signal(handshaking)
	assign	#(7)click = ((i_outC_ack&i_outB_ack&~phase)|(~i_outC_ack&~i_outB_ack&phase));

	// Clock Register
	initial	phase	= 1'b0;

	always @(posedge click or negedge i_rstn) begin
		if(!i_rstn)
			phase 	<= 1'b0;
		else
			phase	<= ~phase;
	end

	// Acknowledge signal
	always @(posedge i_inA_req or negedge i_rstn) begin
		if(!i_rstn)
			o_inA_ack	<= 1'b0;
		else
			o_inA_ack	<= phase;
	end

endmodule
