module basic_ram ( 
	input clk, wr_en, 
	input [9:0] addr,
	input [7:0] data_in, 
	output [7:0] q
); 

	reg [7:0] mem [1023:0]; 
	reg [7:0] qout;
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
