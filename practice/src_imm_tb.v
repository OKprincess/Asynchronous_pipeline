// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: src_imm_tb.v
//	* Date			: 2025-03-05 
//	* Description	: 
// ===================================================
 	// --------------------------------------------------
 	//	Define Global Variables
 	// --------------------------------------------------
 	`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
 	`define	SIMCYCLE	`NVEC	// Sim. Cycles
 	`define NVEC		100		// # of Test Vector

 	// --------------------------------------------------
 	//	Includes
 	// --------------------------------------------------
 	`include	"src_imm.v"

 	module src_imm_tb;
 	// --------------------------------------------------
 	//	DUT Signals & Instantiate
 	// --------------------------------------------------
		wire	[2:0]	o_src_imm;
		reg		[6:0]	i_opcode;
 	
		src_imm
		u_src_imm(
			.o_src_imm	(o_src_imm	),
			.i_opcode	(i_opcode	)
		);


	
 	// --------------------------------------------------
 	//	Tasks	
 	// --------------------------------------------------
		reg		[8*32-1:0]	taskState;


 	// --------------------------------------------------
 	//	Test Stimulus
 	// --------------------------------------------------
 		integer		i, j;
 		initial begin
			taskState	= "R_OP";
			i_opcode	= 7'b0110011; #10;
			taskState	= "I_OP";
			i_opcode	= 7'b0010011; #10;
			taskState	= "I_LOAD";
			i_opcode	= 7'b0000011; #10;
			taskState	= "S_STORE";
			i_opcode	= 7'b0100011; #10;
			taskState	= "B_BRANCH";
			i_opcode	= 7'b1100011; #10;
			taskState	= "J_JAL";
			i_opcode	= 7'b1101111; #10;
			taskState	= "I_JALR";
			i_opcode	= 7'b1100111; #10;
			taskState	= "U_LUI";
			i_opcode	= 7'b0110111; #10;
			taskState	= "U_AUI";
			i_opcode	= 7'b0010111; #10;
			taskState	= "I_E";
			i_opcode	= 7'b1110011; #10;
			

			#(1000/`CLKFREQ);

 			$finish;
 		end

 	// --------------------------------------------------
 	//	Dump VCD
 	// --------------------------------------------------
 		reg	[8*32-1:0]	vcd_file;
 		initial begin
 			if ($value$plusargs("vcd_file=%s", vcd_file)) begin
 				$dumpfile(vcd_file);
 				$dumpvars;
 			end else begin
 				$dumpfile("src_imm_tb.vcd");
 				$dumpvars;
 			end
 		end

 	endmodule
