// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_MEM.v
//	* Description	: 
// ===================================================
`ifndef		NOINC
`include	"../core/riscv_configs.v"
`include	"../core/riscv_dmem_interface.v"
`endif

module riscv_MEM 
(
	// output						o_MEM_reg_wr_en,
	// output		[1:0]			o_MEM_src_rd,
	// output		[`XLEN-1:0]		o_MEM_alu_out,
	// output		[4:0]			o_MEM_rd,				// To hazard
	// output		[`XLEN-1:0]		o_MEM_pc4,
	// output		[`XLEN-1:0]		o_MEM_imm,

	output		[`XLEN-1:0]		o_MEM_mem_addr,			// dmeminterface
	output						o_MEM_mem_wr_en,
	output		[`XLEN-1:0]		o_MEM_mem_wr_data,
	output		[3:0]			o_MEM_mem_strb,
	output		[`XLEN-1:0]		o_MEM_mem_rd_data,
	
	input		[`XLEN-1:0]		i_MEM_alu_out,
	input						i_MEM_mem_wr_en,
	input		[`XLEN-1:0]		i_MEM_fwd_b,
	input		[`XLEN-1:0]		i_MEM_mem_rd_data,
	input		[2:0]			i_MEM_funct3
	// input						i_MEM_reg_wr_en,
	// input		[1:0]			i_MEM_src_rd,
	// input		[4:0]			i_MEM_rd,
	// input		[`XLEN-1:0]		i_MEM_pc4,
	// input		[`XLEN-1:0]		i_MEM_imm
);


	riscv_dmem_interface
	u_riscv_dmem_interface(
	.o_dmem_intf_addr		(o_MEM_mem_addr			),
	.o_dmem_intf_wen		(o_MEM_mem_wr_en		),
	.o_dmem_intf_wr_data	(o_MEM_mem_wr_data		),
	.o_dmem_intf_byte_sel	(o_MEM_mem_strb			),
	.o_dmem_intf_rd_data	(o_MEM_mem_rd_data		),
	.i_dmem_intf_addr		(i_MEM_alu_out			),
	.i_dmem_intf_wen		(i_MEM_mem_wr_en		),
	.i_dmem_intf_wr_data	(i_MEM_fwd_b			),
	.i_dmem_intf_rd_data	(i_MEM_mem_rd_data		),
	.i_dmem_intf_func3		(i_MEM_funct3			)
	);

endmodule
