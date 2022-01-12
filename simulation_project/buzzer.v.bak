module buzzer(clk_fa,clk_50,clk_half,hit,rst,beep);//蜂鸣器控制模块
	input clk_fa,clk_50,clk_half,hit,rst;
	output beep;
	reg en,hit_tmp,flag;
	always@(posedge clk_half or posedge hit) 	//储存hit状态直到新地鼠产生
	begin
		if(hit) hit_tmp=1;
		else hit_tmp=0;
	end
	always@(posedge clk_50 or posedge rst)
	begin
		if(rst)
		begin
			flag=1;                             //flag=1允许改变en的值
			en=0;
		end
		else if((hit==1)&&(flag==1)==1)			//打中地鼠之后执行一次
		begin
			en=1;                               //允许蜂鸣器发声
			flag=0;
		end
		else begin
			if(hit_tmp==0) flag=1;		      //新地鼠产生(hit_tmp=0)后flag=1，可以在再打中地鼠时响
			else flag=flag;            //否则flag保持0
			if(hit==0) en=0;          //按键松开(hit=0)后en=0，并且由于flag在新地鼠产生之前不变，en不能置1
			else en=en;              //按键不松开，蜂鸣器可以继续发出按键音
		end
	end

	assign beep=en?clk_fa:0;
endmodule
