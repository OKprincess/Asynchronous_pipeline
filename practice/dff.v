// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: dff.v
//	* Date			: 2025-03-05 
//	* Description	: 
// ===================================================


module dff
(
	output				o_q,
	input				i_d,
	input				i_clk,
	input				i_rstn
);

	reg	q_internal;

	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			q_internal	<= 0;
		end else begin
			q_internal	<= i_d;
		end
	end

	buf	#(3) (o_q, q_internal);

	/*wire	r0, s0;
	wire	q0, q_0;

	nand	#(3)(s0, i_d, i_clk);
	nand	#(3)(r0, s0,i_clk);
	nand	#(3)(q0,q_0, s0);
	nand	#(3)(q_0, q0, r0);

	wire	n_clk;
	wire	r1, s1, q1, q_1;

	not		#(3)(n_clk, i_clk);
	nand	#(3)(s1, q0, n_clk);
	nand	#(3)(r1, s1, n_clk);
	nand	#(3)(q1, q_1,s1);
	nand	#(3)(q_1, q1, r1);

	assign	o_q = q1;
*/
endmodule
