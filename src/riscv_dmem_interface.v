// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: SoJeong Ok (oksj@sookmyung.ac.kr)
//	* Filename		: riscv_dmem_interface.v
//	* Description	: 
// ==================================================
`ifndef		NOINC
`include	"riscv_configs.v"
`endif

module riscv_dmem_interface 
(
	// Bypass Signal 
	output		[  `XLEN-1:0]	o_dmem_intf_addr,
	output						o_dmem_intf_wen,
	input		[  `XLEN-1:0]	i_dmem_intf_addr,
	input						i_dmem_intf_wen,

	// To Data Memory: write data, byte_sel 
	output		[  `XLEN-1:0]	o_dmem_intf_wr_data,
	output		[`XLEN/8-1:0]	o_dmem_intf_byte_sel,
	// To CPU: read data
	output reg	[  `XLEN-1:0]	o_dmem_intf_rd_data,
	
	// From CPU: write data, byte_sel
	input		[  `XLEN-1:0]	i_dmem_intf_wr_data,
	//input		[`XLEN/8-1:0]	i_dmem_intf_byte_sel,			
	// From Memory: read data 	
	input		[  `XLEN-1:0]	i_dmem_intf_rd_data,
	// Control: function3, clk
	input		[		 2:0]	i_dmem_intf_func3
);

	// Bypass
	assign		o_dmem_intf_addr	= i_dmem_intf_addr;
	assign		o_dmem_intf_wen		= i_dmem_intf_wen;
	/* Strobe Signal catch read or write Signal
	* if using this DQS in dmem_intf, input byte sel signal needX
	* or Ctrl module.*/
	reg			[3:0]	dmem_intf_strb;
	always @(*) begin
		case (i_dmem_intf_func3)
			`FUNCT3_MEM_BYTE,
			`FUNCT3_MEM_BYTEU	: dmem_intf_strb	= 4'b0001;

			`FUNCT3_MEM_HALF,
			`FUNCT3_MEM_HALFU	: dmem_intf_strb	= 4'b0011;

			`FUNCT3_MEM_WORD	: dmem_intf_strb	= 4'b1111;
			default				: dmem_intf_strb	= 4'b1111;
		endcase
	end
	

	//	To Data Memory
	assign		o_dmem_intf_wr_data	= i_dmem_intf_wr_data	<< (8*i_dmem_intf_addr[1:0]);
	assign		o_dmem_intf_byte_sel= dmem_intf_strb	 	<< (1*i_dmem_intf_addr[1:0]);

	// To CPU
	wire	[`XLEN-1:0] byte_aligned_dmem_rd_data;
	assign	byte_aligned_dmem_rd_data = i_dmem_intf_rd_data >> (8*i_dmem_intf_addr[1:0]);

	always @(*) begin
		case (i_dmem_intf_func3)
			`FUNCT3_MEM_BYTE	: o_dmem_intf_rd_data = {{24{byte_aligned_dmem_rd_data[ 7]}}, byte_aligned_dmem_rd_data[ 7:0]};
			`FUNCT3_MEM_HALF	: o_dmem_intf_rd_data = {{16{byte_aligned_dmem_rd_data[15]}}, byte_aligned_dmem_rd_data[15:0]};
			`FUNCT3_MEM_WORD	: o_dmem_intf_rd_data = {byte_aligned_dmem_rd_data[31:0]};
			`FUNCT3_MEM_BYTEU	: o_dmem_intf_rd_data = {{24{1'b0}}, byte_aligned_dmem_rd_data[ 7:0]};
			`FUNCT3_MEM_HALFU	: o_dmem_intf_rd_data = {{16{1'b0}}, byte_aligned_dmem_rd_data[15:0]};
			default				: o_dmem_intf_rd_data = 32'dx;
		endcase
	end
	
	
endmodule
