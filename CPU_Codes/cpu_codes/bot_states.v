
/* This module is to monitor the current state of the bot,there are totally three states identify fault,pick block and block drop
module bot_states(clk,en,unit_msg,pbm_complete,unit_pulse,su,present_node,EP,delatch,cpu_en,i_fault,p_block,b_drop,unitlist,send_msg_fim,send_msg_bpm,send_msg_bdm,unitlist0,unitlist1,unitlist2,unitlist3,stop,msg_count,future_node,b,ru_red,cu_red,eu_red,ru_blue,cu_blue,eu_blue,ru_green,cu_green,eu_green);
input clk,en,unit_msg,pbm_complete;
input[1:0] unit_pulse;
input [4:0] future_node;
output [4:0] b;
output ru_red,cu_red,eu_red,ru_blue,cu_blue,eu_blue,ru_green,cu_green,eu_green;
reg ru_red=0,cu_red=0,eu_red=0,ru_blue=0,cu_blue=0,eu_blue=0,ru_green=0,cu_green=0,eu_green=0;
reg [4:0] b=0;
input [2:0] su;
input[4:0] present_node;
input [2:0] msg_count;
output [3:0] stop;
reg [3:0] stop=10;
output [4:0] EP;
output delatch,send_msg_fim,send_msg_bpm;
output [2:0] send_msg_bdm;
reg delatch=0;
reg[4:0] EP=0;
reg [4:0] a=0;
integer count_eu=0,count_cu=0,count_ru=0;
output[1:0] unitlist;
integer led_count=0;

output cpu_en,i_fault,p_block,b_drop;
reg[4:0] fault_at_eu=0;reg[4:0] fault_at_cu=0;reg[4:0] fault_at_ru=0;
reg cpu_en=0;reg i_fault=0; reg p_block=0;reg b_drop=0;reg block_detect=0;
integer count=0;integer detect_count=0; integer new_detect_count=0; 
reg[1:0] unit_list[0:5]; output[1:0] unitlist0,unitlist1,unitlist2,unitlist3;integer block_drop_count=0;
parameter IDENTIFY_FAULT=2'b00,PICK_BLOCK=2'b01,BLOCK_DROP=2'b10;reg[5:0] pbm_count=0;reg pbm_count_flag=0;
reg[1:0] present_state=0;reg[1:0] next_state=0;reg send_msg_fim=0;reg send_msg_bpm=0;reg[2:0] send_msg_bdm=0;
reg start=0;integer i=0;reg flag=1;integer idx=0;integer k=0;integer l=0;reg su_complete=0;reg[2:0]prev_s_unit=4;reg[2:0]s_unit=4;reg[2:0] prev_u_pulse=0;reg[2:0] u_pulse=0;reg unit_complete=0;
reg [4:0] fault1=0,fault2=0,fault3=0,fault_count=0;reg allowed=0; reg allowed_reverse=0;
initial begin
	l=0;
	k=0;
	i=0;
	/*unit_list[0]=3;
	unit_list[1]=3;
	unit_list[2]=3;
	unit_list[3]=3;
	unit_list[4]=3;
	unit_list[5]=3;*/
end

always@(negedge en)begin
/*
Purpose:
	used to detect faults using ultrasonic and deposit the block only where fault is detected
*/
	if(i_fault==1 && present_node!=fault1 && present_node!=fault2 && present_node!=fault3 && allowed==1|| b_drop==1 && a==present_node && allowed==1)begin
		detect_count=detect_count+1;
		block_detect=0;
	end
	if(i_fault==1 && allowed_reverse==1 && present_node!=fault1 && present_node!=fault2 && present_node!=fault3 || b_drop==1 && a==present_node && allowed_reverse==1  )begin
		new_detect_count=new_detect_count+1;
		block_detect=0;
	
	end
	
	if(p_block==1 &&(present_node==21 || present_node==9))begin
		block_detect=1;
	end
