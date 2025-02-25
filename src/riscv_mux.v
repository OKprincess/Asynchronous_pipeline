// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: SoJeong Ok (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_mux.v
//	* Date			: 2024-09-30 18:03:03
//	* Description	: 
// ==================================================
`ifndef		NOINC 
`include	"riscv_configs.v"
`endif

module	riscv_mux
#(
	parameter	N_MUX_IN	= 2
)
(
	output		[			  `XLEN-1:0]	o_mux_data,
	input		[(N_MUX_IN * `XLEN)-1:0]	i_mux_concat_data,
	input		[  $clog2(N_MUX_IN)-1:0]	i_mux_sel
);

	wire	[`XLEN-1:0]		mux_input_arr[0:N_MUX_IN-1];

	genvar	i;
	generate
		for	(i=0; i<N_MUX_IN; i=i+1) begin
			assign	mux_input_arr[i] = i_mux_concat_data[`XLEN*(i+1)-1-:`XLEN];
		end
	endgenerate

	assign	o_mux_data	= mux_input_arr[i_mux_sel];
	// select signal==0 ---> output data =Most right data
endmodule
