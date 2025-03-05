// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: click_tb.v
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
`include	"click.v"

module click_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire		o_click;
	wire		o_ackL;
	wire		o_reqR;


	reg			i_reqL;
	reg 		i_ackR;
	reg			i_rstn;

	click
	u_click1(
		.o_click			(o_click			),
		.o_reqR				(o_reqR				),
		.o_ackL				(o_ackL				),
		.i_reqL				(i_reqL				),
		.i_ackR				(i_ackR				),
		.i_rstn				(i_rstn				)
	);

	always @(*) begin
		if(o_reqR) i_ackR=1;
	end
// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		i_reqL=0;
		i_ackR=0;
		i_rstn=0;

		#(50);
		i_rstn=1;

		
		i_reqL=0;

		#(30);
		i_reqL=1;

		#(30);
		i_reqL=0;

		i_ackR=1;
		#(30);

		i_ackR=0;
		#(30);
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
			$dumpfile("click_tb.vcd");
			$dumpvars;
		end
	end

endmodule
