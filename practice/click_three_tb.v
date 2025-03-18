// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: click_three_tb.v
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
`include	"click_three.v"

module click_three_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire	o_click1;
	wire	o_click2;
	wire	o_click3;
	reg	i_start;
	reg	i_rstn;

	click_three
	u_click_three(
		.o_click1			(o_click1			),
		.o_click2			(o_click2			),
		.o_click3			(o_click3			),
		.i_start	(i_start),
		.i_rstn				(i_rstn				)
	);



// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		i_start= 0;
		i_rstn	= 0;

		#(50);
		i_rstn	= 1;
		#(10);

		i_start= 1;
		#(30);

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
			$dumpfile("click_three_tb.vcd");
			$dumpvars;
		end
	end

endmodule
