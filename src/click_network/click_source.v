// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: click_source.v
//	* Description	: 
// ===================================================

module click_source
(
	output		o_click,
	output		out_reqR,
	input		in_ackR,
	input		i_rstn
);
		
	wire		xnor_out; 
	reg			dff_out;

	assign		xnor_out	= ~(dff_out ^ in_ackR);

	always @(posedge xnor_out or negedge i_rstn) begin
		if(!i_rstn) begin
			dff_out	<= 1'b0;
		end else begin
			dff_out <= ~dff_out;
		end
	end

	assign		o_click		= xnor_out;
	assign		out_reqR	= dff_out;

endmodule
