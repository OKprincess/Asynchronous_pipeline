// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: dff.v
//	* Description	: 
// ===================================================
`include	"def_delay.v"

module dff_async 
#(
	parameter	BW_DATA = 1
)
(
	output			[BW_DATA-1:0]	o_q,
	input			[BW_DATA-1:0]	i_d,
	input							i_clk,
	input							i_rstn
);

	reg	[BW_DATA-1:0]	q_internal;

	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			q_internal	<= 0;
		end else begin
			q_internal	<= i_d;
		end
	end
	
	// DFF delay is 5ns
	assign	#(`T_DFF) o_q	= q_internal;

endmodule
