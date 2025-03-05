// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: fsm_tb.v
//	* Date			: 2025-03-05 
//	* Description	: 
// ===================================================
// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define NVEC		100		// # of Test Vector
`define	DEBUG		

// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"fsm.v"

module fsm_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire			[1:0]	o_light_a;
	wire			[1:0]	o_light_b;
	reg						i_traffic_a;
	reg						i_traffic_b;
	reg						i_mode_p;
	reg						i_mode_r;
	reg						i_rstn;
	wire					o_reqR;
	wire					o_ackL;
	reg						i_reqL;
	reg						i_ackR;

	fsm
	u_fsm(
		.o_light_a			(o_light_a			),
		.o_light_b			(o_light_b			),
		.i_traffic_a		(i_traffic_a		),
		.i_traffic_b		(i_traffic_b		),
		.i_mode_p			(i_mode_p			),
		.i_mode_r			(i_mode_r			),
		.i_rstn				(i_rstn				),
		.o_reqR				(o_reqR				),
		.o_ackL				(o_ackL				),
		.i_reqL				(i_reqL				),
		.i_ackR				(i_ackR				)
	);


// --------------------------------------------------
//	Tasks	
// --------------------------------------------------
	reg		[8*32-1:0]		taskState;
	task init;
		begin
			taskState	= "Init(Reset)";
			i_traffic_a	= 1'b0;
			i_traffic_b	= 1'b0;
			i_mode_p	= 1'b0;
			i_mode_r	= 1'b0;
			i_rstn		= 1'b0;
			i_reqL		= 1'b0;
			i_ackR		= 1'b0;
		end
	endtask

	task reset_n_cycle;
		input	[3:0]	n;
		begin
			#(n*1000/`CLKFREQ);
			taskState	= "Operate";
			i_rstn		= 1'b1;
		end
	endtask


// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		reset_n_cycle(4);

		i_reqL=1;
		{i_traffic_a, i_traffic_b} = $urandom;
		{i_mode_p, i_mode_r} = 2'b00;
		#30;
		i_reqL=0;i_ackR=1;
		#30;

		i_reqL=1;i_ackR=0;
		{i_traffic_a, i_traffic_b} = $urandom;
		{i_mode_p, i_mode_r} = 2'b00;
		#30;
		i_reqL=0;i_ackR=1;
		#30;

		i_reqL=1;i_ackR=0;
		{i_traffic_a, i_traffic_b} = $urandom;
		{i_mode_p, i_mode_r} = 2'b10;
		#30;
		i_reqL=0;i_ackR=1;
		#30;

		i_reqL=1;i_ackR=0;
		{i_traffic_a, i_traffic_b} = $urandom;
		{i_mode_p, i_mode_r} = 2'b10;
		#30;
		i_reqL=0;i_ackR=1;
		#30;
		
		i_reqL=1;i_ackR=0;
		{i_traffic_a, i_traffic_b} = $urandom;
		{i_mode_p, i_mode_r} = 2'b01;
		#30;
		i_reqL=0;i_ackR=1;
		#30;

		i_reqL=1;i_ackR=0;
		{i_traffic_a, i_traffic_b} = $urandom;
		{i_mode_p, i_mode_r} = 2'b01;
		#30;
		i_reqL=0;i_ackR=1;
		#30;

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
			$dumpfile("fsm_tb.vcd");
			$dumpvars;
		end
	end

endmodule
