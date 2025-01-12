// Reciever module for hc-05.For decoding the message recieved from the sender(laptop)


module rx_test(clk,rx,unit_msg,unit_pulse,su,pbm_complete,msg_count);
input clk,rx;
output unit_msg;
output[2:0] msg_count;
reg[2:0] msg_count=0;
reg unit_msg=0;
output[1:0] unit_pulse;
output [2:0] su;
output pbm_complete;
reg[1:0]unit_pulse=3;reg[2:0] su=4;
reg pbm_complete=0;
reg[3:0] char_count_eu=0;reg[3:0] char_count_ru=0;reg[3:0] char_count_cu=0;reg[3:0] char_count_su1=0;
reg[3:0] char_count_su2=0;reg[3:0] char_count_su3=0;reg[3:0] char_count_su4=0;
parameter IDLE=0;
parameter START_BIT=1;
parameter DATA_BITS=2;
parameter STOP=3;
integer i,count;
reg flag;
reg[7:0] rx_msg,rx1;
reg[7:0] clock_count=0;
reg[1:0] state,next_state;
initial begin
state=0; next_state=0; i=0; count=0; rx_msg=0;rx1=0;
end
always@(posedge clk)begin
/*
Purpose:
---
used to define the corresponding nodes for manual travesal in each of the unit.
*/
	if(unit_msg==1)begin
		clock_count=clock_count+1;
		if(clock_count==16)begin
			unit_msg=0;
			clock_count=0;
		end
	
	end
	case(state)
		IDLE:begin count=0;i=0;flag=1; if(rx==0)begin next_state=START_BIT;  end
				else next_state=IDLE; end
		START_BIT:begin
					count=count+1;
					if(count>0 && count<=434)next_state=START_BIT;
					else next_state=DATA_BITS;
		
					end
		DATA_BITS:begin
					count=count+1;
					if(count>434 && count<=3906)begin
					next_state=DATA_BITS;
							if((count-200)%434==0)begin
							rx1[i]=rx;
							i=i+1;
							end
					end
					else next_state=STOP;
		
					end
		STOP:   begin
					count=count+1;
					if(count>3906 && count<=4340)begin
					next_state=STOP;
						if(rx==1 && flag==1)begin rx_msg=rx1;flag=0; end
						else rx_msg=0;
					end
					else next_state=IDLE;
		
		
					end


	endcase
	state=next_state;
	if(rx_msg=="#"||rx_msg=="I"||rx_msg=="F"||rx_msg=="M"||rx_msg=="E"||rx_msg=="U"|| rx_msg=="-")begin //IFM-EU-#
	char_count_eu=char_count_eu+1;
		
		if(char_count_eu==8) 
		begin 
			unit_msg=1;
			rx_msg=0;
			pbm_complete=0;
			char_count_cu=0;
			char_count_ru=0;
			char_count_eu=0;
			char_count_su1=0;
			char_count_su2=0;
			char_count_su3=0;
			char_count_su4=0;
			unit_pulse=0;
			msg_count=msg_count+1;
		end


	end
	if(rx_msg=="#"||rx_msg=="I"||rx_msg=="F"||rx_msg=="M"||rx_msg=="C"||rx_msg=="U"|| rx_msg=="-")begin //IFM-CU-#
	char_count_cu=char_count_cu+1;
	
		if(char_count_cu==8) 
		begin 
			unit_msg=1;
			rx_msg=0;
			pbm_complete=0;
			char_count_cu=0;
			char_count_eu=0;
			char_count_ru=0;
			char_count_su1=0;
			char_count_su2=0;
			char_count_su3=0;
			char_count_su4=0;
			unit_pulse=1;
			msg_count=msg_count+1;
		end


	end
		if(rx_msg=="#"||rx_msg=="I"||rx_msg=="F"||rx_msg=="M"||rx_msg=="R"||rx_msg=="U"|| rx_msg=="-")begin //IFM-RU-#
	char_count_ru=char_count_ru+1;

		if(char_count_ru==8) 
		begin 
			unit_msg=1;
			rx_msg=0;
			pbm_complete=0;
			char_count_cu=0;
			char_count_eu=0;
			char_count_ru=0;
			char_count_su1=0;
			char_count_su2=0;
			char_count_su3=0;
			char_count_su4=0;
			unit_pulse=2;
			msg_count=msg_count+1;
		end


	end
	if(rx_msg=="#"||rx_msg=="P"||rx_msg=="B"||rx_msg=="M"||rx_msg=="S"||rx_msg=="U"|| rx_msg=="-"|| rx_msg=="1")begin  //PBM-SU-B1-#.
	char_count_su1=char_count_su1+1;

		if(char_count_su1==11) 
		begin 
			unit_msg=0;
			
			su=0;
			rx_msg=0;
			char_count_su1=0;
			char_count_su2=0;
			char_count_su3=0;
			char_count_su4=0;
			char_count_eu=0; 
			char_count_ru=0; 
			char_count_cu=0; 
			pbm_complete=1;
						
		end


	end
	if(rx_msg=="#"||rx_msg=="P"||rx_msg=="B"||rx_msg=="M"||rx_msg=="S"||rx_msg=="U"|| rx_msg=="-"|| rx_msg=="2")begin  //PBM-SU-B2-#.
	char_count_su2=char_count_su2+1;

		if(char_count_su2==11) 
		begin 
			unit_msg=0;
			
			su=1;
			rx_msg=0;
			char_count_su1=0;
			char_count_su2=0;
			char_count_su3=0;
			char_count_su4=0;
			char_count_eu=0; 
			char_count_ru=0; 
			char_count_cu=0;
		pbm_complete=1;	
						
		end


	end
	if(rx_msg=="#"||rx_msg=="P"||rx_msg=="B"||rx_msg=="M"||rx_msg=="S"||rx_msg=="U"|| rx_msg=="-"|| rx_msg=="3")begin  //PBM-SU-B3-#.
	char_count_su3=char_count_su3+1;
	
		if(char_count_su3==11) 
		begin 
			unit_msg=0;
			
			su=2;
			rx_msg=0;
			char_count_su1=0;
			char_count_su2=0;
			char_count_su3=0;
			char_count_su4=0;
			char_count_eu=0; 
			char_count_ru=0; 
			char_count_cu=0; 
			pbm_complete=1;
						
		end


	end
	if(rx_msg=="#"||rx_msg=="P"||rx_msg=="B"||rx_msg=="M"||rx_msg=="S"||rx_msg=="U"|| rx_msg=="-"|| rx_msg=="4")begin  //PBM-SU-B4-#.
	char_count_su4=char_count_su4+1;

		if(char_count_su4==11) 
		begin 
			unit_msg=0;
				rx_msg=0;
			
			su=3;
			char_count_su1=0;
			char_count_su2=0;
			char_count_su3=0;
			char_count_su4=0;
			char_count_eu=0; 
			char_count_ru=0; 
			char_count_cu=0; 
			pbm_complete=1;
						
		end


	end

end
endmodule