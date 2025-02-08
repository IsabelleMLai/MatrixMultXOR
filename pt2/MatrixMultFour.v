module MatrixMultFour(
	input clock, start,
	//flatten array into rows followed by each other {row1, row2, row3, row 4}
		//a11 = [7:0], a12 = [15:8]
	input [127:0] A, B,	//128 bits = 8*(4*4)
	
	//testbbench
//	output [3:0] curr_st, nxt_st,
//	output wrenab, wrenc, mac_rst,
//	output [9:0] addra, addrb,  
//	output [8:0] addrc,
//	output [7:0] outa, outb,
//	output [19:0] outc,
//	output [1:0] cols, rows, items,
//	output [19:0] cdatain,
	////////////////////
	
//	output [319:0] matrix_C,		//20*(4*4) = 320
	output  [19:0] final_xor, 
	output [9:0] MC
);

	localparam [3:0]  wait_for_start = 4'b0000;
	localparam [3:0]  store_ab = 4'b0001;
	localparam [3:0]  read_and_mult = 4'b0010;
	localparam [3:0]  read_c = 4'b0100;

	
	
	reg [3:0]  state = wait_for_start;
	reg [3:0] n_state = wait_for_start;
	
	
	reg [1:0] item_count =2'b00;
	reg [1:0] n_item_count =2'b00;
	reg [1:0] row_count = 2'b00;
	reg [1:0] n_row_count = 2'b00;
	reg [1:0] col_count= 2'b00;
	reg [1:0] n_col_count= 2'b00;

	
	
	reg wren_ab = 1'b0;
	reg [9:0] addr_a = 10'd0;
	reg [9:0] n_addr_a = 10'd0;
	reg [7:0] datain_a;
	wire [7:0] out_a;

//	reg ram_wren_b = 1'b0;
	reg [9:0] addr_b = 10'd0;
	reg [9:0] n_addr_b = 10'd0;
	reg [7:0] datain_b;
	wire [7:0] out_b;

	reg wren_c = 1'b0;
	reg [8:0] addr_c = 9'd0;
	reg [8:0] n_addr_c = 9'd0;
	wire [19:0] datain_c;
	wire [19:0] out_c;
	
	reg next_cpos = 1'b1;
	
	
//	reg [319:0] C = 320'd0;
//	assign matrix_C = C;
	reg [19:0] xor_tot  = 20'd0;
	reg [19:0] xor_tot_n  = 20'd0;
	
	assign final_xor = xor_tot;
	
	reg [9:0] mult_count = 10'd0;
		reg[9:0] m_c = 10'd1;
	assign MC = mult_count;
	
////////////TESTBENCH
//	assign curr_st = state;
//	assign nxt_st = n_state;
//	assign  wrenab = wren_ab;
//	assign wrenc = wren_c;
//	assign mac_rst = next_cpos;
//	assign addra = addr_a;
//	assign addrb = addr_b;
//	assign addrc = addr_c;
//	assign  outa = out_a;
//	assign  outb = out_b;
//	assign outc = out_c;
//	assign cols = col_count;
//	assign  rows = row_count;
//	assign items = item_count;
//	assign cdatain = datain_c;
////////////



	

	basic_ram ram_a( 
		//input
		.clk(clock), .wr_en(wren_ab), 
		.addr(addr_a),				//[9:0] = 10bits
		.data_in(datain_a), 		//[7:0] = 8bits
		//output
		.q(out_a)						//[7:0] = 8bits
	); 

	basic_ram ram_b( 
		//input
		.clk(clock), .wr_en(wren_ab), 
		.addr(addr_b),				//[9:0] = 10bits
		.data_in(datain_b), 		//[7:0] = 8bits
		//output
		.q(out_b)						//[7:0] = 8bits
	); 

	
	
	
	
	
	
	
