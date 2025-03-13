// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: gray_code_converter_tb.v
//	* Date			: 2025-03-06 
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
`include	"gray_code_converter.v"

module gray_code_converter_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire	[7:0]	out_gray;
	wire	[7:0]	out_bin;
	reg		[7:0]	i_data;

	bin_to_gray
	u_bin_to_gray(
		.out_gray	(out_gray		),
		.in_bin		(i_data			)
	);

	gray_to_bin
	u_gray_to_bin(
		.out_bin	(out_bin		),
		.in_gray	(out_gray		)
	);

	task	init;
		begin	
			i_data =0;
		end
	endtask



// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();

		for (i=0; i<`SIMCYCLE; i++) begin
			i_data = i;
			#(30);
		end
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
			$dumpfile("gray_code_converter_tb.vcd");
			$dumpvars;
		end
	end

endmodule
