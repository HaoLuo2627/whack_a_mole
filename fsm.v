module fsm(clk,rst,state,Ts,Tt);		//有限状态机
input clk,rst,Ts,Tt;
output [1:0] state;
reg [1:0] state,next_state;
parameter state0=2'b00,state1=2'b01,state2=2'b10,state3=2'b11;
//					初始状态		游戏状态	游戏成功状态		游戏失败状态
always @(posedge clk or posedge rst)		//状态寄存器，时钟有效边沿一到来state就刷新一次，刷新成next_state的值
begin
	if(rst) state<=state0;                 //如果复位信号有效，state置成初始状态
	else state<=next_state;
end

always @(state or Ts or Tt or rst)     //描述次态逻辑
begin
	case(state)
	state0:begin
	if(!rst) next_state<=state1;        //复位信号失效，转入游戏状态，下一状态是游戏状态
	else next_state<=state0;            //否则保持初始状态不动
	end
	state1:begin
	if(Ts) next_state<=state2;          //如果分数达到十分，转入游戏成功状态
	else if(Tt) next_state<=state3;     //分数不够的情况下时间到，转入游戏失败状态
	else next_state<=state1;            //否则下一状态仍是游戏状态
	end
	state2:begin
	if(rst) next_state<=state0;         //成功状态下，如果复位转入初始状态
	else next_state<=state2;            //否则保持当前状态
	end
	state3:begin
	if(rst) next_state<=state0;         //游戏失败状态下，如果复位转入初始状态
	else next_state<=state3;            //否则下一状态仍是当前状态
	end
endcase
end

endmodule
