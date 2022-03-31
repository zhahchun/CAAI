module traffic_light (
  input  clk,
  input  rst,
  input  pass,
  output reg R,
  output reg G,
  output reg Y
);
	reg [10:0] cnt = 0;
	reg [2:0] state = 0;
	
	/*reg R = 0;
	reg G = 0;
	reg Y = 0;*/
	
	always @(posedge clk) begin
		
		if(rst == 1 || (pass == 1 && state != 0))begin
			R <= 0;
			G <= 1;
			Y <= 0;
			cnt <= 1;
			state <= 0;
		end //if
		
		else begin
			case(state)
				0: begin // green 1024 cycles
					if(cnt == 1024)begin						
						cnt <= 1;
						state <= 1;		
						R <= 0;
						G <= 0;
						Y <= 0;
					end 					
					else begin
						R <= 0;
						G <= 1;
						Y <= 0;
						cnt <= cnt + 1;
					end	
				end 
				
				1: begin // None 128 cycles
					if(cnt == 128)begin						
						cnt <= 1;
						state <= 2;		
						R <= 0;
						G <= 1;
						Y <= 0;
					end 					
					else begin
						R <= 0;
						G <= 0;
						Y <= 0;
						cnt <= cnt + 1;
					end	
				end 
				
				2: begin // green 128 cycles
					if(cnt == 128)begin						
						cnt <= 1;
						state <= 3;		
						R <= 0;
						G <= 0;
						Y <= 0;
					end 					
					else begin
						R <= 0;
						G <= 1;
						Y <= 0;
						cnt <= cnt + 1;
					end	
				end 
				
				3: begin // None 128 cycles
					if(cnt == 128)begin						
						cnt <= 1;
						state <= 4;		
						R <= 0;
						G <= 1;
						Y <= 0;
					end 					
					else begin
						R <= 0;
						G <= 0;
						Y <= 0;
						cnt <= cnt + 1;
					end	
				end 
				
				4: begin // green 128 cycles
					if(cnt == 128)begin						
						cnt <= 1;
						state <= 5;		
						R <= 0;
						G <= 0;
						Y <= 1;
					end 					
					else begin
						R <= 0;
						G <= 1;
						Y <= 0;
						cnt <= cnt + 1;
					end	
				end 
				
				5: begin // yellow 512 cycles
					if(cnt == 512)begin						
						cnt <= 1;
						state <= 6;		
						R <= 1;
						G <= 0;
						Y <= 0;
					end 					
					else begin
						R <= 0;
						G <= 0;
						Y <= 1;
						cnt <= cnt + 1;
					end	
				end 
				
				6: begin // red 1024 cycles
					if(cnt == 1024)begin						
						cnt <= 1;
						state <= 0;		
						R <= 0;
						G <= 1;
						Y <= 0;
					end 					
					else begin
						R <= 1;
						G <= 0;
						Y <= 0;
						cnt <= cnt + 1;
					end	
				end 
			endcase
		end //else
	end //always

endmodule
