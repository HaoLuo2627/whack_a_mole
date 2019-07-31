module keyboard_scan(clk,rst,row_b,col,row_location,col_location);	//键盘扫描
input clk,rst;						//clk接系统时钟
input [3:0] row_b;					//键盘按键按下是0
output reg [3:0] col;
output reg [2:0] row_location,col_location;
wire [3:0] row;
reg [2:0] state;
reg [1:0] cnt;
wire clk_500k;
assign row=row_b;	
time_divider #(100,6) td_500k(clk,rst,clk_500k);

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
		col<=4'b0000;               //四列按键的按下情况都可以感知
		row_location<=3'b100;       //没有检测到有效的按下状态，行列坐标指向一个无效的位置(4,4)
		col_location<=3'b100;
		if(row!=4'b1111)            //一旦有按键按下，开始逐行检测，通过状态机对整个扫描过程进行控制
		begin
			col<=4'b1110;            //检测第一行的按键情况
			state<=1;
		end
		else state<=0;
	end
	1:
	begin
		if(row!=4'b1111) state<=5;//如果是这一行的按键被按下，转到状态5，确定行列坐标
		else begin
			col<=4'b1101;            //没有按下，开始扫描第二行
			state<=2;
		end
	end
	2:
	begin
		if(row!=4'b1111) state<=5;
		else begin
			col<=4'b1011;
			state<=3;
		end
	end
	3:
	begin
		if(row!=4'b1111) state<=5;
		else begin
			col<=4'b0111;
			state<=4;
		end
	end
	4:
	begin
		if(row!=4'b1111) state<=5;
		else state<=0;
	end
	5:
	begin
		if(row!=4'b1111)
		begin
			if(row[0]==0) row_location<=3'b000;     //第0行的按键被按下，行坐标row_location赋值成0
			else if(row[1]==0) row_location<=3'b001;
			else if(row[2]==0) row_location<=3'b010;
			else row_location<=3'b011;
			if(col[0]==0) col_location<=3'b000;
			else if(col[1]==0) col_location<=3'b001;
			else if(col[2]==0) col_location<=3'b010;//第2列的按键被按下，列坐标col_location赋值成2
			else col_location<=3'b011;
			state<=5;
		end
		else state<=0;
	end
	endcase
	end
end


endmodule
