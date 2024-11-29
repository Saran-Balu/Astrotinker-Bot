// Used to feed the level shifter with appropriate direction of rotation using the current position of the bot

module motor_control(
reverse_en,
clk,cpu_done,
reset,
forward_en,right_en,left_en,
left1,
center1,
right1,
prev_forward_en,prev_right_en,prev_left_en,prev_reverse_en,present_node,past_node,future_node,
a,b,c,d,
off,jreset,green_en,node_update,Y
);

input cpu_done;
input[4:0] present_node,past_node,future_node;
input forward_en,right_en,left_en,reverse_en;
input prev_forward_en,prev_right_en,prev_left_en,prev_reverse_en;
output reg green_en;//
input clk;
reg bot_start;
input reset;
integer stopcount;
integer stop_at_19=0;

integer stop_at_4=0,stop_at_5=0;
integer reverse_count=0;
output reg node_update;
output reg jreset;
input [11:0] left1;
input [11:0] right1;
input [11:0] center1;
reg stage;
reg stop_reverse=0;
integer node_count;
output reg off;
reg [4:0] count,count1,count2,count3,count4;
wire u1,u2,u3;
assign u1=left1>1200?1:0;
assign u2=center1>1200?1:0;
assign u3=right1>1200?1:0;
reg pwm6_25,pwm12_5,pwm25,pwm50,pwm75;
wire [2:0] sensor;
assign sensor={u1,u2,u3};
output a,b,c,d;
reg a=0;reg b=0; reg c=0;reg d=0;
reg [2:0] y;
output reg [2:0] Y;
parameter forward = 0,
			 left = 1,
			 right = 2,
			 stop = 3,
			 junction= 4,
			 idle=5;
initial begin
green_en=0;
bot_start=0;
stage=0;
stop_at_19=1;
stop_at_4=0;
Y=5;
y=5;
stopcount=0;
count=0;
count1=0;
count2=0;
count3=0;
jreset=0;

end


always @(posedge clk)begin//
	
