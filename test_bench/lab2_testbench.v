module lab2_testbench;

	reg clk;
	reg [0:10000] i;
	reg rst = 1'b1;
	
	reg [127:0] matrixA, matrixB;
	wire [3:0] c_state, n_state;
	wire write_enab, write_enc, mac_reset;
	wire [9:0] addr_a, addr_b;
	wire [8:0] addr_c;
	wire [7:0] a_out, b_out;
	wire [19:0] c_out;
	wire [1:0] col, row, item;
	wire [319:0] matrixC;
	wire [19:0] c_datain;
	
	

	

	initial begin
		clk=0;
		forever begin
			#10
			clk = ~clk;
			
		end
	end
	
	
	MatrixMultFour fourx(
		.clock(clk), .start(rst), 
		.A(matrixA), .B(matrixB), 
		//output
		.curr_st(c_state), .nxt_st(n_state),
		.wrenab(write_enab),  .wrenc(write_enc),  .mac_rst(mac_reset),
		.addra(addr_a), .addrb(addr_b), .addrc(addr_c),
		.outa(a_out), .outb(b_out), .outc(c_out),
		.cols(col), .rows(row), .items(item),
		.cdatain(c_datain),
		
		.matrix_C(matrixC)
	);
	
	
	
	
	
	initial begin
		for(i=0; i<10000; i = i+1) begin
			#5
			if(i==3) begin
				matrixA[7:0] = 8'd0;
				matrixA[15:8] = 8'd1;
				matrixA[23:16] = 8'd2;
				matrixA[31:24] = 8'd3;
				matrixA[39:32] = 8'd4;
				matrixA[47:40] = 8'd5;
				matrixA[55:48] = 8'd6;
				matrixA[63:56] = 8'd7;
				matrixA[71:64] = 8'd8;
				matrixA[79:72] = 8'd9;
				matrixA[87:80] = 8'd10;
				matrixA[95:88] = 8'd11;
				matrixA[103:96] = 8'd12;
				matrixA[111:104] = 8'd13;
				matrixA[119:112] = 8'd14;
				matrixA[127:120] = 8'd15;
				
				matrixB[7:0] = 8'd10;
				matrixB[15:8] = 8'd11;
				matrixB[23:16] = 8'd12;
				matrixB[31:24] = 8'd13;
				matrixB[39:32] = 8'd14;
				matrixB[47:40] = 8'd15;
				matrixB[55:48] = 8'd16;
				matrixB[63:56] = 8'd17;
				matrixB[71:64] = 8'd18;
				matrixB[79:72] = 8'd19;
				matrixB[87:80] = 8'd20;
				matrixB[95:88] = 8'd21;
				matrixB[103:96] = 8'd22;
				matrixB[111:104] = 8'd23;
				matrixB[119:112] = 8'd24;
				matrixB[127:120] = 8'd25;
				
			end
			
			if(i==10) begin
				rst = 1'b0;
			end
			if(i==20) begin
				rst = 1'b1;
			end
				
		end
			
		
	end
	
	
	
endmodule