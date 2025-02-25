// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: SoJeong Ok (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_adder.v
//	* Date			: 2024-10-07 18:26:33
//	* Description	: Adder
// ==================================================
// Next PC = pc + immediate

`ifndef		NOINC
`include	"riscv_configs.v"
`endif

module riscv_adder 
(
	output		[`XLEN-1:0]		o_adder_sum,
	input		[`XLEN-1:0]		i_adder_a,
	input		[`XLEN-1:0]		i_adder_b
);

	assign		o_adder_sum		= i_adder_a + i_adder_b;
	
endmodule
