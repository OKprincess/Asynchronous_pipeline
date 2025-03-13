// ===================================================
//	=================[ VLSISYS Lab. ]=================
//	* Author		: oksj (oksj@sookmyung.ac.kr)
//	* Filename		: gray_code_converter.v
//	* Description	: 
// ===================================================
module bin_to_gray
(
	output		[7:0]	out_gray,
	input		[7:0]	in_bin
);

	//MSB is alsways same
	assign		out_gray[7]	= in_bin[7];	
	
	// xor delay is 6ns
	xor	#(6)	(out_gray[0], in_bin[1], in_bin[0]);	
	xor	#(6)	(out_gray[1], in_bin[2], in_bin[1]);	
	xor	#(6)	(out_gray[2], in_bin[3], in_bin[2]);	
	xor	#(6)	(out_gray[3], in_bin[4], in_bin[3]);	
	xor	#(6)	(out_gray[4], in_bin[5], in_bin[4]);	
	xor	#(6)	(out_gray[5], in_bin[6], in_bin[5]);	
	xor	#(6)	(out_gray[6], in_bin[7], in_bin[6]);	
endmodule

module gray_to_bin 
(
	output		[7:0]	out_bin,
	input		[7:0]	in_gray
);
	
	// MSB is always same
	assign		out_bin[7]	= in_gray[7];

	// xor delay is 6ns
	xor	#(6)	(out_bin[6], out_bin[7], in_gray[6]); 	
	xor	#(6)	(out_bin[5], out_bin[6], in_gray[5]); 	
	xor	#(6)	(out_bin[4], out_bin[5], in_gray[4]); 	
	xor	#(6)	(out_bin[3], out_bin[4], in_gray[3]); 	
	xor	#(6)	(out_bin[2], out_bin[3], in_gray[2]); 	
	xor	#(6)	(out_bin[1], out_bin[2], in_gray[1]); 	
	xor	#(6)	(out_bin[0], out_bin[1], in_gray[0]); 	
endmodule
