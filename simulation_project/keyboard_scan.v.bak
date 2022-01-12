module keyboard_scan(clk,rst,row_b,col,row_location,col_location);	//clk接系统时钟,键盘按键按下是0
input clk,rst;
input [3:0] row_b;
output reg [3:0] col;
output reg [2:0] row_location,col_location;
wire [3:0] row;
reg [2:0] state;
reg [1:0] cnt;
wire clk_500k;
assign row=row_b;		//used for simulation only
time_divider #(10,4) td(clk,rst,clk_500k);		//used for simulation only
//time_divider #(100,6) td_500k(clk,rst,clk_500k);
//debounce db0(clk,rst,row_b[0],row[0]);
//debounce db1(clk,rst,row_b[1],row[1]);
//debounce db2(clk,rst,row_b[2],row[2]);
//debounce db3(clk,rst,row_b[3],row[3]);
/*
//2.0
always@(posedge clk_500k or posedge rst)
begin
	if(rst) begin
		col<=4'b0000;
		state<=0;
		row_location<=3'b100;
		col_location<=3'b100;
	end
	else begin
	case(state)
	0:
	begin
		col<=4'b0000;
		if(row!=4'b0000)
		begin
			col<=4'b1110;
			state<=1;
		end
		else state<=0;
	end
	1:
	begin
		if(row!=4'b0000) state<=5;
		else begin
			col<=4'b1101;
			state<=2;
		end
	end
	2:
	begin
		if(row!=4'b0000) state<=5;
		else begin
			col<=4'b1011;
			state<=3;
		end
	end
	3:
	begin
		if(row!=4'b0000) state<=5;
		else begin
			col<=4'b0111;
			state<=4;
		end
	end
	4:
	begin
		if(row!=4'b0000) state<=5;
		else state<=0;
	end
	5:
	begin
		if(row!=4'b0000)
		begin
			if(row[0]==1) row_location<=3'b000;
			else if(row[1]==1) row_location<=3'b001;
			else if(row[2]==1) row_location<=3'b010;
			else row_location<=3'b011;
			if(col[0]==0) col_location<=3'b000;
			else if(col[1]==0) col_location<=3'b001;
			else if(col[2]==0) col_location<=3'b010;
			else col_location<=3'b011;
			state<=5;
		end
		else state<=0;
	end
	endcase
	end
end
*/

//1.0原创
always@(posedge clk_500k or posedge rst)
begin
	if(rst) cnt<=2'b00;
	else if(cnt==2'b11) cnt<=2'b00;
	else cnt<=cnt+1'b1;
end

always @(cnt or row)
begin
	case(cnt)
	2'b00:begin
		col<=4'b1110;
		if(row!=4'b1111) begin
			col_location<=3'b000;
		if(row[0]==0) 	row_location<=3'b000;
		else if(row[1]==0) row_location<=3'b001;
		else if(row[2]==0) row_location<=3'b010;
		else row_location<=3'b011;
		end
		else begin
		row_location<=3'b100;
		col_location<=3'b100;
		end
	end
	2'b01:begin
		col<=4'b1101;
		if(row!=4'b1111) begin
			col_location<=3'b001;
		if(row[0]==0) 	row_location<=3'b000;
		else if(row[1]==0) row_location<=3'b001;
		else if(row[2]==0) row_location<=3'b010;
		else row_location<=3'b011;
		end
		else begin
		row_location<=3'b100;
		col_location<=3'b100;
		end
	end
	2'b10:begin
		col<=4'b1011;
		if(row!=4'b1111) begin
			col_location<=3'b010;
		if(row[0]==0) 	row_location<=3'b000;
		else if(row[1]==0) row_location<=3'b001;
		else if(row[2]==0) row_location<=3'b010;
		else row_location<=3'b011;
		end
		else begin
		row_location<=3'b100;
		col_location<=3'b100;
		end
	end
	2'b11:begin
		col<=4'b0111;
		if(row!=4'b1111) begin
			col_location<=3'b011;
		if(row[0]==0)	row_location<=3'b000;
		else if(row[1]==0) row_location<=3'b001;
		else if(row[2]==0) row_location<=3'b010;
		else row_location<=3'b011;
		end
		else begin
		row_location<=3'b100;
		col_location<=3'b100;
		end
	end
	endcase
end


endmodule
