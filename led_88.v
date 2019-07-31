module led_88(clk,clk_half,rst,hit,row,col_r,col_g,state,rowran,colran);	//点阵扫描模块，使用500Hz频率扫描
input clk,clk_half,rst,hit;
input [2:0] rowran,colran;
output reg [7:0] row,col_r,col_g;
input [1:0] state;
reg [2:0] cnt;
reg hit_tmp;
reg [3:0] col_4;

always @(colran)               //列随机数转换成对应的地鼠显示情况
begin
	case(colran)
	3'b010: col_4=4'b0001;      //colran=2，第二列显示地鼠，以此类推
	3'b011: col_4=4'b0010;
	3'b100: col_4=4'b0100;
	3'b101: col_4=4'b1000;
	default: col_4=4'b0000;
	endcase
end
always@(posedge clk_half or posedge hit)  //保持下一组随机数到来时对当前地鼠的击打状态不变
begin
 if(hit)
 begin
  hit_tmp=1;      //异步时序，保证controller传来的hit一旦为1（代表地鼠被打中）,hit_tmp立刻变为1，将这种打中状态保持到新地鼠产生为止
 end
 else hit_tmp=0;                //0.5Hz时钟上升沿到来，新地鼠产生，默认hit_tmp=0
end
always@(posedge clk)	         //500Hz频率逐行扫描点阵，cnt=0~7代表依次使第0行到第7行可以显示
begin
	if(rst)	cnt<=0;
	else if(cnt==3'b111) cnt<=0;
	else	cnt<=cnt+1;
end
always @(cnt or state or col_4 or rowran or hit_tmp)   
//控制显示不同的图案，初始状态显示游戏边界，游戏状态显示边界和地鼠，游戏成功状态显示绿色笑脸，失败状态显示红色哭脸
begin
	case(cnt)		//依次选择各行
	3'b000:begin
		row=8'b1111_1110;
		if(state!=2'b10) col_g=8'h00;
		else col_g=8'b0001_1000;
		col_r=8'h00;
	end
	3'b001:begin
		row=8'b1111_1101;
		if(state==2'b00||state==2'b01) col_g=8'b0111_1110;
		else if(state==2'b10) col_g=8'b0010_0100;
		else col_g=8'h00;
		if(state!=2'b11) col_r=8'h00;
		else col_r=8'b0100_0010;
	end
	3'b010:begin
		row=8'b1111_1011;
		if(state!=2'b11) col_g=8'b0100_0010;
		else col_g=8'h00;
		if(state==2'b01) begin
			if(cnt==rowran&&!hit_tmp) begin
				col_r={2'b00,col_4,2'b00};	
			end
			else col_r=8'h00;
		end
		else if(state==2'b11) col_r=8'b0011_1100;
		else col_r=8'h00;
	end
	3'b011:begin
		row=8'b1111_0111;
		if(state==2'b00||state==2'b01) col_g=8'b0100_0010;
		else col_g=8'h00;
		if(state==2'b01) begin
			if(cnt==rowran&&!hit_tmp) begin
				col_r={2'b00,col_4,2'b00};
			end
			else col_r=8'h00;
		end
		else col_r=8'h00;
	end
	3'b100:begin
		row=8'b1110_1111;
		if(state==2'b00||state==2'b01) col_g=8'b0100_0010;
		else col_g=8'h00;
		if(state==2'b01) begin
			if(cnt==rowran&&!hit_tmp) begin
				col_r={2'b00,col_4,2'b00};
			end
			else col_r=8'h00;
		end
		else col_r=8'h00;
	end
	3'b101:begin
		row=8'b1101_1111;
		if(state==2'b00||state==2'b01) col_g=8'b0100_0010;
		else if(state==2'b10) col_g=8'b1010_0101;
		else col_g=8'h00;
		if(state==2'b01) begin
			if(cnt==rowran&&!hit_tmp) begin
				col_r={2'b00,col_4,2'b00};
			end
			else col_r=8'h00;
		end
		else if(state==2'b11) col_r=8'b0100_0010;
		else col_r=8'h00;
	end
	3'b110:begin
		row=8'b1011_1111;
		if(state==2'b00||state==2'b01) col_g=8'b0111_1110;
		else if(state==2'b10) col_g=8'b0100_0010;
		else col_g=8'h00;
		if(state!=2'b11) col_r=8'h00;
		else col_r=8'b1010_0101;
	end
	3'b111:begin
		row=8'b0111_1111;
		col_g=8'h00;
		col_r=8'h00;
	end
endcase
end

endmodule
