// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: SoJeong Ok (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_configs.v
//	* Date			: 2024-09-30 17:55:04
//	* Description	: 
// ==================================================

// ==================================================
// 	RISC-V Integer Bit & Memory Specification	
// ==================================================
`define	DEBUG
`define	XLEN			32
`define	DMEM_ADDR_BIT	16
`define	IMEM_ADDR_BIT	16	

`define	DMEM_INIT
//`define	DMEM_INIT_FILE	"riscv_dmem.mif"
`define	IMEM_INIT
//`define	IMEM_INIT_FILE	"riscv_imem.mjf"
// ==================================================
// 	ALU (Arithmetic & Logical Unit)	
// ==================================================
//	`define ALU_CTRL_"Inst"			{funct7[5], funct3}
`define	ALU_CTRL_ADD	4'b0000
`define	ALU_CTRL_SUB	4'b1000
`define	ALU_CTRL_XOR	4'b0100
`define	ALU_CTRL_OR		4'b0110
`define	ALU_CTRL_AND	4'b0111
`define	ALU_CTRL_SLL	4'b0001
`define	ALU_CTRL_SRL	4'b0101
`define	ALU_CTRL_SRA	4'b1101
`define	ALU_CTRL_SLT	4'b0010
`define	ALU_CTRL_SLTU	4'b0011
`define	ALU_CTRL_NOP	4'b1111		// No Operation

// ==================================================
// 	Instruction opcodes	
// ==================================================
// 7-bit opcodes to make Control Unit
`define	OPCODE_R_OP		7'b0110011	// R-Type, rd = rs1 'op' rs2
`define	OPCODE_I_OP		7'b0010011	// I-Type, rd = rs1 'op' Imm
`define	OPCODE_I_LOAD	7'b0000011	// I-Type, rd = M[rs1 + Imm]
`define	OPCODE_S_STORE	7'b0100011	// S-Type, M[rs1 + Imm] = rs2
`define	OPCODE_B_BRANCH	7'b1100011	// B-Type, if(rs1 'op' rs2) pc += Imm
`define	OPCODE_J_JAL	7'b1101111	// J-Type, rd = pc + 4; pc += Imm
`define	OPCODE_I_JALR	7'b1100111	// 		 , rd = pc + 4; pc = rs1 + Imm
`define	OPCODE_U_LUI	7'b0110111	// U-Type, Load Upper Imm, rd = sext(Imm << 12)
`define	OPCODE_U_AUIPC	7'b0010111	// U-Type, Add Upper Imm to PC, rd = pc + sext(Imm << 12) 

// ==================================================
// 	Source Immidiate 
// ==================================================
// For Immidiate Extension
`define	SRC_IMM_R		3'b000
`define	SRC_IMM_I		3'b001
`define	SRC_IMM_S		3'b010
`define	SRC_IMM_B		3'b011
`define	SRC_IMM_J		3'b100
`define	SRC_IMM_U		3'b101
`define SRC_IMM_X		3'b111

// ==================================================
// 	Source (Next)PC	
// ==================================================
// SRC_()_()_() => NextPC = base + offset
`define	SRC_PC_PC_4		2'b00 
`define	SRC_PC_PC_IMM	2'b01	
`define	SRC_PC_RS_IMM	2'b10 

// ==================================================
// 	Source RD (Register File Write Data)	
// ==================================================
//	'riscv_regfile' input 'rd_data'
//	This can be 4 or 5(with pc)
`define	SRC_RD_ALU		2'b00 
`define	SRC_RD_DME		2'b01	
`define	SRC_RD_PC4		2'b10
`define	SRC_RD_IMM		2'b11
// (Option) SRC_RD_PCIMM~~

// ==================================================
// 	Source alu	
// ==================================================
//	For alu's input a and input b
`define	SRC_ALU_A_RS1	1'b0
`define	SRC_ALU_A_PC	1'b1
`define	SRC_ALU_B_RS2	1'b0
`define	SRC_ALU_B_IMM	1'b1

// ==================================================
// 	Function3 for ALU	
// ==================================================
//	Only ADD&SUB and SRL&SRA is same in funct3
//	distinguish operate by funct3 except Above case(funct7)
`define	FUNCT3_ALU_ADD_SUB	3'b000
`define	FUNCT3_ALU_XOR		3'b100
`define	FUNCT3_ALU_OR		3'b110
`define	FUNCT3_ALU_AND		3'b111
`define	FUNCT3_ALU_SLL		3'b001
`define	FUNCT3_ALU_SRL_SRA	3'b101
`define	FUNCT3_ALU_SLT		3'b010
`define	FUNCT3_ALU_SLTU		3'b011

// ==================================================
// 	Function3 for Branch	
// ==================================================
//
`define	FUNCT3_BRANCH_BEQ	3'b000
`define	FUNCT3_BRANCH_BNE	3'b001
`define	FUNCT3_BRANCH_BLT	3'b100
`define	FUNCT3_BRANCH_BGE	3'b101
`define	FUNCT3_BRANCH_BLTU	3'b110
`define	FUNCT3_BRANCH_BGEU	3'b111

// ==================================================
// 	Function3 for Load/Store
// ==================================================
//	Memory byte for load(I) or Store(S)
`define	FUNCT3_MEM_BYTE		3'b000
`define	FUNCT3_MEM_HALF		3'b001
`define	FUNCT3_MEM_WORD		3'b010
`define	FUNCT3_MEM_BYTEU	3'b100
`define	FUNCT3_MEM_HALFU	3'b101

// ==================================================
//	Data Forwarding for Data Hazard 	
// ==================================================
// Data forwarding for MUX select signals
`define	HZD_FORWARD_RSD		2'b00	// RS Data
`define	HZD_FORWARD_ALU		2'b01	// ALU output
`define	HZD_FORWARD_RLT		2'b10	// Register File RD Data
//
