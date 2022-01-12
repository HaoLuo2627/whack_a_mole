module controller(rowran,colran,row,col,time_shi,time_ge,clk,clk_50,clk_half,rst,hit,state,score_shi,score_ge);   //控制模块
input [2:0] rowran,colran,row,col;              //输入getrandom模块产生的随机数和keyboard_scan模块扫描的行列坐标值
input clk,clk_50,clk_half,rst;						//输入时钟和复位
input [3:0] time_shi,time_ge;                    //输入计时时间值
output reg hit;                                  //击打状态输出
output [1:0] state;                              //输出fsm的状态输出
output reg [3:0] score_shi,score_ge;             //分数输出
reg Ts,Tt;
reg flag;
reg hit_tmp;

fsm central_fsm(clk,rst,state,Ts,Tt);          //例化有限状态机，完成对整个电路状态的控制

always@(posedge clk_50 or posedge rst)
begin
	if(rst) begin
		hit=0;
	end
	else if(state==2'b01)                   //游戏状态
	begin
		if((rowran==row+2)&&(colran==col+2))       //如果打中，hit修改为1
		begin
			hit=1;
		end
		else begin                      //否则hit保持0
			hit=0;
		end
	end
	else begin                          //其他情况hit=0
		hit=0;
	end
end

always @(posedge clk_half or posedge hit) //一旦打中，hit_tmp赋值1，并且把这种状态一直记忆到新地鼠产生(0.5Hz时钟有效边沿到来)
begin
 if(hit) hit_tmp=1;
 else hit_tmp=0;
end

always @(posedge clk_50 or posedge rst)
begin
	if(rst)                             //复位，分数置成00
	begin
	 flag=1;
	 score_shi=0;
	 score_ge=0;
	end
	else if((hit==1)&&(flag==1)==1)      //打中(hit=1)且flag=1时才会执行，防止多次打中分数累加的逻辑错误
	begin
		if(score_ge<9)
		begin
		 score_ge=score_ge+1;
		 score_shi=score_shi;
		end
		else begin
		 score_ge=0;
		 score_shi=score_shi+1;
		end
		flag=0;                     //分数修改后flag即置成0，防止多次累加
	end
	else begin
	 score_ge=score_ge;               //其他状态分数保持不变
	 score_shi=score_shi;
	 if(hit_tmp==0) flag=1;           //直到新地鼠出现后(hit重新置0，hit_tmp也同时置0)flag才会恢复1，可以在打中下一只地鼠时分数加1
	 else flag=flag;                  //新的地鼠不产生，flag保持不变，使总打一只时分数不能不停增加
	end
end

always @(score_shi or rst)
begin
	if(rst) Ts=0;
	else if(score_shi==1)                    //计到10分，Ts=1，其他时候Ts=0
	Ts=1;
	else Ts=0;
end
always @(time_shi or time_ge or rst)
begin
	if(rst) Tt=0;
	else if(time_shi==0&&time_ge==0)              //时间到Tt=1，否则Tt=0
	Tt=1;
	else Tt=0;
end
endmodule

module fsm(clk,rst,state,Ts,Tt);		//有限状态机
input clk,rst,Ts,Tt;
output [1:0] state;
reg [1:0] state,next_state;
parameter state0=2'b00,state1=2'b01,state2=2'b10,state3=2'b11;
//		  初始状态	游戏状态  游戏成功状态 游戏失败状态
always @(posedge clk or posedge rst)		//状态寄存器，时钟有效边沿一到来state就刷新一次，刷新成next_state的值
begin
	if(rst) state<=state0;                //如果复位信号有效，state置成初始状态
	else state<=next_state;
end

always @(state or Ts or Tt or rst)
begin
	case(state)
	state0:begin
	if(!rst) next_state<=state1;        //复位信号失效，转入游戏状态，下一状态是游戏状态
	else next_state<=state0;            //否则保持初始状态不动
	end
	state1:begin
	if(Ts) next_state<=state2;          //如果分数达到十分，转入游戏成功状态
	else if(Tt) next_state<=state3;  //分数不够的情况下时间到，转入游戏失败状态
	else next_state<=state1;            //否则下一状态仍是游戏状态
	end
	state2:begin
	if(rst) next_state<=state0;         //成功状态下，如果复位转入初始状态
	else next_state<=state2;            //否则保持当前状态
	end
	state3:begin
	if(rst) next_state<=state0;         //游戏失败状态下，如果复位转入初始状态
	else next_state<=state3;           //否则保持当前状态
	end
endcase
end

endmodule
