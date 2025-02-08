module FA_sixteen(
	input [15:0] A, B,
//	input cin,
//	output cout,
	output [15:0] sum
);
//borrowed from my code in 180
//cout = overflow bit, unsigned adding 

	wire [16:0] carries;
	assign carries[0] = 1'b0;
	

	genvar i;
	generate 
		for(i=0; i<16; i=i+1) begin: gen_name
			FullAdder fa(A[i], B[i], carries[i], carries[(i+1)], sum[i]);
		end
	endgenerate
	
	
//	assign cout = carries[16];


endmodule