//NNEEDS TO BE 20BITS WIDE FOR DATAIN
	twenty_bit_ram ram_c( 
		//input
		.clk(clock), .wr_en(wren_c), 
		.addr(addr_c),				//[9:0] = 10bits
		.data_in(datain_c), 		//[7:0] = 8bits
		//output
		.q(out_c)						//[7:0] = 8bits
	); 

	OneMac mac1(
		.clock(clock), .reset(next_cpos),
		.ain(out_a), .bin(out_b), 
		//output
		.sum(datain_c)
	);


	//////////////////////////////////////////////////////////
	// 1. when start is pressed, write A and B into memory
	// 2. process 1 MAC per cycle
	

	always @(posedge clock) begin
		if(~start) begin
			state  <= store_ab;
			wren_ab <= 1'b1;
		end
		else if(n_state == store_ab) begin
			state <= n_state;
			wren_ab <= 1'b1;
		end 
		else begin
			state <= n_state;
			wren_ab <= 1'b0;
		end
		
		mult_count <= m_c;
		item_count <= n_item_count;
		row_count <= n_row_count;
		col_count <= n_col_count;
		addr_a <= n_addr_a;
		addr_b <= n_addr_b;
		addr_c <= n_addr_c;
		
		xor_tot  <= xor_tot_n;
	end
	
	
	
	
	
	always @(state, wren_ab, item_count, row_count, addr_a, addr_b, addr_c) begin
		case(state)
///////////////////////////////////////////////////////		
			wait_for_start: begin 
				//still in start state waiting for start to be pressed
				datain_a = 8'd0;
				datain_b = 8'd0;
				n_addr_a = 10'd0;
				n_addr_b = 10'd0;
						
				n_item_count = 2'd0;
				n_row_count = 2'd0;
				n_col_count = 2'd0;
				next_cpos = 1'b1;
				wren_c = 1'b0;
				n_addr_c = 9'd0;
			
				n_state = wait_for_start;
			end
			
///////////////////////////////////////////////////////		
			
			store_ab : begin
				m_c = 10'd0;
				case(addr_a) 
					10'd0: begin
						datain_a = A[7:0];
						datain_b = B[7:0];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd1: begin
						datain_a = A[15:8];
						datain_b = B[15:8];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd2: begin
						datain_a = A[23:16];
						datain_b = B[23:16];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd3: begin
						datain_a = A[31:24];
						datain_b = B[31:24];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd4: begin
						datain_a = A[39:32];
						datain_b = B[39:32];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd5: begin
						datain_a = A[47:40];
						datain_b = B[47:40];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd6: begin
						datain_a = A[55:48];
						datain_b = B[55:48];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd7: begin
						datain_a = A[63:56];
						datain_b = B[63:56];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd8: begin
						datain_a = A[71:64];
						datain_b = B[71:64];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd9: begin
						datain_a = A[79:72];
						datain_b = B[79:72];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd10: begin
						datain_a = A[87:80];
						datain_b = B[87:80];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd11: begin
						datain_a = A[95:88];
						datain_b = B[95:88];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd12: begin
						datain_a = A[103:96];
						datain_b = B[103:96];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd13: begin
						datain_a = A[111:104];
						datain_b = B[111:104];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd14: begin
						datain_a = A[119:112];
						datain_b = B[119:112];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd15: begin
						datain_a = A[127:120];
						datain_b = B[127:120];
						n_addr_a = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_state = store_ab;					
					end
					10'd16: begin
						datain_a = 8'd0;
						datain_b = 8'd0;
						n_addr_a = 10'd0;
						n_addr_b = 10'd0;
						n_state = read_and_mult;					
					end
					
				endcase
				
				n_item_count = 2'd0;
				n_row_count = 2'd0;
				n_col_count = 2'd0;
				next_cpos = 1'b1;
				wren_c = 1'b0;
				n_addr_c = 9'd0;
			end
