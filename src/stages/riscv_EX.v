// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_EX.v
//	* Description	: 
// ===================================================
`ifndef		NOINC
`include	"../core/riscv_configs.v"
`include	"../core/riscv_adder.v"
`include	"../core/riscv_alu.v"
`include	"../core/riscv_mux.v"
`endif

module riscv_EX 
(
	output					o_EX_reg_wr_en,
	output		[1:0]		o_EX_src_rd,
	output					o_EX_mem_wr_en,
	output		[2:0]		o_EX_funct3,
	output		[6:0]		o_EX_opcode,
	output		[1:0]		o_EX_src_pc,
	output		[`XLEN-1:0]	o_EX_fwd_b,
	output		[`XLEN-1:0]	o_EX_alu_out,
	output		[`XLEN-1:0]	o_EX_imm,
	output		[`XLEN-1:0]	o_EX_pcimm,
	output		[4:0]		o_EX_rd,
	output		[`XLEN-1:0]	o_EX_pc4,
	
	input					i_EX_reg_wr_en,
	input		[1:0]		i_EX_src_rd,
	input					i_EX_mem_wr_en,
	input		[2:0]		i_EX_funct3,
	input		[6:0]		i_EX_opcode,
	input		[3:0]		i_EX_alu_ctrl,
	input					i_EX_src_alu_a,
	input					i_EX_src_alu_b,
	input		[`XLEN-1:0]	i_EX_rs1_data,
	input		[`XLEN-1:0]	i_EX_rs2_data,
	input		[`XLEN-1:0]	i_EX_pc,
	input		[4:0]		i_EX_rs1,
	input		[4:0]		i_EX_rs2,
	input		[4:0]		i_EX_rd,
	input		[`XLEN-1:0]	i_EX_pc4,
	input		[`XLEN-1:0]	i_EX_imm,

	input		[`XLEN-1:0]	i_MEM_alu_out,
	input		[`XLEN-1:0]	i_WB_rd_data,
	

);
	
endmodule