end
/*always@(posedge unit_msg)begin
start=1;
unit_list[idx]=unit_pulse;idx=idx+1; 
/*if (unit_list[0]==3) begin
		unit_list[0]<=unit_pulse;
		k<=k+1;
		l<=l+1;
	end
	else if (unit_list[1]==3 && unit_list[0]!=unit_pulse) begin
		unit_list[1]<=unit_pulse;
		l<=l+1; 
	end
	else if (unit_list[2]==3 && unit_list[1]!=unit_pulse && unit_list[0]!=unit_pulse) begin
		unit_list[2]<=unit_pulse;
	end
	else if (unit_list[0]==unit_pulse) begin
		//unit_list[1:3]=unit_list[0:2];
		unit_list[1]<=unit_list[0];
		unit_list[2]<=unit_list[1];
		unit_list[3]<=unit_list[2];
		unit_list[0]<=unit_pulse;
		k<=k+1;
		l<=l+1;
	end
	else if (unit_list[k]==unit_pulse) begin
		unit_list[k+1]<=unit_list[k];
		unit_list[k+2]<=unit_list[k+1];
		unit_list[k+3]<=unit_list[k+2];
		//unit_list[k+1:3]=unit_list[k:2];
		unit_list[k]<=unit_pulse;
		l<=l+1;
	end
	else if (unit_list[l]==unit_pulse) begin
		unit_list[l+1]<=unit_list[l];
		unit_list[l+2]<=unit_list[l+1];
		unit_list[l+3]<=unit_list[l+2];
		
		unit_list[l]<=unit_pulse;
		end*/
		/*unit_list[l+1:3]=unit_list[l:2];
		unit_list[l]=unit_pulse;
	end
end*/
always@(posedge clk)begin
/*
Purpose:
	Has different state of the bots as fsms and the approprtiate triggering for going to next state.
	
*/
if(i==idx && start==1)begin
	led_count=led_count+1;
		if(led_count==3125000)begin
			eu_green=~eu_green;ru_green=~ru_green;cu_green=~cu_green;
			led_count=0;
		
		end

	end