///////////////////////////////////////////////////////		
			
			read_and_mult: begin
				m_c = mult_count +  10'd1;
				if(addr_a == 10'd16) begin
					n_addr_a = 10'd16;
					n_addr_b = 10'd16;
					
					n_item_count = item_count+2'd1;
					n_row_count = row_count;
					n_col_count = col_count;
					
					next_cpos = 1'b1;
					
					if(item_count == 2'd1) begin
						wren_c = 1'b1;
						n_addr_c = addr_c + 9'd01;
						
						n_state = read_and_mult;
					end 
					else begin
						wren_c = 1'b0;
						if (item_count > 2'd1) begin
							n_state = read_c;
							n_addr_c = 9'd0;
						end 
						else begin
							n_state = read_and_mult;
							n_addr_c = addr_c;
						end
					end
					
				end
				
					
				else if(item_count == 2'd0) begin
					n_addr_a = addr_a+10'd01;
					n_addr_b = addr_b + 10'd04;
					
					n_item_count = item_count+2'd1;
					n_row_count = row_count;
					n_col_count = col_count;
					
					//reset accumulator
					next_cpos = 1'b0;
					wren_c = 1'b0;
					n_addr_c = addr_c;
					
					n_state = read_and_mult;
				end 
					
				else if(item_count == 2'd3) begin
				
					if((row_count == 2'd3) && (col_count == 2'd3)) begin
						//donewith the whole thing
						//address 16 in matrices a and b = 0 value						
						n_addr_a  = addr_a + 10'd01;
						n_addr_b = addr_b + 10'd01;
						n_row_count = row_count+2'd1;	// becomes 4
						n_col_count = col_count+2'd1;
						
					end else if(col_count == 2'd03) begin
						n_addr_a = addr_a + 10'd01;
						n_addr_b = 10'd0;
						n_row_count = row_count+2'd1;
						n_col_count = 2'd0;

					end else begin
						n_addr_a = addr_a - 10'd03;
						n_addr_b = {8'd00, (col_count + 2'd1)};
						n_row_count = row_count;					
						n_col_count = col_count+2'd1;
					end
					n_item_count = 2'd00;
					
					next_cpos = 1'b1;
					wren_c = 1'b0;
					n_addr_c = addr_c;
					
					n_state = read_and_mult;
				end
					
				else begin
					n_addr_a = addr_a+10'd01;
					n_addr_b = addr_b+ 10'd04;
					
					n_item_count= item_count+2'd1;
					n_row_count = row_count;
					n_col_count = col_count;
					
					next_cpos = 1'b1;
					
					n_state = read_and_mult;
					
					if((item_count == 2'd1) &&  ((row_count> 2'd0) || (col_count > 2'd0))) begin
						//write to c ram
						wren_c = 1'b1;
						n_addr_c = addr_c + 9'd01;
					end
					else begin
						wren_c = 1'b0;
						n_addr_c = addr_c;
					end
				end	
										
			end
			
///////////////////////////////////////////////////////		
			
			read_c: begin
				if(addr_c < 9'd16) begin
					n_addr_c = addr_c + 9'd01;
					n_state = read_c;
				end else if(addr_c == 9'd16) begin
					n_addr_c = 9'd00;
					n_state = wait_for_start;	
				end
				
				wren_c = 1'b0;
				datain_a = 8'd0;
				datain_b = 8'd0;
				n_addr_a = 10'd0;
				n_addr_b = 10'd0;
						
				n_item_count = 2'd0;
				n_row_count = 2'd0;
				n_col_count = 2'd0;
				next_cpos = 1'b1;
						
			end
			
///////////////////////////////////////////////////////		
		endcase
	end
			
			
	always @(out_c) begin
//		case(addr_c) 
//		//xor_tot_n = xor_tot ^  out_c;
//			9'd1: C[19:0] = out_c;
//			9'd2: C[39:20] = out_c; // 20 bits
//			9'd3: C[59:40] = out_c;
//			9'd4: C[79:60] = out_c;
//			9'd5: C[99:80] = out_c;
//			9'd6: C[119:100] = out_c;
//			9'd7: C[139:120] = out_c;
//			9'd8: C[159:140] = out_c;
//			9'd9: C[179:160] = out_c; 
//			9'd10: C[199:180] = out_c; 
//			9'd11: C[219:200] = out_c;
//			9'd12: C[239:220] = out_c;
//			9'd13: C[259:240] = out_c; 
//			9'd14: C[279:260] = out_c;
//			9'd15: C[299:280] = out_c;
//			9'd16: C[319:300] = out_c;
//		endcase
		if((addr_c  >= 9'd1) && (addr_c <= 9'd16) && (state == read_c)) begin
			xor_tot_n = xor_tot ^  out_c;
		end 
		else begin
			xor_tot_n =  xor_tot;
		end
			
	end

			
			
			





endmodule
