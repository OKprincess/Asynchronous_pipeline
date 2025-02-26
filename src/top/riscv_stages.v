// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_stages.v
//	* Description	: 
// ===================================================
`ifndef			NOINC
`include		"../stages/riscv_IF.v"
`include		"../stages/riscv_ID.v"
`include		"../stages/riscv_EX.v"
`include		"../stages/riscv_MEM.v"
`include		"../stages/riscv_WB.v"
`include		"../core/riscv_configs.v"
`include		"riscv_hazard.v"
`endif

module riscv_stages
(
	output	reg		[`XLEN-1:0]		o_stage_pc,
	output			[`XLEN-1:0]		o_stage_mem_addr,
	output							o_stage_mem_wr_en,
	output			[3:0]			o_stage_mem_strb,
	output			[`XLEN-1:0]		o_stage_mem_wr_data,
	input			[`XLEN-1:0]		i_stage_instr,
	input			[`XLEN-1:0]		i_stage_mem_rd_data,
	input							i_clk_IF,
	input							i_clk_ID,
	input							i_clk_EX,
	input							i_clk_MEM,
	input							i_clk_WB,
	input							i_rstn
);

	localparam		IF	= 0;
	localparam		ID	= 1;
	localparam		EX	= 2;
	localparam		MM	= 3;
	localparam		WB	= 4;

	// -----------------------------------------------------
	// Internal Signals 
	// -----------------------------------------------------
	// Control unit: Control I/O Signals
	// w_xxx: output of module && transfer to next Stage
	reg		[2:0]			funct3		[ID:MM];
	reg		[6:0]			opcode		[ID:EX];
	reg		[0:0]			funct7_5b	[ID:ID];

	reg		[0:0]			reg_wr_en	[ID:WB];
	reg		[1:0]			src_rd		[ID:WB];
	reg		[0:0]			mem_wr_en	[ID:MM];
	reg		[3:0]			alu_ctrl	[ID:EX];
	reg		[0:0]			src_alu_a	[ID:EX];
	reg		[0:0]			src_alu_b	[ID:EX];

	// Internal Signals (Non-Control)
	wire	[1:0]			src_pc		[EX:EX];
	
	reg		[`XLEN-1:0]		pc			[IF:EX];
	reg		[`XLEN-1:0]		pc4			[IF:WB];
	wire	[`XLEN-1:0]		pcimm		[EX:EX];
	
	reg		[`XLEN-1:0]		instr		[IF:ID];

	reg		[`XLEN-1:0]		imm			[ID:WB];
	
	reg		[4:0]			rs1			[ID:EX];
	reg		[4:0]			rs2			[ID:EX];
	reg		[`XLEN-1:0]		rs1_data	[ID:EX];
	reg		[`XLEN-1:0]		rs2_data	[ID:EX];
	reg		[4:0]			rd			[ID:WB];
	wire	[`XLEN-1:0]		rd_data		[WB:WB];

	reg		[`XLEN-1:0]		mem_rd_data	[MM:WB];
	reg		[`XLEN-1:0]		fwd_b		[EX:MM];
	reg		[`XLEN-1:0]		alu_out		[EX:WB];


	// -----------------------------------------------------
	// Hazard Unit
	// -----------------------------------------------------
	wire	[1:0]			fwd_sel_a	[EX:EX];
	wire	[1:0]			fwd_sel_b	[EX:EX];
	wire					stall		[IF:ID];
	wire					flush		[ID:EX];

	riscv_hazard
	u_riscv_hazard(
		.o_fwd_sel_a_ex		(fwd_sel_a	[EX]	),
		.o_fwd_sel_b_ex		(fwd_sel_b	[EX]	),
		.o_stall_if			(stall		[IF]	),
		.o_stall_id			(stall		[ID]	),
		.o_flush_id			(flush		[ID]	),
		.o_flush_ex			(flush		[EX]	),
		.i_src_pc_ex		(src_pc		[EX]	),
		.i_src_rd_ex		(src_rd		[EX]	),
		.i_rs1_id			(rs1		[ID]	),
		.i_rs2_id			(rs2		[ID]	),
		.i_rs1_ex			(rs1		[EX]	),
		.i_rs2_ex			(rs2		[EX]	),
		.i_rd_ex			(rd			[EX]	),
		.i_rd_mm			(rd			[MM]	),
		.i_rd_wb			(rd			[WB]	),
		.i_reg_wr_en_ex		(reg_wr_en	[EX]	),
		.i_reg_wr_en_mm		(reg_wr_en	[MM]	),
		.i_reg_wr_en_wb		(reg_wr_en	[WB]	)
	);

	////////////////////////// Pipelining //////////////////////////
	wire	[`XLEN-1:0]		pc_next;
	riscv_mux
	#(
		.N_MUX_IN			(3			)
	)
	u_riscv_mux_pc(
		.o_mux_data			(pc_next	),
		.i_mux_concat_data	(alu_out[EX], pcimm[EX], pc4[IF]),
		.i_mux_sel			(src_pc[EX]	)
	);


	////////////////////////// Fetch //////////////////////////
	always @(posedge i_clk_IF) begin
		if(~i_rstn)begin
			pc[IF]	<= 0;
		end else begin
			if(stall[IF]) begin
				pc[IF]	<= pc[IF];
			end else begin
				pc[IF]	<= pc_next;
			end
		end
	end

	riscv_IF
	u_riscv_IF(
		.i_cpu_instr		(i_stage_instr	),	//input from mem
		.i_IF_pc			(pc[IF]			),
		.o_IF_instr			(instr[IF]		),
		.o_IF_pc			(o_stage_pc		),
		.o_IF_instr			(pc4[IF]		)
	);

	always @(posedge i_clk_ID) begin
		if(stall[ID])begin
			instr	[ID]	<= instr	[ID];
			pc		[ID]	<= pc		[ID];
			pc4		[ID]	<= pc4		[ID];
		end else begin
			if(flush[ID])begin
				instr	[ID]	<= 0;
				pc		[ID]	<= 0;
				pc4		[IF]	<= 0;
			end else begin
				instr	[ID]	<= instr[IF];	// from imem
				pc		[ID]	<= pc	[IF];
				pc4		[ID]	<= pc4	[IF];
			end
		end
	end

	////////////////////////// Decode //////////////////////////
	riscv_ID
	u_riscv_ID(
		.o_ID_reg_wr_en		(reg_wr_en[ID]	),
		.o_ID_src_rd		(src_rd[ID]		),   	
		.o_ID_mem_wr_en		(mem_wr_en[ID]	),	
		.o_ID_funct3		(funct3[ID]		),   	
		.o_ID_opcode		(opcode[ID]		),   	
		.o_ID_alu_ctrl		(alu_ctrl[ID]	),
		.o_ID_src_alu_a		(src_alu_a[ID]	),
		.o_ID_src_alu_b		(src_alu_b[ID]	),
		.o_ID_rs1_data		(rs1_data[ID]	), 
		.o_ID_rs2_data		(rs2_data[ID]	),
		.o_ID_rs1			(rs1[ID]		),
		.o_ID_rs2			(rs2[ID]		),
		.o_ID_rd			(rd[ID]			),
		.o_ID_imm	        (imm[ID]		),
		.i_ID_instr			(instr[ID]		),		
		.i_ID_pc			(pc[ID]			),
		.i_ID_pc4			(pc4[ID]		),
		.i_clk				(~i_clk_ID		),		   
		.i_WB_rd_data		(rd_data[WB]	),
		.i_WB_rd			(rd[WB]			),
		.i_WB_reg_wr_en		(reg_wr_en[WB]	)
	);
	

	////////////////////////// EXCUTE //////////////////////////
	always @(posedge i_clk_EX) begin
		if(flush[EX]) begin
			// Control Signals
			reg_wr_en	[EX]	<= 0; 
			src_rd	 	[EX]	<= 0;
			mem_wr_en	[EX]	<= 0;
			alu_ctrl 	[EX]	<= 0;
			src_alu_a	[EX]	<= 0;
			src_alu_b	[EX]	<= 0;
			funct3	 	[EX]	<= 0;	
			opcode	 	[EX]	<= 0;
			// Other Signals
            rs1_data	[EX]	<= 0; 
            rs2_data	[EX]	<= 0;
			pc			[EX]	<= 0;
            rs1			[EX]	<= 0;
            rs2			[EX]	<= 0;
            rd			[EX]	<= 0;
            pc4			[EX]	<= 0;
            imm			[EX]	<= 0;
		end else begin
			// Control Signals
			reg_wr_en	[EX]	<= reg_wr_en	[ID]; 
			src_rd	 	[EX]	<= src_rd	 	[ID];
			mem_wr_en	[EX]	<= mem_wr_en	[ID];
			alu_ctrl 	[EX]	<= alu_ctrl 	[ID];
			src_alu_a	[EX]	<= src_alu_a	[ID];
			src_alu_b	[EX]	<= src_alu_b	[ID];
			funct3	 	[EX]	<= funct3	 	[ID];	
			opcode	 	[EX]	<= opcode	 	[ID];
			// Other Signals
            rs1_data	[EX]	<= rs1_data		[ID]; 
            rs2_data	[EX]	<= rs2_data		[ID];
			pc			[EX]	<= pc			[ID];
            rs1			[EX]	<= rs1			[ID];
            rs2			[EX]	<= rs2			[ID];
            rd			[EX]	<= rd			[ID];
            pc4			[EX]	<= pc4			[ID];
            imm			[EX]	<= imm			[ID];
        end 
	end
		
	riscv_EX
	u_riscv_EX(
		.o_EX_src_pc		(src_pc[EX]		),		// from alu
		.o_EX_fwd_b			(fwd_b[EX]		),			// from fwd_b mux
		.o_EX_alu_out		(alu_out[EX]	),		
		.o_EX_pcimm			(pcimm[EX]		),
		.i_EX_funct3		(funct3[EX]		),
		.i_EX_opcode		(opcode[EX]		),
		.i_EX_alu_ctrl		(alu_ctrl[EX]	),
		.i_EX_src_alu_a		(src_alu_a[EX]	),
		.i_EX_src_alu_b		(src_alu_b[EX]	),
		.i_EX_rs1_data		(rs1_data[EX]	),
		.i_EX_rs2_data		(rs2_data[EX]	),
		.i_EX_pc			(pc[EX]			),
		.i_EX_imm			(imm[EX]		),

		.i_MEM_alu_out		(alu_out[MM]	),
		.i_WB_rd_data		(rd_data[WB]	),
		.i_EX_fwd_sel_a		(fwd_sel_a[EX]	),		// from hazard
		.i_EX_fwd_sel_b		(fwd_sel_b[EX]	)
	);


		
	////////////////////////// MEMORY //////////////////////////
	// MM
	always @(posedge i_clk_MEM) begin
		// Control Signals
        reg_wr_en	[MM]	<= reg_wr_en	[EX]; 
        src_rd	 	[MM]	<= src_rd	 	[EX];
        mem_wr_en	[MM]	<= mem_wr_en	[EX];
        funct3	 	[MM]	<= funct3	 	[EX]; 
		// Other Signals
		fwd_b		[MM]	<= fwd_b		[EX];
		alu_out		[MM]	<= alu_out		[EX];
		rd			[MM]	<= rd			[EX];
		pc4			[MM]	<= pc4			[EX];
		imm			[MM]	<= imm			[EX];
	end
	
	riscv_MEM
	u_riscv_MEM(
		.o_MEM_mem_addr		(o_stage_mem_addr	),			// dmeminterface
		.o_MEM_mem_wr_en	(o_stage_mem_wr_en	),
		.o_MEM_mem_wr_data	(o_stage_mem_wr_data),
		.o_MEM_mem_strb		(o_stage_mem_strb	),
		.o_MEM_mem_rd_data	(mem_rd_data[MM]	),
	
		.i_MEM_alu_out		(alu_out[MM]		),
		.i_MEM_mem_wr_en	(mem_wr_en[MM]		),
		.i_MEM_fwd_b		(fwd_b[MM]			),
		.i_MEM_mem_rd_data	(i_stage_mem_rd_data),
		.i_MEM_funct3		(funct3[MM]			)
	);


	////////////////////////// WB //////////////////////////
	always @(posedge i_clk_WB) begin
		// Control Signals
		reg_wr_en	[WB]	<= reg_wr_en	[MM];
		src_rd		[WB]	<= src_rd		[MM];
		// Other Signals
		alu_out		[WB]	<= alu_out		[MM];
		mem_rd_data	[WB]	<= mem_rd_data	[MM];
		rd			[WB]	<= rd			[MM];
		pc4			[WB]	<= pc4			[MM];
		imm			[WB]	<= imm			[MM];
	end

	riscv_WB
	u_riscv_WB(
		.o_WB_rd_data		(rd_data[WB]	),
		.i_WB_src_rd		(src_rd[WB]		),
		.i_WB_alu_out		(alu_out[WB]	),
		.i_WB_mem_rd_data	(mem_rd_data[WB]),
		.i_WB_pc4			(pc4[WB]		),
		.i_WB_imm			(imm[WB]		)
	);

	
endmodule
