// Used for turning on and off the electromagnet signals using node values and ultrasonic sensor 


module electromagnet(clk,future_node,en,delatch,o1,o2);


	input clk,en;
	input[4:0] future_node;
	input delatch;
	reg[3:0] fault_detect_count=0;
	reg[3:0] count=0;
	output o1,o2;
	
	reg pwm=0;
	reg o1=0;reg o2=0;
	integer drop_count=0;
	reg drop_flag=0;
	
	
	always @(posedge clk)begin
	/*
Purpose:
---
Used to turn ON or OFF the electromagnet using position of the bot and faults
*/		if(future_node==22 || future_node==23||future_node==10||future_node==11)begin
			o1=1;
			o2=0;
		end
		if(delatch==1)begin
			o1 = 0;
			o2 = 0;
			
		end
	
	end


endmodule