/*
Purpose:
---
Used to define the state of the robot usig the LFA tester readings 
*/

	
		stopcount=stopcount+1;

		case(y)
		 idle:begin
			if (cpu_done==1) begin
				jreset=0;
					casex(sensor)
					3'b010:begin Y = forward;end
					3'b100:begin Y = left;end
					3'b110: begin Y = left;end
					3'b001: begin Y = right;end
					3'b011:begin Y = right;end
					endcase
					end
			else Y=idle;
			end
			forward:begin
			if(past_node==7 && present_node==6 && future_node==4)stop_at_19=stop_at_19+1;
			if(past_node==20 && present_node==19 && future_node==18)stop_at_19=stop_at_19+1;
			if(past_node==13 && present_node==12 && future_node==13)stop_at_19=stop_at_19+1;
			if(past_node==18 && present_node==19 && future_node==18)stop_at_19=stop_at_19+1;
			if(past_node==8 && present_node==12 && future_node==13)stop_at_19=stop_at_19+1;
			if(past_node==26 && present_node==25 && future_node==24)stop_at_19=stop_at_19+1;
					if(past_node==6 && present_node==4 && future_node==5)stop_at_4=stop_at_4+1;
					else if(past_node==2 && present_node==8 && future_node==9)stop_at_4=stop_at_4+1;
					else if(past_node==9 && present_node==8 && future_node==2)stop_at_4=stop_at_4+1;
					else stop_at_4=0;
			stop_reverse=0;
			reverse_count=0;
			node_update=0;
			stopcount=0;
			off=1;
			jreset=0;
			
				casex(sensor)
					3'b000: Y = stop;
					3'b100: Y = left;
					3'b110: Y = left;
					3'b001: Y = right;
					3'b011: Y = right;
					3'b111:begin Y=junction;
								node_update=1;
							
							end
				
					default: Y = forward;
				endcase
				end
			stop:begin
			if(past_node==7 && present_node==6 && future_node==4)stop_at_19=stop_at_19+1;
			if(past_node==20&& present_node==19 && future_node==18)stop_at_19=stop_at_19+1;
			if(past_node==4 && present_node==5 && future_node==4)stop_at_19=stop_at_19+1;
			if(past_node==26 && present_node==27 && future_node==26)stop_at_19=stop_at_19+1;
			if(past_node==16 && present_node==17 && future_node==16)stop_at_19=stop_at_19+1;
			if(past_node==14 && present_node==15 && future_node== 14)stop_at_19=stop_at_19+1;
			if(past_node==13 && present_node==12 && future_node==13)stop_at_19=stop_at_19+1;
			if(past_node==18 && present_node==19 && future_node==18)stop_at_19=stop_at_19+1;
			if(past_node==8 && present_node==12 && future_node==13)stop_at_19=stop_at_19+1;
			if(past_node==21 && present_node==22 && future_node==21)stop_at_19=stop_at_19+1;
		 	if(past_node==21 && present_node==23 && future_node==21)stop_at_19=stop_at_19+1;
				if(past_node==9 && present_node==10 && future_node==9)stop_at_19=stop_at_19+1;
			if(past_node==9 && present_node==11 && future_node==9)stop_at_19=stop_at_19+1;
			
				if(past_node==26 && present_node==25 && future_node==24)stop_at_19=stop_at_19+1;
			//if(past_node==2 && present_node==8 && future_node==9)stop_at_19=stop_at_19+1;
					if(past_node==6 && present_node==4 && future_node==5)stop_at_4=stop_at_4+1;
					else if(past_node==2 && present_node==8 && future_node==9)stop_at_4=stop_at_4+1;
					
					else stop_at_4=0;
			off=0;
			node_update=0;
			
			
			jreset=0;
			node_update=0;
			if(reverse_en==1 && stop_reverse==0) begin
				reverse_count=reverse_count+1;
			end
			if(reverse_count>0 && reverse_count<3125000) begin
			Y=stop;
			
			end
			else begin
			stop_reverse=1;
				//reverse_count=0;
			casex(sensor)
					3'b010: begin Y = forward; end
					3'b100: begin Y = left; end
					3'b110: begin Y = left; end
					3'b001: begin Y = right; end
					3'b011: begin Y = right; end
					3'b111: begin Y=junction;
								node_update=1;
					
							end
					
					default: Y = stop;
				endcase
			
				
				
			end
					
				
				end

			left:begin
			if(past_node==20 && present_node==19 && future_node==18)stop_at_19=stop_at_19+1;
			if(past_node==8 && present_node==12 && future_node==13)stop_at_19=stop_at_19+1;
			if(past_node==13 && present_node==12 && future_node==13)stop_at_19=stop_at_19+1;
			if(past_node==7 && present_node==6 && future_node==4)stop_at_19=stop_at_19+1;
			if(past_node==18 && present_node==19 && future_node==18)stop_at_19=stop_at_19+1;
				if(past_node==26 && present_node==25 && future_node==24)stop_at_19=stop_at_19+1;
				if(past_node==6 && present_node==4 && future_node==5)stop_at_4=stop_at_4+1;
				else if(past_node==2 && present_node==8 && future_node==9)stop_at_4=stop_at_4+1;
					else stop_at_4=0;
			node_update=0;
			
			stopcount=0;
			jreset=0;
			off=1;
				casex(sensor)
					3'b000: Y = stop;
					3'b010: Y = forward;
					3'b001: Y = right;
					3'b011: Y = right;
					3'b111: begin Y=junction;
							
								node_update=1;
					
							end
					default: Y = left;
				endcase
				end

			right:begin
			if(past_node==20 && present_node==19 && future_node==18)stop_at_19=stop_at_19+1;
			if(past_node==8 && present_node==12 && future_node==13)stop_at_19=stop_at_19+1;
			if(past_node==13 && present_node==12 && future_node==13)stop_at_19=stop_at_19+1;
				if(past_node==18 && present_node==19 && future_node==18)stop_at_19=stop_at_19+1;
			if(past_node==7 && present_node==6 && future_node==4)stop_at_19=stop_at_19+1;
					//if(past_node==6 && present_node==4 && future_node==5)stop_at_19=stop_at_19+1;
				if(past_node==6 && present_node==4 && future_node==5)stop_at_4=stop_at_4+1;
				else if(past_node==2 && present_node==8 && future_node==9)stop_at_4=stop_at_4+1;
					else stop_at_4=0;
			node_update=0;
			
			
			stopcount=0;
			jreset=0;
			off=1;
				casex(sensor)
					3'b000: Y = stop;
					3'b010: Y = forward;
					3'b110: Y = left;
					3'b100: Y = left;
					3'b111: begin Y=junction;
							node_update=1;
								
					
							end
					default: Y = right;
				endcase
				end

			junction:begin
			stop_at_19=0;
			if(past_node==6 && present_node==4 && future_node==5)stop_at_4=stop_at_4+1;
			else if(past_node==2 && present_node==8 && future_node==9)stop_at_4=stop_at_4+1;
			else if(past_node==28 && present_node==26 && future_node==27)stop_at_4=stop_at_4+1;
			else if(past_node==18 && present_node==16 && future_node==17)stop_at_4=stop_at_4+1;
			else if(past_node==16 && present_node==14 && future_node==15)stop_at_4=stop_at_4+1;
			else if(past_node==19 && present_node==20 && future_node==21)stop_at_4=stop_at_4+1;
			else if(past_node==9 && present_node==8 && future_node==2)stop_at_4=stop_at_4+1;
			else if(past_node==25 && present_node==26 && future_node==27)stop_at_4=stop_at_4+1;
			else if(past_node==3 && present_node==4 && future_node==5)stop_at_4=stop_at_4+1;
					else if(past_node==14 && present_node==16 && future_node==17)stop_at_4=stop_at_4+1;
					else if(past_node==13 && present_node==14 && future_node==15)stop_at_4=stop_at_4+1;
			else if(past_node==12 && present_node==8 && future_node==9)stop_at_4=stop_at_4+1;
				else if(past_node==29 && present_node==20 && future_node==21)stop_at_4=stop_at_4+1;
				else if(past_node==21 && present_node==20 && future_node==29)stop_at_4=stop_at_4+1;
				else if(past_node==24 && present_node==20 && future_node==29)stop_at_4=stop_at_4+1;
				else if(past_node==24 && present_node==20 && future_node==19)stop_at_4=stop_at_4+1;
				else if(past_node==21 && present_node==20 && future_node==19)stop_at_4=stop_at_4+1;
			else if(past_node==9 && present_node==8 && future_node==12)stop_at_4=stop_at_4+1;
					else stop_at_4=0;
			node_update=0;
			off=0;
			stopcount=0;
			jreset=1;
		
		
		if(past_node==9 && present_node== 8 && future_node==2)begin
			if(stop_at_4 < 3125000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
	else if(past_node==19 && present_node== 20 && future_node==21)begin
			if(stop_at_4 < 3125000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
	else if(past_node==21 && present_node== 20 && future_node==29)begin
			if(stop_at_4 < 3125000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
	else if(past_node==21 && present_node== 20 && future_node==19)begin
			if(stop_at_4 < 3125000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
	else if(past_node==24 && present_node== 20 && future_node==29)begin
	
		casex(sensor)
		
			3'b110:Y=left;
			3'b100:Y=left;
			default:Y=junction;
		
		
		
		
		
		endcase
	
	
	
	
	
	
	end
	else if(past_node==24 && present_node== 20 && future_node==19)begin
	
		casex(sensor)
		
			3'b011:Y=right;
			3'b001:Y=right;
			default:Y=junction;
		
		
		
		
		
		endcase
	
	
	
	
	
	
	end
	/*else if(past_node==24 && present_node== 20 && future_node==29)begin
			if(stop_at_4 < 2600000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end*/
		/*else if(past_node==24 && present_node== 20 && future_node==19)begin
			if(stop_at_4 < 2600000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
					
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end*/
			else if(past_node==29 && present_node== 20 && future_node==21)begin
			if(stop_at_4 < 3125000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
				else if(past_node==12 && present_node== 8 && future_node==9)begin
			if(stop_at_4 < 3125000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
	else if(past_node==9 && present_node== 8 && future_node==12)begin
			if(stop_at_4 < 3125000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
	else if(past_node==2 && present_node== 8 && future_node==9)begin
			if(stop_at_4 < 3125000)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
		else if(past_node==6 && present_node== 4 && future_node==5)begin
			if(stop_at_4 < 1406250)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
		else if(past_node==28 && present_node== 26 && future_node==27)begin
			if(stop_at_4 < 1406250)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
		else if(past_node==18 && present_node== 16 && future_node==17)begin
			if(stop_at_4 < 937500)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
		else if(past_node==16 && present_node== 14 && future_node==15)begin
			if(stop_at_4 < 1406250)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
		else if(past_node==25 && present_node== 26 && future_node==27)begin
			if(stop_at_4 < 1406250)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
		else if(past_node==3 && present_node== 4 && future_node==5)begin
			if(stop_at_4 < 1406250)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
		else if(past_node==14 && present_node== 16 && future_node==17)begin
			if(stop_at_4 < 1406250)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
		else if(past_node==13 && present_node== 14 && future_node==15)begin
			if(stop_at_4 < 1406250)begin
				Y=junction;
			
			end
			
			
			else begin
				casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			
			end

		end
	
	
		else if(past_node==29 && present_node==28)begin
		
		
			if(reverse_en==1 && stop_reverse==0) begin
				reverse_count=reverse_count+1;
			end
			if(reverse_count>0 && reverse_count<3125000) begin
			Y=junction;
			
			end
			else begin	
			stop_reverse=1;
					casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			end
		end
		
	

			else if(past_node==19 && present_node==18)begin
		
		
			if(reverse_en==1 && stop_reverse==0) begin
				reverse_count=reverse_count+1;
			end
			if(reverse_count>0 && reverse_count<3125000) begin
			Y=junction;
			
			end
			else begin	
			stop_reverse=1;
					casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			end
			end
		
			else if(past_node==18 && present_node==19)begin
		
		
			if(reverse_en==1 && stop_reverse==0) begin
				reverse_count=reverse_count+1;
			end
			if(reverse_count>0 && reverse_count<3125000) begin
			Y=junction;
			
			end
			else begin	
			stop_reverse=1;
					casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			end
			end
			else if(past_node==12 && present_node==13)begin
		
		
			if(reverse_en==1 && stop_reverse==0) begin
				reverse_count=reverse_count+1;
			end
			if(reverse_count>0 && reverse_count<3125000) begin
			Y=junction;
			
			end
			else begin	
			stop_reverse=1;
					casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			end
			
			
			//if(right_en==1 || reverse_en==1)begin
			
			
		end
		else if(past_node==24 && present_node==25)begin
		
		
			if(reverse_en==1 && stop_reverse==0) begin
				reverse_count=reverse_count+1;
			end
			if(reverse_count>0 && reverse_count<3125000) begin
			Y=junction;
			
			end
			else begin	
			stop_reverse=1;
					casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			end
		end
		else if(past_node==2 && present_node==3)begin
		
		
			if(reverse_en==1 && stop_reverse==0) begin
				reverse_count=reverse_count+1;
			end
			if(reverse_count>0 && reverse_count<3125000) begin
			Y=junction;
			
			end
			else begin	
			stop_reverse=1;
					casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
				endcase
			end
		end
		else if(past_node==7 && present_node==6)begin
		
		
			if(reverse_en==1 && stop_reverse==0) begin
				reverse_count=reverse_count+1;
			end
			if(reverse_count>0 && reverse_count<3125000) begin
			Y=junction;
			
			end
			else begin	
			stop_reverse=1;
					casex(sensor)
						
						
					/*	3'b001:begin
						Y = right;
						node_update=1;
						end
						3'b011:begin
						Y = right;
						node_update=1;
						end*/
						//default: Y = junction;
						//endcase
					//end
				//else if(forward_en==1)begin
					//casex(sensor)
						3'b000:begin  Y = stop;end
						
						3'b010:begin
						Y = forward;end
						
						default: Y = junction;
						
						
				
			
			
					endcase
			end
		end
		else begin	
				casex(sensor)
					
					
				/*	3'b001:begin
					Y = right;
					node_update=1;
					end
					3'b011:begin
					Y = right;
					node_update=1;
					end*/
					//default: Y = junction;
					//endcase
				//end
			//else if(forward_en==1)begin
				//casex(sensor)
					3'b000:begin  Y = stop;end
					
					3'b010:begin
					Y = forward;
					
					
					end
					default: Y=junction;
					
				/*3'b100:begin
					Y=left;
					node_update=1;
					end
					3'b110:begin
					Y=left;
					node_update=1;
					end */
					//default: Y = junction;
					//endcase
				//end
			//else if(left_en==1)begin
				//casex(sensor)
					
					
				/*	3'b100:begin
					Y = left;
					node_update=1;
					end
					
					3'b110:begin
					Y = left;
					node_update=1;
					end */
					//endcase
				//end
				
					
				endcase	
			end
		end
			
		endcase
			y=Y;
	end	
		
		always@(posedge clk) begin
		/*
Purpose:
---
Used to generate a PWM signal using a 4 bit counter
*/

		count=count+1;
		if(count<=6)begin
		pwm6_25=1;
		end
		else begin
		pwm6_25=0;
		end
		end
		always@(posedge clk) begin
		count1=count1+1;
		if(count1<=2)begin
		pwm12_5=1;
		end
		else begin
		pwm12_5=0;
		end
		end
		always@(posedge clk) begin
		count2=count2+1;
		if(count2<=7)begin
		pwm25=1;
		end
		else begin
		pwm25=0;
		end
		end
		always@(posedge clk) begin
		count3=count3+1;
		if(count3<=12)begin
		pwm50=1;
		end
		else begin
		pwm50=0;
		end
		end
		always@(posedge clk) begin
		count4=count4+1;
		if(count4<=14)begin
		pwm75=1;
		end
		else begin
		pwm75=0;
		end
		end

		always @(posedge clk) begin
		/*
Purpose:
---
Used to define the motor signal corresponding to the state of the bot
*/

			
				 
				case(Y) 
					idle:
					begin
						a=0;b=0;c=0;d=0;
					end
					forward:
					begin
					
					if(past_node==28 && present_node==29 && future_node==20)begin
						a=pwm50;
						b=0;
						c=pwm50;
						d=0;
					
					end
					else if( present_node==20 && future_node==21)begin
						a=pwm6_25;
						b=0;
						c=pwm6_25;
						d=0;
						end
					else if( present_node==21 && future_node==22)begin
						a=pwm6_25;
						b=0;
						c=pwm6_25;
						d=0;
						end
					
					
					
					else if(present_node==21 && future_node==23)begin
						a=pwm6_25;
						b=0;
						c=pwm6_25;
						d=0;
					
					
					end
					/*else if(past_node==0 && present_node==0 && future_node==1)begin
						a=pwm25;
						b=0;
						c=pwm25;
						d=0;
					
					
					end*/
					
					
					else if(present_node==8 && future_node==9)begin
									a=pwm6_25;
									b=0;
									c=pwm6_25;
									d=0;
								
					end
					else if(present_node==9 && future_node==10)begin
									a=pwm6_25;
									b=0;
									c=pwm6_25;
									d=0;
								
					end
					else if(present_node==9 && future_node==11)begin
									a=pwm6_25;
									b=0;
									c=pwm6_25;
									d=0;
								
					end
					else begin
						a=pwm50;
						b=0;
						c=pwm50;
						d=0;
					end
						end
					left:
						begin
						
						a=0;
						b=pwm50 ;
						c=pwm50;
						d=0;
						end
					right:
					
						begin
						
						a=pwm50;
						b=0;
						c=0;
						d=0;
						end
					junction:
						begin
						//stop_at_19=0;
							if(reverse_en==1)begin
								if(past_node==19 && present_node==18)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
							else	if(past_node==12 && present_node==13)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
							else	if(past_node==18 && present_node==19)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
							else	if(past_node==2 && present_node==3)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
							
							else	if(past_node==7 && present_node==6)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
								

							else	if(past_node==29 && present_node==28)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
							end

								else	if(past_node==24 && present_node==25)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
									
								else begin
								a=pwm50;
								b=0;
								c=pwm50;
								d=0;
								
								end
							
							end
							
							else if(forward_en==1)begin
								if(past_node==2 && present_node==8 && future_node==9)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=pwm50;
								b=0;
								c=0;
								d=pwm50;
									
									
									end
								
								
								end
						else if(past_node==24 && present_node==20 && future_node==19)begin
									/*if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=pwm50;
								b=0;
								c=0;
								d=pwm50;
									
									
									end*/
													a=pwm50;
								b=0;
								c=0;
								d=0;
								
								
								end
						else	if(past_node==24 && present_node==20 && future_node==29)begin
									/*if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=0;
								b=pwm50;
								c=pwm50;
								d=0;
									
									
									end*/
								a=0;
								b=0;
								c=pwm50;
								d=0;
								
								
								end
						else if(past_node==19 && present_node==20 && future_node==21)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=pwm50;
								b=0;
								c=0;
								d=pwm50;
									
									
									end
								
								
								end
						else if(past_node==21 && present_node==20 && future_node==29)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=pwm50;
								b=0;
								c=0;
								d=pwm50;
									
									
									end
								
								
								end
							else if(past_node==9 && present_node==8 && future_node==12)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=pwm50;
								b=0;
								c=0;
								d=pwm50;
									
									
									end
								
								
								end
								else if(past_node==9 && present_node==8 && future_node==2)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
																	
											a=0;
								b=pwm50;
								c=pwm50;
								d=0;
									
									
									
									end
								
								
								end
							else if(past_node==21 && present_node==20 && future_node==19)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
																	
											a=0;
								b=pwm50;
								c=pwm50;
								d=0;
									
									
									
									end
								
								
								end
						
								else if(past_node==12 && present_node==8 && future_node==9)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
																	
											a=0;
								b=pwm50;
								c=pwm50;
								d=0;
									
									
									
									end
								
								
								end
							else if(past_node==29 && present_node==20 && future_node==21)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
																	
											a=0;
								b=pwm50;
								c=pwm50;
								d=0;
									
									
									
									end
								
								
								end
								else begin
								a=pwm50;
								b=0;
								c=pwm50;
								d=0;
								end
							
							end
							else if(left_en==1)begin
							

							if(past_node==6 && present_node==4 && future_node==5)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=0;
								b=pwm50;
								c=pwm50;
								d=0;
									
									
									end
								
								
								end
						else if(past_node==28 && present_node==26 && future_node==27)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=0;
								b=pwm50;
								c=pwm50;
								d=0;
									
									
									end
								
								
								end
								
					else	if(past_node==16 && present_node==14 && future_node==15)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=0;
								b=pwm50;
								c=pwm50;
								d=0;
									
									
									end
								
								
								end
						
			else if(past_node==18 && present_node==16 && future_node==17)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
											a=0;
								b=pwm50;
								c=pwm50;
								d=0;
									
									
									end
								
								
								end
							else begin	
								a=0;
								b=pwm50;
								c=pwm50;
								d=0;
							end
							end
							else if(right_en==1)begin
								
								
								if(past_node==25 && present_node==26 && future_node==27)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
										a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
									end
								
								
								end
								
								else if(past_node==3 && present_node==4 && future_node==5)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
										a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
									end
								
								
								end
						
							else if(past_node==14 && present_node==16 && future_node==17)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
										a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
									end
								
								
								end
						
								else if(past_node==13 && present_node==14 && future_node==15)begin
									if(stop_at_4 < 468750)begin
									
										a=pwm50;
										b=0;
										c=pwm50;
										d=0;
									
									end
									
									else begin
									
										a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
									end
								
								
								end
								else begin
								
								
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								
							end
					end
					stop:
						begin
						
							if(reverse_en==1)begin
								if(past_node==6 && present_node==7)begin
																		a=0;
									b=pwm50;
									c=pwm50;
									d=0;
								
								end
							else if(past_node==18 && present_node==19 && future_node==18)begin
								
									
									if(stop_at_19 < 5000000)begin
									
										a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									end
									else begin
									a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
									
									
									
									end

										

									end
							else if(past_node==13 && present_node==12 && future_node==13)begin
								
									
									if(stop_at_19<5000000)begin
									//stop_at_19=stop_at_19+1;
										a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end
							else if(past_node==4 && present_node==5 && future_node==4)begin
								
									
									if(stop_at_19<625000)begin
									//stop_at_19=stop_at_19+1;
										a=pwm50;										
									b=0;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end
							else if(past_node==26 && present_node==27 && future_node==26)begin
								
									
									if(stop_at_19<625000)begin
									//stop_at_19=stop_at_19+1;
										a=pwm50;										
									b=0;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end	
							else if(past_node==14 && present_node==15 && future_node==14)begin
								
									
									if(stop_at_19<625000)begin
									//stop_at_19=stop_at_19+1;
										a=pwm50;										
									b=0;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end	
				else if(past_node==9 && present_node==10 && future_node==9)begin
								
									
									if(stop_at_19<625000)begin
									//stop_at_19=stop_at_19+1;
										a=pwm50;										
									b=0;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end
			else if(past_node==9 && present_node==11 && future_node==9)begin
								
									
									if(stop_at_19<625000)begin
									//stop_at_19=stop_at_19+1;
										a=pwm50;										
									b=0;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end
	else if(past_node==21 && present_node==22 && future_node==21)begin
								
									
									if(stop_at_19<625000)begin
									//stop_at_19=stop_at_19+1;
										a=pwm50;										
									b=0;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end
	else if(past_node==21 && present_node==23 && future_node==21)begin
								
									
									if(stop_at_19<625000)begin
									//stop_at_19=stop_at_19+1;
										a=pwm50;										
									b=0;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end
					else if(past_node==16 && present_node==17 && future_node==16)begin
								
									
									if(stop_at_19<625000)begin
									//stop_at_19=stop_at_19+1;
										a=pwm50;										
									b=0;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end	
								else begin
									a=pwm25;
									b=0;
									c=0;
									d=pwm75;
								end
									
							end
							
							
							else if(forward_en==1)begin
								if(past_node==22 && present_node==21&&future_node==20)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
							else if(past_node==20 && present_node==19 && future_node==18)begin
								
									
									if(stop_at_19 < 5000000)begin
									
										a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									end
									else begin
									a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
									
									
									
									end

										

									end
								else if(past_node==9 && present_node==8 &&future_node==2)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end

								else if(past_node==4 && present_node==6 &&future_node==7)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
								else if(past_node==29 && present_node==1 &&future_node==2)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
							else if(past_node==21 && present_node==20 &&future_node==19)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
								else if(past_node==12 && present_node==8 &&future_node==9)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
							else if(past_node==24 && present_node==20 &&future_node==29)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
							else if(past_node==29 && present_node==20 &&future_node==21)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
							else	if(past_node==19 && present_node==20 &&future_node==21 )begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
							else	if(past_node==9 && present_node==8 &&future_node==12 )begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
								else	if(past_node==21 && present_node==20 &&future_node==29 )begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
							else	if(past_node==2 && present_node==8 &&future_node==9 )begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
								else	if(past_node==24 && present_node==20 &&future_node==19 )begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
									
								end
								
								
								else if(past_node==21&& present_node==20&&future_node==24)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
								else if(past_node==2&& present_node==1&&future_node==29)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
								else if(past_node==26 && present_node==25 && future_node==24)begin
								
									
									if(stop_at_19<5000000)begin
									
										a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									end
									else begin
									a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
									
									
									
									end
							
							end
							
								else if(past_node==7 && present_node==6 && future_node==4)begin
								
									
									if(stop_at_19<5000000)begin
									
										a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									end
									else begin
									a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
									
									
									
									end
							
							end
							else if(past_node==2 && present_node==3 && future_node==4)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
							else if(past_node==3 && present_node==4 && future_node==6)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
							else if(past_node==19 && present_node==20 && future_node==29)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end	
							else if(past_node==12 && present_node==13 && future_node==14)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
							end
							else if(past_node==8 && present_node==2 && future_node==3)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
							
								else if(past_node==0 && present_node==1 && future_node==29)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
						else if(past_node==20 && present_node==24 && future_node==25)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
						else if(past_node==24 && present_node==25 && future_node==26)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								else if(past_node==1 && present_node==29 && future_node==28)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								else if(past_node==28 && present_node==29 && future_node==20)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								else if(past_node==17 && present_node==16 && future_node==18)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								else if(past_node==26 && present_node==28 && future_node==29)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								else if(past_node==27 && present_node==26 && future_node==28)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								else if(past_node==15 && present_node==14 && future_node==16)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								else if(past_node==16 && present_node==18 && future_node==19)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								else if(past_node==20 && present_node==29 && future_node==1)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
								else if(past_node==12 && present_node==8 && future_node==7)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								end
							else if(past_node== 18&& present_node==16 &&future_node==14)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
							else if(past_node== 3&& present_node==2 &&future_node==1)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
								else if(past_node== 6&& present_node==7 &&future_node==8)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
							else if(past_node== 16&& present_node==14 &&future_node==13)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
									
								end
								else if(past_node==23 && present_node==21&&future_node==20)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
								else if(past_node==20 && present_node==29 &&future_node==28)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
								
								else if(past_node==13 && present_node==12&&future_node==19)begin
									
						
													if(stopcount>0 && stopcount<=620800)begin
													a=0;
													b=pwm50;
													c=pwm50;
													d=0;
													end
													else begin
													a=pwm50;
													b=0;
													c=0;
													d=0;
													end
								end
								else if(past_node==18 && present_node==19&&future_node==12)begin
									
						
													if(stopcount>0 && stopcount<=620800)begin
													a=0;
													b=pwm50;
													c=pwm50;
													d=0;
													end
													else begin
													a=pwm50;
													b=0;
													c=0;
													d=0;
													end
								end
								else if(past_node==20 && present_node==19&&future_node==12)begin
									
						
													if(stopcount>0 && stopcount<=620800)begin
													a=0;
													b=pwm50;
													c=pwm50;
													d=0;
													end
													else begin
													a=pwm50;
													b=0;
													c=0;
													d=0;
													end
								end
									
								
								else if(past_node==4 && present_node==3&&future_node==2)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
								else if(past_node==14 && present_node==13&&future_node==12)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
								else if(past_node==1 && present_node==29&&future_node==20)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
								else if(past_node==29 && present_node==20&&future_node==19)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
								else if(past_node==20 && present_node==29 &&future_node==28)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
									
								end
								
								else if(past_node==20 && present_node==21 && future_node==22)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
								
								end
								else if(past_node==2 && present_node==8 && future_node==7)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
								
								end
								else if(past_node==8 && present_node==7 && future_node==6)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
								
								end
								
								else if(past_node==20 && present_node==21 && future_node==23)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
								else if(past_node==1 && present_node==2 && future_node==8)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
								else if(past_node==8 && present_node==9 && future_node==10)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
								else if(past_node==11 && present_node==9 && future_node==8)begin
									a=pwm50;
									b=0;
									c=0;
									d=pwm50;
								
								end
								else if(past_node==8 && present_node==9 && future_node==11)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
								
								end
								else if(past_node==10 && present_node==9 && future_node==8)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
								
								end
								else if(past_node==19 && present_node==18 && future_node==16)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
								
								end
								else if(past_node==14 && present_node==13 && future_node==12)begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
								
								end
								else begin
									a=0;
									b=pwm50;
									c=pwm50;
									d=0;
								
								end
							
							end
							else if(left_en==1)begin
								
								if(past_node==8 && present_node==12 && future_node==13)begin
								
									
									if(stop_at_19<5000000)begin
									//stop_at_19=stop_at_19+1;
										a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
									
									end
									else begin
									a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									
									
									
									end

										

									end
					else if(past_node==18 && present_node==19 && future_node==20)begin
							
							
							a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
							
							end
							else if(past_node==29 && present_node==20 && future_node==21)begin
							
							
							a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
							
							end
							else if(past_node==9 && present_node==8 && future_node==2)begin
							
							
							a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
							
							end
							else if(past_node==6 && present_node==4 && future_node==5)begin
							
							
							a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
							
							end
								else if(past_node==28 && present_node==26 && future_node==27)begin
							
							
							a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
							
							end
							else if(past_node==18 && present_node==16 && future_node==17)begin
							
							
							a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
							
							end
								else if(past_node==16 && present_node==14 && future_node==15)begin
							
							
							a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
							
							end

								
							
							
							else begin	
								a=pwm50;
								b=0;
								c=0;
								d=pwm50;
							end
							end
							else if(right_en==1)begin
								

								if(past_node==20 && present_node==19 && future_node==18)begin
								
									
									if(stop_at_19 < 5000000)begin
									
										a=pwm50;
										b=0;
										c=0;
										d=pwm50;
									
									end
									else begin
									a=0;										
									b=pwm50;
									c=pwm50;
									d=0;
									
									
									
									end

										

									end
								else	if(past_node==2 && present_node==8 && future_node==12)begin
								a = pwm50;
								b = 0;
								c = 0;
								d = pwm50;
								end
							else	if(past_node==25 && present_node==26 && future_node==27)begin
								a = pwm50;
								b = 0;
								c = 0;
								d = pwm50;
							end
						else	if(past_node==3 && present_node==4 && future_node==5)begin
								a = pwm50;
								b = 0;
								c = 0;
								d = pwm50;
							end
						else	if(past_node==14 && present_node==16 && future_node==17)begin
								a = pwm50;
								b = 0;
								c = 0;
								d = pwm50;
							end
					else	if(past_node==13 && present_node==14 && future_node==15)begin
								a = pwm50;
								b = 0;
								c = 0;
								d = pwm50;
							end
								
							else	if(past_node==21 && present_node==20 && future_node==29)begin
								a = pwm50;
								b = 0;
								c = 0;
								d = pwm50;
								end
								
							else	if(past_node==2 && present_node==8 && future_node==9)begin
								a = pwm50;
								b = 0;
								c = 0;
								d = pwm50;
								end								
							
							else	if(past_node==13 && present_node==12 && future_node==8)begin
								a = pwm50;
								b = 0;
								c = 0;
								d = pwm50;
								end	
							
							
							else begin
							a=0;
							b=pwm50;
							c=pwm50;
							d=0;
							end
							end
					end
						
						
				endcase
				
		end
		






endmodule