// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_WB.v
//	* Description	: 
// ===================================================
`ifndef			NOINC
`include		"../core/riscv_configs.v"
`include		"../core/riscv_mux.v"
`endif

module riscv_WB 
(
	output					o_WB_reg_wr_en,		// To hazard
	output		[`XLEN-1:0]	o_WB_rd_data,
	output		[4:0]		o_WB_rd,

	input					i_WB_reg_wr_en,
	input		[1:0]		i_WB_src_rd,
	input		[`XLEN-1:0]	i_WB_alu_out,
	input		[`XLEN-1:0]	i_WB_mem_rd_data,
	input		[`XLEN-1:0]	i_WB_pc4,
	input		[`XLEN-1:0]	i_WB_imm,
	input		[4:0]		i_WB_rd
);

	assign		o_WB_reg_wr_en	= i_WB_reg_wr_en;
	assign		o_WB_rd			= i_WB_rd;

	riscv_mux
	#(
		.N_MUX_IN			(4			)
	)
	u_riscv_mux_regfile_rd_data(
		.o_mux_data			(o_WB_rd_data											),
		.i_mux_concat_data	({i_WB_imm, i_WB_pc4, i_WB_mem_rd_data, i_WB_alu_out}	),
		.i_mux_sel			(i_WB_src_rd											)
	
endmodule
