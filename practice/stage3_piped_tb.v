// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: stage3_piped_tb.v
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
`include	"stage3_piped.v"

module stage3_piped_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------

	reg		i_rstn;
	reg		i_start;
	reg		[7:0]	i_data;
	wire		[7:0]	o_data;

	stage3_piped
	u_stage3_piped(
		.i_rstn				(i_rstn			),
		.i_start			(i_start			),
		.i_data				(i_data				),
		.o_data				(o_data				)
	);




// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		i_rstn=0;
		i_start=0;
		i_data=7'b1111_111;
		#(30);
		i_rstn=1;
		i_start=1;
		#(50);

		i_data=7'd0;
		#(10);
		i_data=7'd1;
		#(10);
		i_data=7'd2;
		#(10);
		i_data=7'd3;
		#(10);
		i_data=7'd4;
		#(10);
		i_data=7'd5;
		#(10);
		i_data=7'd6;
		#(10);
		i_data=7'd7;
		#(10);
		i_data=7'd8;

		#(300);

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
			$dumpfile("stage3_piped_tb.vcd");
			$dumpvars;
		end
	end

endmodule
