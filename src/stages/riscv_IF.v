// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_IF.v
//	* Description	: 
// ===================================================
`ifndef		NOINC
`include	"../core/riscv_configs.v"
`include	"../core/riscv_adder.v"
`endif

module riscv_IF 
(
	output		[`XLEN-1:0]		o_IF_instr,
	output		[`XLEN-1:0]		o_IF_pc,
	output		[`XLEN-1:0]		o_IF_pc4,
	input		[`XLEN-1:0]		i_IF_pc,
	input		[`XLEN-1:0]		i_cpu_instr
);

	assign		o_IF_instr		= i_cpu_instr;
	assign		o_IF_pc			= i_IF_pc;
	
	riscv_adder
	u_riscv_adder_pc_plus_4(
		.o_adder_sum			(o_IF_pc4		),
		.i_adder_a				(i_IF_pc		),
		.i_adder_b				(32'd4			)
	);

endmodule
