// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: click_sink.v
//	* Description	: 
// ===================================================
 module click_sink 
 (
	 output		o_click,
	 output		out_ackL,
	 input		in_reqL,
	 input		i_rstn
 );

 	wire		xor_out;
	reg			dff_out;

	assign		xor_out		= dff_out ^ in_reqL;

	always @(posedge xor_out or negedge i_rstn) begin
		if(!i_rstn) begin
			dff_out <= 1'b0;
		end else begin
			dff_out	<= ~dff_out;
	
		end
	end

	assign	o_click		= xor_out;
	assign	out_ackL	= dff_out;
 	
 endmodule
