// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_top.v
//	* Description	: 
// ===================================================
`ifndef		NOINC
`include	"../memory/riscv_dmem.v"
`include	"../memory/riscv_imem.v"
`include	"./riscv_stages.v"
`endif

module riscv_top 
#(
	parameter		REGISTER_INIT = 0
)
(
	output		[`XLEN-1:0]		o_riscv_imem_pc,
	output		[`XLEN-1:0]		o_riscv_imem_instr,
	output		[`XLEN-1:0]		o_riscv_dmem_addr,
	output		 				o_riscv_dmem_wr_en,
	output		[      3:0]		o_riscv_dmem_strb,
	output		[`XLEN-1:0]		o_riscv_dmem_wr_data,
	output		[`XLEN-1:0]		o_riscv_dmem_rd_data,

	input						i_rstn
);

	riscv_cpu
	u_riscv_cpu(
		.o_stage_pc			(o_riscv_imem_pc		),
		.o_stage_mem_addr		(o_riscv_dmem_addr		),
		.o_stage_mem_wr_en	(o_riscv_dmem_wr_en		),
		.o_stage_mem_strb		(o_riscv_dmem_strb		),
		.o_stage_mem_wr_data	(o_riscv_dmem_wr_data	),
		.i_stage_instr		(o_riscv_imem_instr		),
		.i_stage_mem_rd_data	(o_riscv_dmem_rd_data	),
		.i_rstn				(i_rstn					)
	);


	riscv_imem
	u_riscv_imem(
		.o_imem_data			(o_riscv_imem_instr						),
		.i_imem_addr			(o_riscv_imem_pc[`IMEM_ADDR_BIT-1:2]	)
	);

	riscv_dmem
	u_riscv_dmem(
		.o_dmem_data			(o_riscv_dmem_rd_data					),
		.i_dmem_data			(o_riscv_dmem_wr_data					),
		.i_dmem_addr			(o_riscv_dmem_addr[`DMEM_ADDR_BIT-1:2]	),
		.i_dmem_byte_sel		(o_riscv_dmem_strb						),
		.i_dmem_wr_en			(o_riscv_dmem_wr_en						),
		.i_clk					(i_clk									)
	);

	endmodule
	
endmodule
