// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: SoJeong Ok (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_alu.v
//	* Date			: 2024-10-04 17:42:22
//	* Description	: ALU
// ==================================================
`ifndef		NOINC
`include	"riscv_configs.v"
`endif

module riscv_alu
(	
	output 	reg	[`XLEN-1:0]		o_alu_out, //o_alu_result
	output	reg	[	   1:0]		o_alu_src_pc,
	// output 						o_alu_zero,
	input		[`XLEN-1:0]		i_alu_a,
	input		[`XLEN-1:0]		i_alu_b,

	input		[	   6:0]		i_alu_opcode,
	input		[	   2:0]		i_alu_funct3,
	input		[	   3:0]		i_alu_ctrl
);

// Logical operations don't have Signed, but Arithmetic is signed operations.
	always @(*) begin
		case (i_alu_ctrl)
			`ALU_CTRL_ADD	:	o_alu_out	= i_alu_a +  i_alu_b;
			`ALU_CTRL_SUB	:	o_alu_out	= i_alu_a -  i_alu_b;
			`ALU_CTRL_XOR	:	o_alu_out	= i_alu_a ^  i_alu_b;
			`ALU_CTRL_OR	:	o_alu_out	= i_alu_a |  i_alu_b;
			`ALU_CTRL_AND	:	o_alu_out	= i_alu_a &  i_alu_b;
			`ALU_CTRL_SLL	:	o_alu_out	= i_alu_a << i_alu_b[4:0];
			`ALU_CTRL_SRL	:	o_alu_out	= i_alu_a >> i_alu_b[4:0];
			`ALU_CTRL_SRA	:	o_alu_out	= $signed(i_alu_a) >>> $signed(i_alu_b[4:0]);
			`ALU_CTRL_SLT	:	o_alu_out	= ($signed(i_alu_a) < $signed(i_alu_b)) ? 32'd1 : 32'd0;
			`ALU_CTRL_SLTU	:	o_alu_out	= (i_alu_a < i_alu_b) ? 32'd1 : 32'd0;
			default			:	o_alu_out	= 32'dx;
		endcase
	end

	// ADD branch decision function
	wire	alu_zero;
	assign	alu_zero	= (o_alu_out == 0) ? 1'b1 : 1'b0;

	reg		take_branch;
	always @(*) begin
		if (i_alu_opcode == `OPCODE_B_BRANCH) begin
			case (i_alu_funct3)
				`FUNCT3_BRANCH_BEQ	: take_branch = alu_zero;
				`FUNCT3_BRANCH_BNE	: take_branch = !alu_zero;
				`FUNCT3_BRANCH_BLT	: take_branch = !alu_zero;
				`FUNCT3_BRANCH_BGE	: take_branch = alu_zero;
				`FUNCT3_BRANCH_BLTU	: take_branch = !alu_zero;
				`FUNCT3_BRANCH_BGEU	: take_branch = alu_zero;
				// Branch prediction can be implemented
				default				: take_branch = 1'b0;
			endcase
		end else begin
			take_branch = 1'b0;
		end
	end

	always @(*) begin
		case (i_alu_opcode)
			`OPCODE_B_BRANCH	: o_alu_src_pc = (take_branch) ? `SRC_PC_PC_IMM: `SRC_PC_PC_4;
			`OPCODE_J_JAL		: o_alu_src_pc = `SRC_PC_PC_IMM;
			`OPCODE_I_JALR		: o_alu_src_pc = `SRC_PC_RS_IMM;
			default				: o_alu_src_pc = `SRC_PC_PC_4;
		endcase
	end

	`ifdef DEBUG
		reg		[8*8-1:0]	DEBUG_ALU_OP;
		always @(*) begin
			case(i_alu_ctrl)
				`ALU_CTRL_ADD	:	DEBUG_ALU_OP	= "ADD  "; 
				`ALU_CTRL_SUB	:	DEBUG_ALU_OP	= "SUB	";
				`ALU_CTRL_XOR	:	DEBUG_ALU_OP	= "XOR  ";
				`ALU_CTRL_OR	:	DEBUG_ALU_OP	= "OR   ";
				`ALU_CTRL_AND	:	DEBUG_ALU_OP	= "AND  ";
				`ALU_CTRL_SLL	:	DEBUG_ALU_OP	= "SLL  ";
				`ALU_CTRL_SRL	:	DEBUG_ALU_OP	= "SRL  ";
				`ALU_CTRL_SRA	:	DEBUG_ALU_OP	= "SRA  ";
				`ALU_CTRL_SLT	:	DEBUG_ALU_OP	= "SLT  ";
				`ALU_CTRL_SLTU	:	DEBUG_ALU_OP	= "SLTU ";
			endcase
		end
	`endif

	endmodule
