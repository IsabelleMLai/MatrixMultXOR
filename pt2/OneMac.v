module OneMac (
	input clock, reset,
	input [7:0] ain, bin,
	
	output [19:0] sum
);



//adder input and output are both 16 bits, doesn't account for overflow
//will keep multiplying and adding the inputs every clock cycle
		// if you want to stop it, need to set ain or bin to 0 !!!!!!!!
		//changing ain and bin between  clock cycles will make the result show  up 
			//at the next  posedge
		
	reg [15:0] mult_out = 16'd0;
	wire [15:0] adder_out;
	reg [19:0] qin = 20'd0;
	reg [19:0] qout = 20'd0;
	reg [19:0] acc_sum = 20'd0;
	reg rst_sig = 1'b1;
	
	assign sum = qout;
	
	
	FA_twenty add(
		//input
		.A(({4'd0, mult_out})), .B(acc_sum), 
		//output
		.sum(adder_out)
	);
	
	
	
	always @(posedge clock) begin
		if(~reset) begin
			rst_sig <= 1'b0;
		end 
		else begin
			rst_sig <= 1'b1;
		end
		qout <= qin;
	end

	always @(ain, bin, qout) begin
		if(~rst_sig) begin
			acc_sum = 20'd0;
		end
		else begin
			acc_sum = qout;
		end
		mult_out = ain*bin;
		
	end
	always @(adder_out) begin
		qin = adder_out;
	end
	
	
	

endmodule
