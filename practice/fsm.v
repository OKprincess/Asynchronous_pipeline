// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: fsm.v
//	* Date			: 2025-03-05 
//	* Description	: 
// ===================================================
`include	"click.v"

module fsm
(
	output			[1:0]	o_light_a,
	output			[1:0]	o_light_b,
	input					i_traffic_a,
	input					i_traffic_b,
	input					i_mode_p,
	input					i_mode_r,
	input					i_rstn,
	output					o_reqR,
	output					o_ackL,
	input					i_reqL,
	input					i_ackR
);	

	// Light_A & Light_B
	parameter		S_S0	= 2'b00;	
	parameter		S_S1	= 2'b01;
	parameter		S_S2	= 2'b10;
	parameter		S_S3	= 2'b11;

	parameter		M_S0	= 1'b0;
	parameter		M_S1	= 1'b1;

	parameter		L_R		= 2'b00;
	parameter		L_G		= 2'b01;
	parameter		L_Y		= 2'b10;

	wire			click,reqR,reqL,ackL,ackR;
	click
	u_click(
		.o_click	(click		),
		.o_reqR		(o_reqR		),
		.o_ackL		(o_ackL		),
		.i_reqL		(i_reqL		),
		.i_ackR		(i_ackR		),
		.i_rstn		(i_rstn		)
	);
	//	For Mode FSM Output
	reg						mode;

	//	Main State Register
	reg				[1:0]	nState;
	reg				[1:0]	cState;
	always @(posedge click or negedge i_rstn) begin
		if(!i_rstn) begin
			cState	<= S_S0;
		end else begin
			cState	<= nState;
		end
	end

	// Sub State Register
	reg						nMode;
	reg						cMode;
	always @(posedge click or negedge i_rstn) begin
		if(!i_rstn) begin
			cMode	<= M_S0;
		end else begin
			cMode	<= nMode;
		end
	end

	// Next State Logic
	always @(*) begin
		case (cState)
			S_S0:	nState	= i_traffic_a ? S_S0 : S_S1;
			S_S1:	nState	= S_S2;
			S_S2:	nState	= (mode | i_traffic_b) ? S_S2 : S_S3;
			S_S3:	nState	= S_S0;
		endcase
	end

	// Next Mode Logic
	always @(*) begin
		case (cMode)
			M_S0:	nMode	= i_mode_p ? M_S1 : M_S0;
			M_S1:	nMode	= i_mode_r ? M_S0 : M_S1;
		endcase
	end

	reg		[1:0]	light_a, light_b;
	// Output Logic(Light)
	always @(*) begin
		case (cState)
			S_S0:	{light_a, light_b} = {L_G, L_R};
			S_S1:	{light_a, light_b} = {L_Y, L_R};
			S_S2:	{light_a, light_b} = {L_R, L_G};
			S_S3:	{light_a, light_b} = {L_R, L_Y};
		endcase
	end
	assign	#(5) o_light_a = light_a;
	assign	#(5) o_light_b = light_b;

	// Output Logic(Mode)
	always @(*) begin
		case (cMode)
			M_S0:	mode = 1'b0;
			M_S1:	mode = 1'b1;
		endcase
	end

	`ifdef DEBUG
		reg			[8*8-1:0]	strLA;
		reg			[8*8-1:0]	strLB;
		always @(*) begin
			case (o_light_a)
				L_G: strLA		= "GREEN";
				L_R: strLA		= "RED";
				L_Y: strLA		= "YELLOW";
			endcase
			case (o_light_b)
				L_G: strLB		= "GREEN";
				L_R: strLB		= "RED";
				L_Y: strLB		= "YELLOW";
			endcase
		end
	`endif

	endmodule
