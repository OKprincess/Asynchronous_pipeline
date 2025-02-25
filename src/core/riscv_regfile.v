// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: SoJeong Ok (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_regfile.v
//	* Date			: 2024-10-04 16:49:16
//	* Description	: Register File for RV32I
// ==================================================

`ifndef		NOINC
`include	"riscv_configs.v"
`endif

// Same as Single Cycle & Pipelined
module riscv_regfile
(
	output		[`XLEN-1:0]		o_regfile_rs1_data,
	output		[`XLEN-1:0]		o_regfile_rs2_data,
	input		[	   4:0]		i_regfile_rs1_addr,
	input		[	   4:0]		i_regfile_rs2_addr,
	input		[`XLEN-1:0]		i_regfile_rd_data,
	input		[	   4:0]		i_regfile_rd_addr,
	input						i_regfile_rd_wen,
	input						i_clk
);

	// number of Register is 32. 
	// Each Register array XLEN-bit
	reg			[`XLEN-1:0]		registers[0:31];

	// rs1 & rs2 is for Read ports
	// output data is 32-bit data in Register No.n(=i_regfile_rs_addr)
	assign		o_regfile_rs1_data = registers[i_regfile_rs1_addr];
	assign		o_regfile_rs2_data = registers[i_regfile_rs2_addr];

	// No.0 Register "Zero" is HardWired X0
	// Cannot write to this Register.( Constant Value; 32'b0)
	initial		registers[0] = `XLEN'b0;

	always @(posedge i_clk) begin
		// "Write Enabled" & "Write address is not X0"
		if (i_regfile_rd_wen && (i_regfile_rd_addr != 0)) begin
			registers[i_regfile_rd_addr] <= i_regfile_rd_data;
		// Hold Data
		end else begin
			registers[i_regfile_rd_addr] <= registers[i_regfile_rd_addr];
		end
	end

endmodule
