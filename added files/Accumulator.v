module Accumulator (
	input clk, reset,
//	output we, loaded,
//	output [9:0] mkadd,
//	output [7:0] mkdata, mkq,
//	output [15:0] qout, outputsum,
	output [6:0] H0, H1, H2, H3, H4, H5
);
	
	
	//have 16bits read at a time = 2 addresses in M10k 
	
	reg loaded_mem = 1'b0;
	
	reg [9:0] mk_addr = 10'd0;
	reg [9:0] mk_addr_n = 10'd0;
	reg [7:0] mk_data = 8'd0;
	reg [7:0] mk_data_n = 8'd0;
	reg mk_wren = 1'b0;
	wire [7:0] mk_q; 			//concatenate to add bitwidth for adder; read_val = {8'd0,mk_q}
	
	reg [15:0] input_sum = 16'd0;
	reg [15:0] read_val = 16'd0;
	wire [15:0] output_sum;
	
//	reg carry_i= 1'd0; 
//	wire carry_o;
	
	reg [15:0] q_in = 16'd0;
	reg [15:0] q_out = 16'd0;
	
	reg stay_at_zero = 1'd0;
	
	
	assign  we = mk_wren;
//	assign loaded = loaded_mem;
//	assign mkadd = mk_addr;
//	assign mkdata = mk_data;
//	assign mkq = mk_q;
//	assign qout = q_out;
//	assign  outputsum = output_sum;
	

//	MTenK mk(
//		//inputs
//		.address(mk_addr), .clock(clk), .data(mk_data),
//		.wren(mk_wren), 
//		//output
//		.q(mk_q)
//	);
	
	basic_ram br(
		//input
		 .clk(clk), .wr_en(mk_wren), 
		.addr(mk_addr), .data_in(mk_data), 
		//output
		.q(mk_q)
	);
	
	
	FA_sixteen fasix(
		//input
		.A(input_sum), .B(read_val), 
		//output
		.sum(output_sum)
	);
	
	HexDisplay hd0( .binary_in(q_out[3:0]), .h0(H0) );
	HexDisplay hd1( .binary_in(q_out[7:4]), .h0(H1) );
	HexDisplay hd2( .binary_in(q_out[11:8]), .h0(H2) );
	HexDisplay hd3( .binary_in(q_out[15:12]), .h0(H3) );
	HexDisplay hd4( .binary_in(4'b00), .h0(H4) );
	HexDisplay hd5( .binary_in(4'b00), .h0(H5) );
	
	
	
	
////////////////////

	always @(posedge clk) begin
		if(~reset)  begin
		//if reset is pressed, write enable is activated for the m10k
			mk_wren <= 1'b1;
		end
		else if(loaded_mem) begin
			mk_wren <= 1'b0;
		end
		
		mk_addr <= mk_addr_n;
		mk_data <= mk_data_n;	
		q_out <= q_in;
	end
	
///////////////////
	
	
	always @(mk_wren, mk_q, mk_addr) begin
	
		if(mk_wren) begin
			input_sum = 16'd0;
			read_val = 16'd0;
//			q_in = 16'd0;
			stay_at_zero = 1'b0;
			
			//when write  enable is activated, fill memory
			if(mk_addr < 8'd15) begin
				mk_addr_n = mk_addr+10'd01;
				mk_data_n = mk_data+8'd01;
				loaded_mem = 1'b0;
				
			end else if (mk_addr == 8'd15) begin
				mk_addr_n = 10'd0;
				mk_data_n = 8'd0;
				loaded_mem = 1'b1;
			end
		end 
		
		
		else if(~mk_wren) begin
			if(loaded_mem == 1'b1) begin
				//read in the value to add,  update next m10k addr
				mk_data_n = 8'd0;
				
				if(stay_at_zero) begin
					mk_addr_n = 10'd0;
					input_sum = q_out;
					read_val = {8'd0, mk_q};
		//				q_in = output_sum;
					stay_at_zero = 1'b1;
					
				end
				else if(mk_addr == 8'd0) begin
					mk_addr_n = mk_addr+10'd01;
					read_val = 16'd0;
					input_sum = 16'd0;
		//				q_in = q_out;
					stay_at_zero = 1'b0;

				end
				else if(mk_addr < 8'd15) begin
					mk_addr_n = mk_addr+10'd01;
					read_val = {4'd0, mk_q};
					input_sum = q_out;
					
		//				q_in  =  output_sum;
					stay_at_zero = 1'b0;

				end
				else if(mk_addr == 8'd15) begin
					mk_addr_n = 10'd0;
					read_val = {4'd0, mk_q};
					input_sum = q_out;
		//				q_in  =  output_sum;
					stay_at_zero = 1'b1;
				end
			end
		end
		
		
	end
	
	always @(output_sum) begin
		q_in = output_sum;
	end
	
	
	
	

endmodule
