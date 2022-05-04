module mac (instruction, multiplier, multiplicand, stall, clk, reset_n, result, protect);
	input signed [15:0] multiplier;
	input signed [15:0] multiplicand; 
	input  clk;
	input  reset_n;
	input  stall;
	input  [2:0] instruction;
	output signed [31:0] result;
	output signed [7:0] protect;

//Add you design here
	reg signed [31:0] result;
	reg signed [7:0] protect;
	reg signed [15:0] mt_er16;
	reg signed [15:0] mt_cand16;
	reg signed [39:0] mt_temp40;
	reg signed [7:0] mt_er8_pre; //mt_er16[7:0]
	reg signed [7:0] mt_cand8_pre; //mt_cand16[7:0]
	reg signed [7:0] mt_er8_last; //mt_er16[15:8]
	reg signed [7:0] mt_cand8_last; //mt_cand16[15:8]
	reg signed [19:0] mt_temp20_pre; //mt_temp40[19:0]
	reg signed [19:0] mt_temp20_last; //mt_temp40[39:20]
	reg [2:0] prev_inst;
	parameter signed [39:0] max40 = 40'h007FFFFFFF;
	parameter signed [39:0] min40 = 40'hFF80000000;
	parameter signed [19:0] max20 = 20'h07FFF;
	parameter signed [19:0] min20 = 20'hF8000;

	//always @(posedge clk or posedge reset_n) begin			
	always @(posedge clk) begin	
		if(~reset_n) begin
			mt_temp40 <= 0;
			mt_temp20_pre <= 0;
			mt_temp20_last <= 0;
			result <= 0;
			protect <= 0;
		end
		else if(!stall) begin
				case(prev_inst)
					0: begin
						if(instruction == 0 || instruction == 1 || instruction == 2 || instruction == 3) begin
							mt_temp40 <= mt_er16 * mt_cand16;
							//result <= $unsigned(mt_temp40[31:0]);
							result <= mt_temp40[31:0];
							protect <= mt_temp40[39:32];
						end //if
						else if(instruction == 4 || instruction == 5 || instruction == 6 || instruction == 7) begin
							
							mt_temp20_pre <=  mt_er8_pre * mt_cand8_pre;
							result[15:0] <= mt_temp20_pre[15:0];
							protect[3:0] <= mt_temp20_pre[19:16];
							
							mt_temp20_last <=  mt_er8_last * mt_cand8_last;		
							result[31:16] <= mt_temp20_last[15:0];
							protect[7:4] <= mt_temp20_last[19:16];
						end //else if
						else begin
							/*mt_temp40 <= mt_er16 * mt_cand16;
							result <= mt_temp40[31:0];
							protect <= mt_temp40[39:32];*/
							
							mt_temp20_pre <=  mt_er8_pre * mt_cand8_pre;
							result[15:0] <= mt_temp20_pre[15:0];
							protect[3:0] <= mt_temp20_pre[19:16];
							
							mt_temp20_last <=  mt_er8_last * mt_cand8_last;		
							result[31:16] <= mt_temp20_last[15:0];
							protect[7:4] <= mt_temp20_last[19:16];
						end //else
					end //0
					
					4: begin

					end //4
					
					1: begin
						mt_temp40 <= mt_er16 * mt_cand16;
						result <= mt_temp40[31:0];
						protect <= mt_temp40[39:32];
					end //1
					
					2: begin
						mt_temp40 <=  mt_temp40 + mt_er16 * mt_cand16;
						result <= mt_temp40[31:0];
						protect <= mt_temp40[39:32];
					end //2
					
					3: begin
						if(mt_temp40 > max40) begin
							mt_temp40 <= {mt_temp40[39:32],32'h7FFFFFFF};						
							end
						else if(mt_temp40 < min40) begin
							mt_temp40 <= {mt_temp40[39:32],32'h80000000};								
							end
						result <= mt_temp40[31:0];		
						protect <= mt_temp40[39:32];
						
					end //3
					
					5: begin
						mt_temp20_pre <=  mt_er8_pre * mt_cand8_pre;
						result[15:0] <= mt_temp20_pre[15:0];
						protect[3:0] <= mt_temp20_pre[19:16];
						
						mt_temp20_last <=  mt_er8_last * mt_cand8_last;		
						result[31:16] <= mt_temp20_last[15:0];
						protect[7:4] <= mt_temp20_last[19:16];		
					end //5
					
					6: begin		
						mt_temp20_pre <= mt_temp20_pre + mt_er8_pre * mt_cand8_pre;
						result[15:0] <= mt_temp20_pre[15:0];
						protect[3:0] <= mt_temp20_pre[19:16];
						
						mt_temp20_last <=  mt_temp20_last + mt_er8_last * mt_cand8_last;		
						result[31:16] <= mt_temp20_last[15:0];
						protect[7:4] <= mt_temp20_last[19:16];						
					end //6
					
					7: begin
						
						if(mt_temp20_pre > max20) 
							mt_temp20_pre <= {mt_temp20_pre[19:16],16'h7FFF};
						else if(mt_temp20_pre < min20) 
							mt_temp20_pre <= {mt_temp20_pre[19:16],16'h8000};

						if(mt_temp20_last > max20) 
							mt_temp20_last <= {mt_temp20_last[19:16], 16'h7FFF};
						else if(mt_temp20_last < min20) 
							mt_temp20_last <= {mt_temp20_last[19:16], 16'h8000};
							
						result[15:0] <= mt_temp20_pre[15:0];
						protect[3:0] <= mt_temp20_pre[19:16];
							
						result[31:16] <= mt_temp20_last[15:0];
						protect[7:4] <= mt_temp20_last[19:16];	
					end //7
						
				endcase
		end //else if
	
	end //always

	
	//always @(posedge clk or negedge reset_n) begin
	always @(posedge clk) begin
		if(~reset_n) begin
			mt_er16 <= 0;
			mt_cand16 <= 0;
			//mt_temp40 <= 0;
			mt_er8_pre <= 0;
			mt_cand8_pre <= 0;
			//mt_temp20_pre <= 0;
			mt_er8_last <= 0;
			mt_cand8_last <= 0;
			//mt_temp20_last <= 0;
		end //if
		else if(!stall) begin	
		
			case(instruction)
				0: begin
					mt_er16 <= 0;
					mt_cand16 <= 0;
					mt_er8_pre <= 0;
					mt_cand8_pre <= 0;
					mt_er8_last <= 0;
					mt_cand8_last <= 0;
					prev_inst <= instruction;
				end //0
				
				4: begin
					mt_er16 <= 0;
					mt_cand16 <= 0;
					mt_er8_pre <= 0;
					mt_cand8_pre <= 0;
					mt_er8_last <= 0;
					mt_cand8_last <= 0;
					prev_inst <= instruction;
				end //4
				
				1: begin
					mt_er16 <= multiplier;
					mt_cand16 <= multiplicand;
					prev_inst <= instruction;
				end //1
				
				2: begin
					mt_er16 <= multiplier;
					mt_cand16 <= multiplicand;
					prev_inst <= instruction;
				end //2
				
				3: begin
					prev_inst <= instruction;
				end //3
				
				5: begin
					mt_er8_pre <= multiplier[7:0];
					mt_cand8_pre <= multiplicand[7:0];
					
									
					mt_er8_last <= multiplier[15:8];
					mt_cand8_last <= multiplicand[15:8];		
					prev_inst <= instruction;					
				end //5
				

				6: begin
					mt_er8_pre <= multiplier[7:0];
					mt_cand8_pre <= multiplicand[7:0];
					
									
					mt_er8_last <= multiplier[15:8];
					mt_cand8_last <= multiplicand[15:8];
					prev_inst <= instruction;
				end //6
				
				7: begin
					prev_inst <= instruction;
				end //7
					
			endcase
			
			//prev_inst <= instruction;
		end // else if

	end //always
endmodule
