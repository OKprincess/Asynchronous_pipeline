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
	// output					o_EX_reg_wr_en,
	// output		[1:0]		o_EX_src_rd,
	// output					o_EX_mem_wr_en,
	// output		[2:0]		o_EX_funct3,
	//output		[6:0]		o_EX_opcode,
	output		[1:0]		o_EX_src_pc,		// from alu
	output		[`XLEN-1:0]	o_EX_fwd_b,			// from fwd_b mux
	output		[`XLEN-1:0]	o_EX_alu_out,		
	// output		[`XLEN-1:0]	o_EX_imm,
	output		[`XLEN-1:0]	o_EX_pcimm,
	// output		[4:0]		o_EX_rd,
	// output		[`XLEN-1:0]	o_EX_pc4,
	// output		[4:0]		o_EX_rs1,			// To hazard,
	// output		[4:0]		o_EX_rs2,
	
	// input					i_EX_reg_wr_en,
	// input		[1:0]		i_EX_src_rd,
	// input					i_EX_mem_wr_en,
	input		[2:0]		i_EX_funct3,
	input		[6:0]		i_EX_opcode,
	input		[3:0]		i_EX_alu_ctrl,
	input					i_EX_src_alu_a,
	input					i_EX_src_alu_b,
	input		[`XLEN-1:0]	i_EX_rs1_data,
	input		[`XLEN-1:0]	i_EX_rs2_data,
	input		[`XLEN-1:0]	i_EX_pc,
	// input		[4:0]		i_EX_rs1,
	// input		[4:0]		i_EX_rs2,
	// input		[4:0]		i_EX_rd,
	// input		[`XLEN-1:0]	i_EX_pc4,
	input		[`XLEN-1:0]	i_EX_imm,

	input		[`XLEN-1:0]	i_MEM_alu_out,
	input		[`XLEN-1:0]	i_WB_rd_data,
	input		[1:0]		i_EX_fwd_sel_a,		// from hazard
	input		[1:0]		i_EX_fwd_sel_b
);
	wire		[`XLEN-1:0]	fwd_a, fwd_b;
	wire		[`XLEN-1:0]	alu_a, alu_b;


	assign		o_EX_fwd_b		= fwd_b;

	riscv_mux
	#(
		.N_MUX_IN				(3			)
	)
	u_riscv_mux_fwd_a(
		.o_mux_data				(fwd_a											),
		.i_mux_concat_data		({i_WB_rd_data, i_MEM_alu_out, i_EX_rs1_data}	),
		.i_mux_sel				(i_EX_fwd_sel_a									)
	);

	riscv_mux
	#(
		.N_MUX_IN				(3			)
	)
	u_riscv_mux_fwd_b(
		.o_mux_data				(fwd_b											),
		.i_mux_concat_data		({i_WB_rd_data, i_MEM_alu_out, i_EX_rs2_data}	),
		.i_mux_sel				(i_EX_fwd_sel_b									)
	);

	riscv_mux
	#(
		.N_MUX_IN				(2			)
	)
	u_riscv_mux_alu_a(
		.o_mux_data				(alu_a											),
		.i_mux_concat_data		({i_EX_pc, fwd_a}								),
		.i_mux_sel				(i_EX_src_alu_a									)
	);

	riscv_mux
	#(
		.N_MUX_IN				(2			)
	)
	u_riscv_mux_alu_b(
		.o_mux_data				(alu_b											),
		.i_mux_concat_data		({i_EX_imm, fwd_b}								),
		.i_mux_sel				(i_EX_src_alu_b									) 
	);

	riscv_alu
	u_riscv_alu(
		.o_alu_out				(o_EX_alu_out				),
		.o_alu_src_pc			(o_EX_src_pc				),
		.i_alu_a				(alu_a						),
		.i_alu_b				(alu_b						),
		.i_alu_opcode			(i_EX_opcode				),
		.i_alu_funct3			(i_EX_funct3				),
		.i_alu_ctrl				(i_EX_alu_ctrl				)
	);

	riscv_adder
	u_riscv_adder_pc_plus_imm(
		.o_adder_sum			(o_EX_pcimm					),
		.i_adder_a				(i_EX_pc					),
		.i_adder_a				(i_EX_imm					)
	);




endmodule
