module HexDisplay(
	input [3:0] binary_in, 
	output [6:0] h0
);
		
		reg [6:0] display = 7'd0;
		assign h0 = display;

//0 = on
	always @(*) begin
		case (binary_in) 
			4'd000: display = 7'b1000000;
			4'd001: display = 7'b1111001;
			4'd002: display = 7'b0100100;
			4'd003: display = 7'b0110000;
			4'd004: display = 7'b0011001;
			4'd005: display = 7'b0010010;
			4'd006: display = 7'b1111101;
			4'd007: display = 7'b1111000;
			4'd008: display = 7'b00;
			4'd009: display = 7'd0011000;
			4'd010: display = 7'd0001000;
			4'd011: display = 7'd0000011;
			4'd012: display = 7'd0111001;
			4'd013: display = 7'd0100001;
			4'd014: display = 7'd0000110;
			4'd015: display = 7'd0001110;
		endcase
	end


endmodule
