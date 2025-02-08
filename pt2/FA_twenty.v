module FA_twenty(
	input [19:0] A, B,
//	input cin,
//	output cout,
	output [19:0] sum
);
//borrowed from my code in 180
//cout = overflow bit, unsigned adding 

	wire [20:0] carries;
	assign carries[0] = 1'b0;
	

	genvar i;
	generate 
		for(i=0; i<20; i=i+1) begin: gen_name2
			FullAdder fa(A[i], B[i], carries[i], carries[(i+1)], sum[i]);
		end
	endgenerate
	
	
//	assign cout = carries[16];


endmodule
