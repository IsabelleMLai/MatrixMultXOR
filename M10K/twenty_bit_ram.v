module twenty_bit_ram(

	input clk, wr_en, 
	input [8:0] addr,		//log2(512) = 9bit addresses
	input [19:0] data_in, 
	output [19:0] q
); 

	reg [19:0] mem [512:0]; 
	
	reg [19:0] qout;
	assign q = qout;
	// To initialize the RAM, Quartus supports initialization 
	// which normal RAMs and synthesis do not support. 
	// initial begin // mem[0] = 24'h03B03F; 
	// mem[1] = 24'h000FFF; // mem[2] = 24'hBEBEBE; 
	// ... // mem[1023] = 24'h726384; 
	// end 
	
	always @(posedge clk) begin 
		if (wr_en) begin 
			mem[addr] <= #1 data_in; // write mem 
		end 
		else begin
			qout <= #1 mem[addr]; // read mem 
		end
	end 


endmodule
