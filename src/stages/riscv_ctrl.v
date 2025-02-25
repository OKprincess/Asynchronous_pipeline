// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_ctrl.v
//	* Date			: 2025-01-15 
//	* Description	: 
// ===================================================

`ifndef		NOINC
`include	"../core/riscv_configs.v"
`endif

module riscv_ctrl 
(
	output	reg		[2:0]	o_ctrl_src_imm,
	output	reg		[1:0]	o_ctrl_src_rd,
	output	reg				o_ctrl_src_alu_a,
	output	reg				o_ctrl_src_alu_b,
	output	reg				o_ctrl_reg_wr_en,
	output	reg				o_ctrl_mem_wr_en,
	output	reg		[3:0]	o_ctrl_alu_ctrl,
	input			[6:0]	i_ctrl_opcode,
	input			[2:0]	i_ctrl_funct3,
	input					i_ctrl_funct7_5b
);

	// 	o_ctrl_src_imm[2:0]
	// ==================================================
	//	src_imm is Immidiate Decode's sel signal.
	//	: 6 Type(need 3bit) have Specific array of Immidiate.
	//	: define src imm by opcode.
	// ==================================================
	always @(*) begin
		case(i_ctrl_opcode)
			`OPCODE_R_OP		: o_ctrl_src_imm = `SRC_IMM_R;
			`OPCODE_I_OP		,
			`OPCODE_I_LOAD		,
			`OPCODE_I_JALR		: o_ctrl_src_imm = `SRC_IMM_I;
			`OPCODE_S_STORE 	: o_ctrl_src_imm = `SRC_IMM_S;
			`OPCODE_B_BRANCH	: o_ctrl_src_imm = `SRC_IMM_B;
			`OPCODE_J_JAL		: o_ctrl_src_imm = `SRC_IMM_J;
			`OPCODE_U_LUI		,
			`OPCODE_U_AUIPC		: o_ctrl_src_imm = `SRC_IMM_U;
			default				: o_ctrl_src_imm = `SRC_IMM_X;
		endcase
	end

	// ==================================================
	// 	o_ctrl_src_rd[1:0] 
	// ==================================================
	//	src_rd define Regfile's input rd_data (4:1 mux sel) 
	//	: rd is Register Destination!!(write to regfile)
	//	alu_result		- R_OP, I_OP, default
	//	dmem_rd_data	- I_LOAD
	//	pc+4			- J_JAL, I_JALR 
	//	Immidiate		- U_LUI
	// ==================================================
	always @(*) begin
		case(i_ctrl_opcode)
			`OPCODE_I_LOAD		: o_ctrl_src_rd = `SRC_RD_DME;
			`OPCODE_J_JAL		,
			`OPCODE_I_JALR		: o_ctrl_src_rd = `SRC_RD_PC4;
			`OPCODE_U_LUI		: o_ctrl_src_rd = `SRC_RD_IMM;
			default				: o_ctrl_src_rd = `SRC_RD_ALU;
		endcase
	end

	// ==================================================
	// 	o_ctrl_src_alu_a 
	// ==================================================
	// src_alu_a is sel signal of 2to1 mux which define ALU operand. 
	// : rs1_data or PC -> defined by Fomat(type)
	// By Formats and Description, U-type, J-type, I_LOAD have no rs1_data
	// <Remember> pc+imm and pc+4 are in another module adder.
	// 				: results of them is inputs of rd_data 4:1mux 
	// < CAN pc+(imm<<12) connect to rd_datamux(4to1->5to1)??>
	// 				: Sure, if then remove src_alu_a + @ 
	// ==================================================
	always @(*) begin
		case(i_ctrl_opcode)
			`OPCODE_U_AUIPC		: o_ctrl_src_alu_a = `SRC_ALU_A_PC;
			default				: o_ctrl_src_alu_a = `SRC_ALU_A_RS1;
		endcase
	end

	// ==================================================
	// 	o_ctrl_src_alu_b 
	// ==================================================
	//	src_alu_b define 2nd operand(=input) of ALU.
	//	: rs2_data or Immidiate -> defined by Formats(type)
	//	: By Description, I-type, S-type have no rs2_data
	//	<Remember> pc+imm, pc+4, imm<<12(sext in ImmDecoder) are defined by other modules
	// ==================================================
	always @(*) begin
		case(i_ctrl_opcode)
			`OPCODE_I_JALR		,
			`OPCODE_I_OP		,
			`OPCODE_I_LOAD		,
			`OPCODE_U_AUIPC		,
			`OPCODE_S_STORE		: o_ctrl_src_alu_b = `SRC_ALU_B_IMM;
			default				: o_ctrl_src_alu_b = `SRC_ALU_B_RS2;
		endcase
	end


	// ==================================================
	// 	o_ctrl_reg_wr_en 
	// ==================================================
	// 	reg_wr_en define Writing data to Regfile or NOT.
	//	: By Descriptions, Only S-type and B-type don't use rd on left side.
	// ==================================================
	always @(*) begin
		case(i_ctrl_opcode)
			`OPCODE_S_STORE		,
			`OPCODE_B_BRANCH	: o_ctrl_reg_wr_en = 1'b0;
			default				: o_ctrl_reg_wr_en = 1'b1;
		endcase
	end

	// ==================================================
	// 	o_ctrl_mem_wr_en 
	// ==================================================
	// 	mem_wr_en is 1'b1 only in S-Type
	// 	: M[rs1+imm][0:byte] = rs2[0:byte]
	// ==================================================
	always @(*) begin
		case(i_ctrl_opcode)
			`OPCODE_S_STORE		: o_ctrl_mem_wr_en = 1'b1;
			default				: o_ctrl_mem_wr_en = 1'b0;
		endcase
	end


	// ==================================================
	// 	o_ctrl_alu_ctrl[3:0]
	// ==================================================
	// 	alu_ctrl define Arithmetic&Logical Operation
	//	: I_OP and R_OP have same funct3 at same Operation.
	//		funct3 ADD_SUB and SRL_SRA canbe distinguish by funct7[5]
	//	: Branch canbe distinguish by funct3.
	// ==================================================
	always @(*) begin
		case(i_ctrl_opcode)
			`OPCODE_R_OP	,
			`OPCODE_I_OP	: begin
				case(i_ctrl_funct3)
					`FUNCT3_ALU_ADD_SUB	: o_ctrl_alu_ctrl = (i_ctrl_funct7_5b && i_ctrl_opcode==`OPCODE_R_OP) ? 
															`ALU_CTRL_SUB : `ALU_CTRL_ADD;
                    `FUNCT3_ALU_XOR		: o_ctrl_alu_ctrl = `ALU_CTRL_XOR; 
                    `FUNCT3_ALU_OR		: o_ctrl_alu_ctrl = `ALU_CTRL_OR;
                    `FUNCT3_ALU_AND		: o_ctrl_alu_ctrl = `ALU_CTRL_AND;
                    `FUNCT3_ALU_SLL		: o_ctrl_alu_ctrl = `ALU_CTRL_SLL;
                    `FUNCT3_ALU_SRL_SRA	: o_ctrl_alu_ctrl = i_ctrl_funct7_5b ?
															`ALU_CTRL_SRA : `ALU_CTRL_SRL;
                    `FUNCT3_ALU_SLT		: o_ctrl_alu_ctrl =	`ALU_CTRL_SLT;
                    `FUNCT3_ALU_SLTU	: o_ctrl_alu_ctrl = `ALU_CTRL_SLTU;
					default				: o_ctrl_alu_ctrl = `ALU_CTRL_NOP;
				endcase
			end
			`OPCODE_B_BRANCH : begin
				case(i_ctrl_funct3)
					`FUNCT3_BRANCH_BEQ	,
					`FUNCT3_BRANCH_BNE 	: o_ctrl_alu_ctrl = `ALU_CTRL_SUB;
					`FUNCT3_BRANCH_BLT 	,
					`FUNCT3_BRANCH_BGE 	: o_ctrl_alu_ctrl = `ALU_CTRL_SLT;
					`FUNCT3_BRANCH_BLTU	,
					`FUNCT3_BRANCH_BGEU	: o_ctrl_alu_ctrl = `ALU_CTRL_SLTU;
					default				: o_ctrl_alu_ctrl = `ALU_CTRL_NOP;
				endcase
			end
			default			: o_ctrl_alu_ctrl = `ALU_CTRL_ADD;
		endcase
	end

	`ifdef	DEBUG
		reg [8*32-1:0]	DEBUG_INSTR;
		always @(*) begin
			case(i_ctrl_opcode)
				`OPCODE_R_OP		: begin
					case(i_ctrl_funct3)
						`FUNCT3_ALU_ADD_SUB	: DEBUG_INSTR = i_ctrl_funct7_5b ? "sub" : "add" ;
						`FUNCT3_ALU_XOR		: DEBUG_INSTR = "xor"                            ;
						`FUNCT3_ALU_OR		: DEBUG_INSTR = "or"                             ;
						`FUNCT3_ALU_AND		: DEBUG_INSTR = "and"                            ;
						`FUNCT3_ALU_SLL		: DEBUG_INSTR = "sll"                            ;
						`FUNCT3_ALU_SRL_SRA	: DEBUG_INSTR = i_ctrl_funct7_5b ? "sra" : "srl" ;
						`FUNCT3_ALU_SLT		: DEBUG_INSTR = "slt"                            ;
						`FUNCT3_ALU_SLTU	: DEBUG_INSTR = "sltu"                           ;
						default				: DEBUG_INSTR = "-";
					endcase
				end
				`OPCODE_I_OP		: begin
					case(i_ctrl_funct3)
						`FUNCT3_ALU_ADD_SUB	: DEBUG_INSTR = "addi"                             ;
						`FUNCT3_ALU_XOR		: DEBUG_INSTR = "xori"                             ;
						`FUNCT3_ALU_OR		: DEBUG_INSTR = "ori"                              ;
						`FUNCT3_ALU_AND		: DEBUG_INSTR = "andi"                             ;
						`FUNCT3_ALU_SLL		: DEBUG_INSTR = "slli"                             ;
						`FUNCT3_ALU_SRL_SRA	: DEBUG_INSTR = i_ctrl_funct7_5b ? "srai" : "srli" ;
						`FUNCT3_ALU_SLT		: DEBUG_INSTR = "slti"                             ;
						`FUNCT3_ALU_SLTU	: DEBUG_INSTR = "sltui"                            ;
						default				: DEBUG_INSTR = "-";
					endcase
				end
				`OPCODE_I_LOAD		: begin
					case(i_ctrl_funct3)
						`FUNCT3_MEM_BYTE	: DEBUG_INSTR = "lb"  ;
						`FUNCT3_MEM_HALF	: DEBUG_INSTR = "lh"  ;
						`FUNCT3_MEM_WORD	: DEBUG_INSTR = "lw"  ;
						`FUNCT3_MEM_BYTEU	: DEBUG_INSTR = "lbu" ;
						`FUNCT3_MEM_HALFU	: DEBUG_INSTR = "lhu" ;
						default				: DEBUG_INSTR = "-";
					endcase
				end
				`OPCODE_S_STORE		: begin
					case(i_ctrl_funct3)
						`FUNCT3_MEM_BYTE	: DEBUG_INSTR = "sb";
						`FUNCT3_MEM_HALF	: DEBUG_INSTR = "sh";
						`FUNCT3_MEM_WORD	: DEBUG_INSTR = "sw";
						default				: DEBUG_INSTR = "-";
					endcase
				end
				`OPCODE_B_BRANCH	: begin
					case(i_ctrl_funct3)
						`FUNCT3_BRANCH_BEQ	: DEBUG_INSTR = "beq"  ;
						`FUNCT3_BRANCH_BNE	: DEBUG_INSTR = "bne"  ;
						`FUNCT3_BRANCH_BLT	: DEBUG_INSTR = "blt"  ;
						`FUNCT3_BRANCH_BGE	: DEBUG_INSTR = "bge"  ;
						`FUNCT3_BRANCH_BLTU	: DEBUG_INSTR = "bltu" ;
						`FUNCT3_BRANCH_BGEU	: DEBUG_INSTR = "bgeu" ;
						default				: DEBUG_INSTR = "-";
					endcase
				end
				`OPCODE_J_JAL		: DEBUG_INSTR = "jal"   ;
				`OPCODE_I_JALR		: DEBUG_INSTR = "jalr"  ;
				`OPCODE_U_LUI		: DEBUG_INSTR = "lui"   ;
				`OPCODE_U_AUIPC		: DEBUG_INSTR = "auipc" ;
				default				: DEBUG_INSTR = "-";
			endcase
		end

	`endif

endmodule
