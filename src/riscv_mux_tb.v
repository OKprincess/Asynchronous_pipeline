// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: SoJeong Ok (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_mux_tb.v
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
`include	"riscv_mux.v"

module riscv_mux_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	parameter	N_MUX_IN	= 3;

	wire	[             `XLEN-1:0]	o_mux_data;
	reg		[(N_MUX_IN * `XLEN)-1:0]	i_mux_concat_data;
	reg		[  $clog2(N_MUX_IN)-1:0]	i_mux_sel;

	riscv_mux
	#(
		.N_MUX_IN			(N_MUX_IN			)
	)
	u_riscv_mux(
		.o_mux_data			(o_mux_data			),
		.i_mux_concat_data	(i_mux_concat_data	),
		.i_mux_sel			(i_mux_sel			)
	);


// --------------------------------------------------
//	Tasks
// --------------------------------------------------
	reg		[8*32-1:0]	taskState;

	task init;
		begin
			taskState			= "Init";
			i_mux_concat_data	= 0;
			i_mux_sel			= 0;
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		#(1000/`CLKFREQ);

		for (i=0; i<`SIMCYCLE; i++) begin
			i_mux_concat_data	= {$urandom, $urandom, $urandom};
			i_mux_sel			= 0;
			#(1000/`CLKFREQ);
			i_mux_sel			= 1;
			#(1000/`CLKFREQ);
			i_mux_sel			= 2;
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
			$dumpfile("riscv_mux_tb.vcd");
			$dumpvars;
		end
	end

endmodule
