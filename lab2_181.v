
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module lab2_181(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);



//=======================================================
//  REG/WIRE declarations
//=======================================================


//reg [3:0] x = 4'd01;
reg [127:0] matrix_a = {8'd16, 8'd15, 8'd14, 8'd13, 
								8'd12, 8'd11, 8'd10, 8'd9, 
								8'd8, 8'd7, 8'd6, 8'd5, 
								8'd4, 8'd3, 8'd2, 8'd1};
								
reg [127:0] d_test = {8'd74, 8'd79, 8'd5, 8'd55, 
							8'd6, 8'd96, 8'd87,  8'd45, 
							8'd33, 8'd46, 8'd70, 8'd46, 
							8'd45, 8'd22, 8'd81, 8'd11};
								
reg [127:0] matrix_ainv = {8'd1, 8'd2, 8'd3, 8'd4,
									8'd5, 8'd6, 8'd7, 8'd8, 
									8'd9, 8'd10, 8'd11, 8'd12, 
									8'd13, 8'd14, 8'd15, 8'd16};
	
reg [127:0] matrix_b = {8'd3, 8'd3, 8'd3, 8'd3, 
								8'd2, 8'd2, 8'd2, 8'd2, 
								8'd1, 8'd1, 8'd1, 8'd1, 
								8'd0, 8'd0, 8'd0, 8'd0};

reg [127:0] matrix_binv = {8'd0, 8'd0, 8'd0, 8'd0, 
									8'd1, 8'd1, 8'd1, 8'd1,
									8'd2, 8'd2, 8'd2, 8'd2,
									8'd3, 8'd3, 8'd3, 8'd3, };
									
								
wire [19:0] xor_into_hex;
wire [9:0] counter;
	


//=======================================================
//  Structural coding
//=======================================================


//Accumulator ac(
//	.clk(CLOCK_50), .reset(KEY[1]), 
//	.H0(HEX0), .H1(HEX1), .H2(HEX2), .H3(HEX3), .H4(HEX4), .H5(HEX5)
//);



MatrixMultFour mmf(.clock(CLOCK_50), .start(KEY[0]), 
	.A(matrix_a), .B(matrix_b), .final_xor(xor_into_hex), .MC(counter) );

HexDisplay hex00( .binary_in(xor_into_hex[3:0]), 
	.h0(HEX0)
);

HexDisplay hex11(
	.binary_in(xor_into_hex[7:4]), 
	.h0(HEX1)
);
HexDisplay hex22(
	.binary_in(xor_into_hex[11:8]), 
	.h0(HEX2)
);
HexDisplay hex33(
	.binary_in(xor_into_hex[15:12]), 
	.h0(HEX3)
);
HexDisplay hex44(
	.binary_in(counter[3:0]), 
	.h0(HEX4)
);
HexDisplay hex55(
	.binary_in(counter[7:4]), 
	.h0(HEX5)
);

HexDisplay hex66(
	.binary_in({2'b0, counter[9:8]}), 
	.h0(HEX6)
);

endmodule
