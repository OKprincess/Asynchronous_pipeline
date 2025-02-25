// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: SoJeong Ok (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_register_tb.v
//	* Date			: 2024-09-30 18:16:58
//	* Description	: 
// ==================================================

// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define NVEC		100		// # of Test Vector

// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"riscv_register.v"

module riscv_register_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	parameter	REGISTER_INIT	= 32'h0A0A0A0A;
	
	wire		[`XLEN-1:0]		o_register_q;
	reg			[`XLEN-1:0]		i_register_d;
	reg							i_register_en;
	reg							i_clk;
	reg							i_rstn;

	riscv_register
	#(
		.REGISTER_INIT		(REGISTER_INIT		)
	)
	u_riscv_register(
		.o_register_q		(o_register_q		),
		.i_register_d		(i_register_d		),
		.i_register_en		(i_register_en		),
		.i_clk				(i_clk				),
		.i_rstn				(i_rstn				)
	);


// --------------------------------------------------
//	Clock
// --------------------------------------------------
	always	#(500/`CLKFREQ) i_clk	= ~i_clk;

// --------------------------------------------------
//	Tasks
// --------------------------------------------------
	task init;
		begin
			i_register_d	= 0;
			i_register_en	= 0;
			i_clk			= 0;
			i_rstn			= 0;
		end
	endtask

	task resetNCycle;
		input	[7:0]	N;
		begin
			#(N*1000/`CLKFREQ);
			i_rstn		= 1;
		end
	endtask
// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		resetNCycle(4);
		for (i=0; i<`SIMCYCLE; i++) begin
			i_register_en	= 1'b1;
			i_register_d	= $urandom;
			#(1000/`CLKFREQ);
			i_register_en	= 1'b0;
			i_register_d	= $urandom;
			#(1000/`CLKFREQ);
		end
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
			$dumpfile("riscv_register_tb.vcd");
			$dumpvars;
		end
	end

endmodule
