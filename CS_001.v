// `include "calc.v"
module CS(clk, reset, X, Y);

	input clk, reset; 
	input [7:0] X;
	output [9:0] Y;
	
	reg [9:0] X1,X2, X3, X4, X5, X6, X7, X8, X9;
	wire[9:0] avg_w;
	reg [9:0] avg = 0;
	reg [9:0] appr = 0;
	wire[9:0] Y_keep_w;
	reg [9:0] Y = 0;
	reg [12:0] avg_dividend = 0;
	reg [12:0] Y_dividend = 0;
	
	reg [12:0] total_num = 0;
	reg [9:0] least = 0;

	reg [12:0] avg_dis = 9;
	reg [12:0] Y_dis = 8;
	
	
	//當 clock 改變
	always @(negedge clk) begin
		if(reset) begin
		
			X1 <= 0; X2 <= 0; X3 <= 0; X4 <= 0; X5 <= 0; X6 <= 0; X7 <= 0; X8 <= 0; X9 <= 0;
			avg <= 0;
			appr <= 0;
			//Y_keep <= 0;
			avg_dividend <= 0;
			Y_dividend <= 0;
			//last_X <= 0;

			total_num <= 0;
			least <= 1000;
			
		end //if
		
		else begin// 輸入按順序放到9個reg裡
			total_num <= total_num + 1;

			X1 <= X2;
			X2 <= X3;
			X3 <= X4;
			X4 <= X5;
			X5 <= X6;
			X6 <= X7;
			X7 <= X8;
			X8 <= X9;
			X9 <= X;
			
			// 開始計算avg、appr及Y
			avg_dividend <= X2+X3+X4+X5+X6+X7+X8+X9+X; 	

		end //else
		
	end //always

	// 使用子 module取得 avg
	calc c1(avg_dividend, avg_dis, avg_w);
	
	always @(avg_dividend or avg_w) begin
		avg = avg_w;
		// 計算各個數距離平均 
		// 避免紀錄上一輪最小值
		least = 1000;
		 
		if( (avg >= X1) && (avg - X1) < least) begin
			appr = X1;
			least = avg - X1;
		end
		
		if(avg >= X2 && (avg - X2) < least) begin
			appr = X2;
			least = avg - X2;
		end
		
		if(avg >= X3 && (avg - X3) < least) begin
			appr = X3;
			least = avg - X3;
		end
		
		if(avg >= X4 && (avg - X4) < least) begin
			appr = X4;
			least = avg - X4;
		end
		
		if(avg >= X5 && (avg - X5) < least) begin
			appr = X5;
			least = avg - X5;
		end
		
		if(avg >= X6 && (avg - X6) < least) begin
			appr = X6;
			least = avg - X6;
		end
		
		if(avg >= X7 && (avg - X7) < least) begin
			appr = X7;
			least = avg - X7;
		end
		
		if(avg >= X8 && (avg - X8) < least) begin
			appr = X8;
			least = avg - X8;
		end
		
		if(avg >= X9 && (avg - X9) < least) begin
			appr = X9;
			least = avg - X9;
		end

		
		Y_dividend = avg_dividend + avg_dis*appr;
	end // always
	
	//使用子 module取得 Y_keep_w
	calc c2(Y_dividend, Y_dis, Y_keep_w);	
	
	always @(posedge clk) begin
		if (total_num >= 9)
			Y <= Y_keep_w;
	end//always

endmodule

//除法器
module  calc
	
    #(parameter width=13)  //input 8-bit, output 10-bit, divisor n= 9, n-1=8
	(dividend, divisor, merchant);
	
	input [width-1:0]       dividend;  // 被除
	input [width-1:0]       divisor;  // 除數
	output [width-1:0]      merchant;  //商
	
	reg [width-1:0]     	temp_dividend;  
	reg [width-1:0]      	temp_divisor;  
	reg [2*width-1:0]    	temp_did;
	reg [2*width-1:0]   	temp_dis;
	reg [width-1:0]      	merchant;  //商
	reg [width-1:0]      	remainder;  //餘數	
	reg [width-1:0] 		i = 0;
  
    always @(dividend or divisor) begin
		temp_dividend = dividend;
		temp_divisor = divisor;	
	end
	
    always @(temp_dividend or temp_divisor) begin
		temp_did = {{width{1'b0}}, temp_dividend};
		temp_dis = {temp_divisor, {width{1'b0}}};
		
		for(i = 0; i < width; i = i +1) begin
			temp_did = temp_did << 1;
			if(temp_did >= temp_dis) 
				temp_did = temp_did - temp_dis + 1'b1;
			else 
				temp_did = temp_did;
		end //for
		
		merchant = temp_did[width-1:0];
		remainder = temp_did[width*2-1: width];
	end // always	

endmodule