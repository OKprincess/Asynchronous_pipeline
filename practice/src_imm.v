// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		:src_imm.v
//	* Description	: 
// ===================================================
module src_imm
(
	input	[6:0]	i_opcode,

	output	[2:0]	o_src_imm
);
	
	wire	[4:0]	sel, n_sel;
	wire	[2:0]	src_imm_R, src_imm_I, src_imm_S, src_imm_B, src_imm_J, src_imm_U, src_imm_X;
	wire			sel_i, sel_iop,sel_ilo, sel_ija;
	wire			sel_u, sel_ulu, sel_uau;
	assign			sel[4:0]= i_opcode[6:2];

	not	#(3) (n_sel[4],sel[4]);
	not	#(3) (n_sel[3],sel[3]);
	not	#(3) (n_sel[2],sel[2]);
	not	#(3) (n_sel[1],sel[1]);
	not	#(3) (n_sel[0],sel[0]);

	// R:0110011
	and #(4) (src_imm_R[2], 1'b0, n_sel[4], sel[3], sel[2], n_sel[1], n_sel[0]);
	and #(4) (src_imm_R[1], 1'b0, n_sel[4], sel[3], sel[2], n_sel[1], n_sel[0]);
	and #(4) (src_imm_R[0], 1'b0, n_sel[4], sel[3], sel[2], n_sel[1], n_sel[0]);
	// I
	
	and	#(4) (sel_iop, n_sel[4], n_sel[3], sel[2], n_sel[1], n_sel[0]);
	and	#(4) (sel_ilo, n_sel[4], n_sel[3], n_sel[2], n_sel[1], n_sel[0]);
	and	#(4) (sel_ija, sel[4], sel[3], n_sel[2], n_sel[1], sel[0]);
	or	#(4) (sel_i, sel_iop, sel_ilo, sel_ija);
	and #(4) (src_imm_I[2], 1'b0, sel_i);
	and #(4) (src_imm_I[1], 1'b0, sel_i);
	and #(4) (src_imm_I[0], 1'b1, sel_i);
	// S: 0100011 
	and #(4) (src_imm_S[2], 1'b0, n_sel[4], sel[3], n_sel[2], n_sel[1], n_sel[0]);
	and #(4) (src_imm_S[1], 1'b1, n_sel[4], sel[3], n_sel[2], n_sel[1], n_sel[0]);
	and #(4) (src_imm_S[0], 1'b0, n_sel[4], sel[3], n_sel[2], n_sel[1], n_sel[0]);

	// B:1100011
	and #(4) (src_imm_B[2], 1'b0, sel[4], sel[3], n_sel[2], n_sel[1], n_sel[0]);
	and #(4) (src_imm_B[1], 1'b1, sel[4], sel[3], n_sel[2], n_sel[1], n_sel[0]);
	and #(4) (src_imm_B[0], 1'b1, sel[4], sel[3], n_sel[2], n_sel[1], n_sel[0]);

	// J:1101111
	and #(4) (src_imm_J[2], 1'b1, sel[4], sel[3], n_sel[2], sel[1], sel[0]);
	and #(4) (src_imm_J[1], 1'b0, sel[4], sel[3], n_sel[2], sel[1], sel[0]);
	and #(4) (src_imm_J[0], 1'b0, sel[4], sel[3], n_sel[2], sel[1], sel[0]);

	// U
	and	#(4) (sel_ulu, n_sel[4], sel[3], sel[2], n_sel[1], sel[0]);
	and	#(4) (sel_uau, n_sel[4], n_sel[3], sel[2], n_sel[1], sel[0]);
	or	#(4) (sel_u, sel_ulu, sel_uau);
	and #(4) (src_imm_U[2], 1'b1, sel_i);
	and #(4) (src_imm_U[1], 1'b0, sel_i);
	and #(4) (src_imm_U[0], 1'b1, sel_i);

	or 	#(4) (o_src_imm[2], src_imm_R[2], src_imm_I[2], src_imm_S[2], src_imm_B[2], src_imm_J[2], src_imm_U[2]);
	or 	#(4) (o_src_imm[1], src_imm_R[1], src_imm_I[1], src_imm_S[1], src_imm_B[1], src_imm_J[1], src_imm_U[1]);
	or 	#(4) (o_src_imm[0], src_imm_R[0], src_imm_I[0], src_imm_S[0], src_imm_B[0], src_imm_J[0], src_imm_U[0]);

endmodule
