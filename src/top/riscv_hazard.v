// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_hazard.v
//	* Description	: hazard management unit
//		Data forwarding, Stall, Flush (Comb logic)
// ===================================================

`ifndef		NOINC
`include	"../core/riscv_configs.v"
`endif

module riscv_hazard
(
	output reg	[1:0]	o_fwd_sel_a_ex,
	output reg	[1:0]	o_fwd_sel_b_ex,
	output				o_stall_if,
	output				o_stall_id,
	output				o_flush_id,
	output				o_flush_ex,

	input		[1:0]	i_src_pc_ex,
	input		[1:0]	i_src_rd_ex,

	input		[4:0]	i_rs1_id,
	input		[4:0]	i_rs2_id,
	input		[4:0]	i_rs1_ex,
	input		[4:0]	i_rs2_ex,
	input		[4:0]	i_rd_ex,
	input		[4:0]	i_rd_mm,
	input		[4:0]	i_rd_wb,
	input				i_reg_wr_en_ex,
	input				i_reg_wr_en_mm,
	input				i_reg_wr_en_wb
);

	// Forward Data
	// Data hazard logic (SrcA of ALU)
	// case1: Execute stage Rs1 or Rs2 match Memory Stage Rd -> Forward
	// case2: Execute stage Rs1 or Rs2 match Writeback stage Rd -> Forward
	// case3: use value read from register file -> Forward X
	always @(*) begin
		if			(((i_rs1_ex == i_rd_mm) && i_reg_wr_en_mm) && (i_rs1_ex != 0)) begin
			o_fwd_sel_a_ex	= `HZD_FORWARD_ALU;	// case 1
		end else if (((i_rs1_ex == i_rd_wb) && i_reg_wr_en_wb) && (i_rs1_ex != 0)) begin 
			o_fwd_sel_a_ex	= `HZD_FORWARD_RLT;	// case 2
		end else begin
			o_fwd_sel_a_ex	= `HZD_FORWARD_RSD;	// case 3
		end
	end

	// Forward Data
	// Data hazard logic (SrcB of ALU)
	always @(*) begin
		if			(((i_rs2_ex == i_rd_mm) && i_reg_wr_en_mm) && (i_rs2_ex != 0)) begin
			o_fwd_sel_b_ex	= `HZD_FORWARD_ALU;
		end else if (((i_rs2_ex == i_rd_wb) && i_reg_wr_en_wb) && (i_rs2_ex != 0)) begin 
			o_fwd_sel_b_ex	= `HZD_FORWARD_RLT;
		end else begin
			o_fwd_sel_b_ex	= `HZD_FORWARD_RSD;
		end
	end

	// Load word Stall logic
	// Can't always avoid stall by forward (if value not computed when need)
	// Stall when update of PC and IF, ID register
	wire	stall;
	assign	stall		= ((i_rs1_id == i_rd_ex) || (i_rs2_id == i_rd_ex)) && ((i_src_rd_ex != `SRC_RD_ALU));
	assign	o_stall_if	= stall;
	assign	o_stall_id	= stall;
	// Control hazard Flush
	// if branch is taken in Execute stage
	assign	o_flush_id	= i_src_pc_ex != `SRC_PC_PC_4;	// branchtaken?
	assign	o_flush_ex	= o_stall_if || o_flush_id;

endmodule
