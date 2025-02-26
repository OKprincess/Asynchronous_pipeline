// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: dff.v
//	* Description	: 
// ===================================================
 module	dff
 #(
	 parameter	BW_DATA	= 1
 )
 (
	 output	reg	[BW_DATA-1:0]	o_q,
	 input		[BW_DATA-1:0]	i_d,
	 input						i_clk,
	 input						i_rstn
 );

 	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			o_q	<= 1'b0;
		end else begin
			o_q	<=	i_d;
		end
 	end

endmodule

