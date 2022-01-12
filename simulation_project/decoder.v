module decoder(num,seg_led);//译码器
input [3:0] num;
output [7:0] seg_led;
reg [7:0] seg [9:0];
initial                    //0~9对应的数码管译码输出
begin
	seg[0]=8'b11111100;		//A,B,C,D,E,F,G,DP
	seg[1]=8'b01100000;
	seg[2]=8'b11011010;
	seg[3]=8'b11110010;
	seg[4]=8'b01100110;
	seg[5]=8'b10110110;
	seg[6]=8'b10111110;
	seg[7]=8'b11100000;
	seg[8]=8'b11111110;
	seg[9]=8'b11110110;
end

assign seg_led=seg[num];
endmodule
