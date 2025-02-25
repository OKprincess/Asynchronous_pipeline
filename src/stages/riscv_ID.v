// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_ID.v
//	* Description	: 
// ===================================================
`ifndef			NOINC
`include		"riscv_ctrl.v"
`include		"../core/riscv_configs.v"
`include		"../core/riscv_regfile.v"
`include		"../core/riscv_immext.v"
`endif

module riscv_ID 
(
	output					o_ID_reg_wr_en,			//from ctrl unit
	output		[1:0]		o_ID_src_rd,
	output					o_ID_mem_wr_en,
	output		[2:0]		o_ID_funct3,
	output		[6:0]		o_ID_opcode,
	output		[3:0]		o_ID_alu_ctrl,
	output					o_ID_src_alu_a,
	output					o_ID_src_alu_b,
	output		[`XLEN-1:0]	o_ID_rs1_data,			// from reg file
	output		[`XLEN-1:0]	o_ID_rs2_data,
	output		[`XLEN-1:0]	o_ID_pc,				// bypass
	output		[4:0]		o_ID_rs1,
	output		[4:0]		o_ID_rs2,
	output		[4:0]		o_ID_rd,
	output		[`XLEN-1:0]	o_ID_pc4,
	output		[`XLEN-1:0]	o_ID_imm,				// from immext
	
	input		[`XLEN-1:0]	i_ID_instr,
	input		[`XLEN-1:0]	i_ID_pc,
	input		[`XLEN-1:0]	i_ID_pc4,

	input					i_clk,					// for regfile
	input		[`XLEN-1:0]	i_WB_rd_data,
	input		[4:0]		i_WB_rd,
	input					i_WB_reg_wr_en
);


	wire		[6:0]		opcode;
	wire		[2:0]		funct3;
	wire					funct7_5b;
	
	wire		[4:0]		rs1, rs2;

	wire		[2:0]		src_imm;

	assign	opcode			= i_ID_instr[6:0];
	assign	funct3			= i_ID_instr[14:12];
	assign	funct7_5b		= i_ID_instr[30];
	assign	rs1				= i_ID_instr[19:15];
	assign	rs2				= i_ID_instr[24:20];
	
	assign	o_ID_funct3		= funct3;
	assign	o_ID_opcode		= opcode;
	assign	o_ID_pc			= i_ID_pc;
	assign	o_ID_pc4		= i_ID_pc4;
	assign	o_ID_rs1		= rs1;
	assign	o_ID_rs2		= rs2;
	assign	o_ID_rd			= i_ID_instr[11:7];

	riscv_ctrl
	u_riscv_ctrl(
		.o_ctrl_reg_wr_en		(o_ID_reg_wr_en		),
		.o_ctrl_src_rd			(o_ID_src_rd		),
		.o_ctrl_mem_wr_en		(o_ID_mem_wr_en		),
		.o_ctrl_alu_ctrl		(o_ID_alu_ctrl		),
		.o_crtl_src_alu_a		(o_ID_src_alu_a		),
		.o_ctrl_src_alu_b		(o_ID_src_alu_b		),
		.o_ctrl_src_imm			(src_imm			),
		.i_ctrl_opcode			(opcode				),
		.i_ctrl_funct3			(funct3				),
		.i_ctrl_funct7_5b		(funct7_5b			)
	);

	riscv_regfile
	u_riscv_regfile(
		.o_regfile_rs1_data		(o_ID_rs1_data		),
		.o_regfile_rs2_data		(o_ID_rs2_data		),
		.i_regfile_rs1_addr		(rs1				),
		.i_regfile_rs2_addr		(rs2				),
		.i_regfile_rd_data		(i_WB_rd_data		),
		.i_regfile_rd_addr		(i_WB_rd			),
		.i_regfile_rd_wen		(i_WB_reg_wr_en		),
		.i_clk					(~i_clk				)
	);

	riscv_immext
	u_riscv_immext(
		.o_imm_ext				(o_ID_imm			),
		.i_imm_instr			(i_ID_instr[31:7]	),
		.i_imm_src				(src_imm			)
	);


endmodule
