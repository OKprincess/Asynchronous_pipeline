// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: dff_tb.v
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
`include	"dff.v"

module dff_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	reg		i_clk;
	reg		i_d;
	wire	o_q;

	dff
	u_dff(
		.i_clk	(i_clk	),
		.i_d	(i_d	),
		.o_q	(o_q	)
	);


	always #(500/`CLKFREQ)	i_clk = ~i_clk;

	reg		[4*32-1:0]		taskState;

	task	init;
		begin
			i_d		= 0;
			i		= 0;
			i_clk	= 0;
		end
	endtask
// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		#20;
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
		{i_d} = $random;#(10);
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
			$dumpfile("dff_tb.vcd");
			$dumpvars;
		end
	end

endmodule
