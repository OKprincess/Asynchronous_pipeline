// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: data_dff.v
//	* Date			: 2025-03-05 
//	* Description	: 
// ===================================================
module	data_dff
#(
	parameter	REGISTER_INIT	= 0
)
(
	output	reg					o_reg_s,
	output	reg	[31:0]			o_reg_s,
	input		[`XLEN-1:0]		i_register_d,
	input						i_register_en,
	input						i_clk,
	input						i_rstn
);

	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			o_register_q	<= REGISTER_INIT;
		end else begin
			if(i_register_en) begin
				o_register_q	<= i_register_d;
			end else begin
				o_register_q	<= o_register_q;
			end
		end
	end

	endmodule
