module FullAdder(
	input a, b, c, 
	output cout, sum
);
//borrowed from my code in 180

assign sum = a^b^c;
assign cout = (a&b)|(a&c)|(b&c);

endmodule