allowed=(future_node==28&& present_node==29) ||(future_node==24&& present_node==25) ||(future_node==6&& present_node==7) ||(future_node==2&& present_node==3)||(future_node==18&& present_node==19)||(future_node==12&& present_node==13) ;
			allowed_reverse=(future_node==27 && present_node==26) || (future_node==4&& present_node==5)||(future_node==16&& present_node==17)||(future_node==15&& present_node==14);
	prev_u_pulse=u_pulse;
	u_pulse=msg_count;
	if(prev_u_pulse!=u_pulse)unit_complete=1;
	else unit_complete=0;
	
	if(unit_complete==1)begin unit_list[idx]=unit_pulse;idx=idx+1; start=1;
		if (unit_pulse==0) begin count_eu=count_eu+1;if(count_eu==1)eu_red=1; end
		else if (unit_pulse==1) begin  count_cu=count_cu+1;if(count_cu==1)cu_red=1; end
		else if (unit_pulse==2) begin count_ru=count_ru+1;if(count_ru==1)ru_red=1; end
		
	end//idx=idx+1;start=1;//end
	
	//if(idx==4)start=1;
	
	prev_s_unit=s_unit;
	s_unit=su;
	if(prev_s_unit!=s_unit)su_complete=1;
	else su_complete=0;
	//if(unit_msg==1)begin	start=1;unit_list[idx]=unit_pulse;idx=idx+1; end
	if(cpu_en==1)begin
					count=count+1;
					if(count==3)begin
						cpu_en=0;
						count=0;
					end
				end
	if(start==0)begin ru_red=0;cu_red=0;eu_red=0;ru_blue=0;cu_blue=0;eu_blue=0;ru_green=0;cu_green=0;eu_green=0; end
	if(start==1)begin
		case(present_state)
			IDENTIFY_FAULT:begin
			//fim=0;bpm=0;bdm=0;
			send_msg_fim=0;send_msg_bpm=0;send_msg_bdm=0;
			delatch=0;
			i_fault=1;
			p_block=0;
			b_drop=0;
			a=present_node;
			b=future_node;
			
			if((detect_count % 4)==2 || (new_detect_count % 3)==1)begin 
				if (fault_count==0) fault1=present_node;
				if (fault_count==1) fault2=present_node;
				if (fault_count==2) fault3=present_node;
				fault_count=fault_count+1;
				//eu_red=unit_list[i]==0?0:1;cu_red=unit_list[i]==1?0:1;ru_red=unit_list[i]==2?0:1;
				if(unit_list[i]==0)begin eu_red=0;eu_green=0;eu_blue=1; end
				else if(unit_list[i]==1)begin cu_red=0;cu_green=0;cu_blue=1; end
				else if(unit_list[i]==2)begin ru_red=0;ru_green=0;ru_blue=1; end
				//eu_green=unit_list[i]==0?0:1;cu_green=unit_list[i]==1?0:1;ru_green=unit_list[i]==2?0:1;
				//eu_blue=unit_list[i]==0?1:0;cu_blue=unit_list[i]==1?1:0;ru_blue=unit_list[i]==2?1:0;
				next_state=PICK_BLOCK;
				stop=10;
				send_msg_fim=1;
				//fim=1;bpm=0;bdm=0;
						
				flag=1;
			end
			else	begin next_state=IDENTIFY_FAULT;
				
				
				case(unit_list[i])
					2'b00:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=29;
							flag=0;
						end	
					end
					2'b01:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=8;
							flag=0;
						end
					end
					2'b10:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=19;
							flag=0;
						end
					end
				
				endcase
				/*if (count_eu!=0)begin 
						if(flag==1)begin
							cpu_en=1;
							EP=29;
							flag=0;
						end	
					end
				else if (count_eu==0 && count_cu!=0)begin 
						if(flag==1)begin
							cpu_en=1;
							EP=8;
							flag=0;
						end
					end
				else if (count_eu==0 && count_cu==0 && count_ru!=0) begin 
						if(flag==1)begin
							cpu_en=1;
							EP=19;
							flag=0;
						end
					end*/
				
				
			end
			
			end
			PICK_BLOCK:begin
			//fim=0;bpm=0;bdm=0;
			send_msg_fim=0;send_msg_bpm=0;send_msg_bdm=0;
			//send_msg=0;
			delatch=0;
			i_fault=0;
			p_block=1;
			b_drop=0;
			if(present_node==21 || present_node==9)begin
					block_drop_count=block_drop_count+1;
					
				end
				if(block_drop_count==3125000)begin
					block_drop_count=0;
					next_state=BLOCK_DROP;
						stop=11;
						
					flag=1;
					send_msg_bpm=1;
				
				
				end
				else begin next_state=PICK_BLOCK;
				if(su_complete==1)begin
					
					case(su)
					2'b00:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=22;
							flag=0;
						end	
					end
					2'b01:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=10;
							flag=0;
						end
					end
					2'b10:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=23;
							flag=0;
						end
					end
					2'b11:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=11;
							flag=0;
						end
					end
					
					endcase
				
			end
		end
				 
			end 
			BLOCK_DROP:begin
			i_fault=0;
			//send_msg=0;
			send_msg_fim=0;send_msg_bpm=0;send_msg_bdm=0;
			//fim=0;bpm=0;bdm=0;
			p_block=0;
			b_drop=1;
			
				if((detect_count % 4)==0 && (allowed == 1) && b==future_node|| (new_detect_count % 3)==0 && (allowed_reverse == 1)&&b==future_node)begin 
				stop=13;
				next_state=IDENTIFY_FAULT; 
					
				//fim=0;bpm=0;bdm=1;
				if(su==0)send_msg_bdm=1;
				else if(su==1)send_msg_bdm=2;
				else if(su==2)send_msg_bdm=3;
				else if(su==3)send_msg_bdm=4;
				if(unit_list[i]==0)begin eu_red=0;eu_green=1;eu_blue=0; end
				else if(unit_list[i]==1)begin cu_red=0;cu_green=1;cu_blue=0; end
				else if(unit_list[i]==2)begin ru_red=0;ru_green=1;ru_blue=0; end
				delatch=1;
				flag=1;
				i=i+1;
				if(i==idx)begin eu_green=1;ru_green=1;cu_green=1;   end
				/*if (count_eu!=0) count_eu=count_eu-1;
				else if (count_eu==0 && count_cu!=0) count_cu=count_cu-1;
				else if (count_eu==0 && count_cu==0 && count_ru!=0) count_ru=count_ru-1;*/
				
				end
			else begin next_state=BLOCK_DROP;
				
				
				case(unit_list[i])
					2'b00:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=b;
							flag=0;
						end	
					end
					2'b01:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=b;
							flag=0;
						end
					end
					2'b10:begin 
						if(flag==1)begin
							cpu_en=1;
							EP=b;
							flag=0;
						end
					end
				
				endcase
				/*if (count_eu!=0)begin 
						if(flag==1)begin
							cpu_en=1;
							EP=29;
							flag=0;
						end	
					end
				else if (count_eu==0 && count_cu!=0)begin 
						if(flag==1)begin
							cpu_en=1;
							EP=8;
							flag=0;
						end
					end
				else if (count_eu==0 && count_cu==0 && count_ru!=0) begin 
						if(flag==1)begin
							cpu_en=1;
							EP=19;
							flag=0;
						end
					end
					
					
				end
			end*/
		end 
		end
		endcase
		
		present_state=next_state;
	end



end
assign unitlist=unit_list[i];
assign unitlist0=unit_list[0];
assign unitlist1=unit_list[1];
assign unitlist2=unit_list[2];
assign unitlist3=unit_list[3];





endmodule