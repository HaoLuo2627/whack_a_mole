module whack_a_mole (clk,rst,matrow,matcol_r,matcol_g,
		row_b,col,seg_select,dig_select,beep);		//顶层模块
input clk,rst;          //系统50MHz时钟、复位
input [3:0] row_b;      //读取键盘输入
output [3:0] col;       //键盘列扫描控制
output [7:0] matrow,matcol_r,matcol_g;  //点阵显示输出
output reg [7:0] seg_select;   //数码管段选
output reg [7:0] dig_select;   //数码管位选
output beep;				//蜂鸣器输出

wire [2:0] colran,rowran;      //随机数模块getrandom输出的行随机数和列随机数
wire [2:0] row_location,col_location;  //keyboard_scan键盘扫描出按键的行列坐标
wire hit;                      //控制器controller输出的击打状态
wire [3:0] time_shi,time_ge;   //倒计时器timer输出的倒计时
wire [3:0]score_shi,score_ge;  //控制器输出的分数
wire [1:0] state;              //有限状态机fsm输出的状态
wire [7:0] seg_time_1,seg_time_0;		//倒计时十位、个位的译码结果
wire [7:0] seg_score_1,seg_score_0;    //分数十位、个位的译码结果

wire clk_1k,clk_500,clk_1,clk_half,clk_50,clk_la;
time_divider #(50000,15) td_1k(clk,rst,clk_1k);	//分频得1kHz时钟信号
time_divider #(2,2) td_500(clk_1k,rst,clk_500); //分频得500Hz时钟信号
time_divider #(10,4) td_50(clk_500,rst,clk_50); //分频得50Hz时钟信号
time_divider #(50,6) td_1(clk_50,rst,clk_1);  //分频得1Hz时钟信号
time_divider #(2,2) td_half(clk_1,rst,clk_half);//分频得0.5Hz时钟信号
time_divider #(56818,15) td_fa(clk,rst,clk_la);//中音6，880.00Hz
getrandom gr1(.clk(clk_half),.rst(rst),.ran1(rowran),.ran2(colran));		//生成随机数

keyboard_scan kb(.clk(clk),.rst(rst),.row_b(row_b),.col(col),
	.row_location(row_location),.col_location(col_location));				//键盘扫描
timer time_counter(.clk_1(clk_1),.state(state),.rst(rst),.time_shi(time_shi),.time_ge(time_ge));	//倒计时器
controller center_control(.rowran(rowran),.colran(colran),.row(row_location),.col(col_location),
	.time_shi(time_shi),.time_ge(time_ge),.clk(clk),.clk_50(clk_50),.clk_half(clk_half),.rst(rst),.hit(hit),
	.state(state),.score_shi(score_shi),.score_ge(score_ge));													//控制模块和状态机
led_88 ld(.clk(clk_500),.clk_half(clk_half),.rst(rst),.row(matrow),.col_g(matcol_g),.state(state),
				.col_r(matcol_r),.rowran(rowran),.colran(colran),.hit(hit));	//点阵显示

always@(posedge clk_1k or posedge rst)		//数码管位选，以1kHz频率扫描
begin
	if(rst)
	dig_select<=8'b1111_1110;
	else begin
	dig_select[3:0]<={dig_select[2:0],dig_select[3]};
	dig_select[7:4]=4'b1111;
	end
end
decoder deco_time_shi(time_shi,seg_time_1);     //对时间十位进行译码
decoder deco_time_ge(time_ge,seg_time_0);       //对时间个位进行译码
decoder deco_score_shi(score_shi,seg_score_1);  //对分数十位进行译码
decoder deco_score_ge(score_ge,seg_score_0);    //对分数个位进行译码

always @(dig_select[3:0] or seg_time_0 or seg_time_1 or seg_score_0 or seg_score_1)	      //位选:1110时间个位，1101时间十位，1011分数个位，0111分数十位
begin
	case(dig_select[3:0])
	4'b1110: seg_select=seg_time_0;
	4'b1101: seg_select=seg_time_1;
	4'b1011: seg_select=seg_score_0;
	4'b0111: seg_select=seg_score_1;
	default: seg_select=8'b0000_0000;
	endcase
end

buzzer bz(.clk_la(clk_la),.clk_50(clk_50),.clk_half(clk_half),.hit(hit),.rst(rst),.beep(beep));   //打中地鼠发声

endmodule
