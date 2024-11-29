//the file can sample path planned array from cpu.The array is traversed as the bot navigates through the planeed path.
 
module sampler(clk,MemWrite,reset,node_update,WriteData,DataAdr,unitlist,i_fault,p_block,b_drop,cpu_done,right_en,left_en,forward_en,reverse_en,past_node,present_node,future_node,prev_right_en,prev_left_en,prev_forward_en,prev_reverse_en,cpu_writes1,fault_at);
input clk;input MemWrite; input reset; input[31:0] WriteData,DataAdr; output cpu_done;output right_en,left_en,forward_en,reverse_en,prev_right_en,prev_left_en,prev_forward_en,prev_reverse_en; 
reg cpu_done=0;
input i_fault,p_block,b_drop;
reg [7:0] ir=0;
input [1:0] unitlist;
input [4:0] fault_at;
input node_update;
output [4:0] past_node,present_node,future_node;

reg [5:0] j=1;
reg flag=1;
reg jreset=0;
reg[5:0] cpu_writes=0;
output [5:0] cpu_writes1;
reg[31:0] test_path=0;
reg right_en=0;reg left_en=0;reg forward_en=0;reg reverse_en=0;
reg prev_right_en=0;reg prev_left_en=0;reg prev_forward_en=0;reg prev_reverse_en=0;
reg[4:0] past_node=0;reg[4:0] present_node=0;reg[4:0]future_node=1;
reg[31:0] path_planned[0:15];
always @(negedge clk) begin
/*
Purpose:
---
used to define the corresponding nodes for manual travesal in each of the unit.
*/
jreset=0;
if(future_node==29 && i_fault==1 &&unitlist==0 )begin //unitlist=0=eu 1=cu 2 = ru;

path_planned[0]=29;
path_planned[1]=28;
path_planned[2]=26;
path_planned[3]=27;
path_planned[4]=26;
path_planned[5]=25;
path_planned[6]=24;
path_planned[7]=20;

end



if(future_node==28 && i_fault==1&&unitlist==0)begin

path_planned[0]=28;
path_planned[1]=26;
path_planned[2]=27;
path_planned[3]=26;
path_planned[4]=25;
path_planned[5]=24;
path_planned[6]=20;


end
if(future_node==27 && i_fault==1 &&unitlist==0)begin

path_planned[0]=27;
path_planned[1]=26;
path_planned[2]=25;
path_planned[3]=24;


end
if(future_node==8 && i_fault==1&&unitlist==1)begin //cu

path_planned[0]=8;
path_planned[1]=7;
path_planned[2]=6;
path_planned[3]=4;
/*path_planned[4]=3;
path_planned[5]=2;*/

path_planned[4]=5;
path_planned[5]=4;
path_planned[6]=3;
path_planned[7]=2;



end
if(future_node==6 && i_fault==1 &&unitlist==1)begin //cu

path_planned[0]=6;
path_planned[1]=4;
path_planned[2]=5;
path_planned[3]=4;
path_planned[4]=3;
path_planned[5]=2;
end
if(future_node==24 && present_node==20 && b_drop==1 && fault_at==24)begin
path_planned[0]=24;
path_planned[1]=25;
path_planned[2]=24;



end
if(future_node==4 && present_node==3 && b_drop==1 && fault_at==4)begin
path_planned[0]=4;
path_planned[1]=5;
path_planned[2]=4;



end
if(future_node==2 && present_node==1 && b_drop==1 && fault_at==2)begin

path_planned[0]=2;
path_planned[1]=3;
path_planned[2]=2;



end
if(future_node==18 && present_node==16 && b_drop==1 && fault_at==18)begin

path_planned[0]=18;
path_planned[1]=19;
path_planned[2]=18;



end
if(future_node==16 && present_node==18 && b_drop==1 && fault_at==16)begin

path_planned[0]=16;
path_planned[1]=17;
path_planned[2]=16;



end
if(future_node==16 && present_node==14 && b_drop==1 && fault_at==16)begin

path_planned[0]=16;
path_planned[1]=17;
path_planned[2]=16;



end
if(future_node==2 && present_node==8 && b_drop==1 && fault_at==2)begin
path_planned[0]=2;
path_planned[1]=3;
path_planned[2]=2;



end
if(future_node==6 && present_node==4 && b_drop==1 && fault_at==6)begin
path_planned[0]=6;
path_planned[1]=7;
path_planned[2]=6;



end
if(future_node==12 && present_node==8 && b_drop==1 && fault_at==12)begin
path_planned[0]=12;
path_planned[1]=13;
path_planned[2]=12;



end
if(future_node==4 && present_node == 5&& i_fault==1&&unitlist==1)begin //cu


path_planned[0]=4;
path_planned[1]=3;
path_planned[2]=2;




end

if(future_node==19 && present_node==20 && i_fault==1&&unitlist==2)begin //ru
path_planned[0]=19;
path_planned[1]=18;
path_planned[2]=16;
path_planned[3]=17;
path_planned[4]=16;
path_planned[5]=14;
path_planned[6]=15;
path_planned[7]=14;
path_planned[8]=13;
path_planned[9]=12;
end
if(future_node==18 && i_fault==1&&unitlist==2)begin //ru
path_planned[0]=18;
path_planned[1]=16;
path_planned[2]=17;
path_planned[3]=16;
path_planned[4]=14;
path_planned[5]=15;
path_planned[6]=14;
path_planned[7]=13;
path_planned[8]=12;


end
if(future_node==16 &&present_node==17 && i_fault==1&&unitlist==2)begin
path_planned[0]=16;
path_planned[1]=14;
path_planned[2]=15;
path_planned[3]=14;
path_planned[4]=13;
path_planned[5]=12;

end
if(future_node==15 && i_fault==1&&unitlist==2)begin
path_planned[0]=15;
path_planned[1]=14;

path_planned[2]=13;
path_planned[3]=12;
end
    if(MemWrite && !reset) begin
        if (DataAdr == 32'h02000008) begin
            path_planned[ir]=WriteData;
				ir=ir+1;
        end
        if (DataAdr == 32'h0200000c & WriteData == 32'h1) begin
            cpu_done=1;
				ir=0;
				jreset=1;
				
				cpu_writes=cpu_writes+1;
        end
    end
	 
	 
end

always@(posedge node_update or posedge jreset)begin
/*
Purpose:
---
WHenever a node is reached the corresponding past,present,future nodes are updated
*/
	if(jreset==1 )j=1;
	else begin
			prev_right_en=right_en;
			prev_left_en=left_en;
			prev_forward_en=forward_en;
			prev_reverse_en=reverse_en;
			past_node=present_node;
			present_node=future_node;
			future_node=path_planned[j];
			j=j+1;
			if(future_node==29 && i_fault==1&&unitlist==0)j=1;
			if(future_node==6 && present_node==4 && b_drop==1 && fault_at==6)j=1;
			if(future_node==18 && present_node==16 && b_drop==1 && fault_at==18)j=1;
			if(future_node==28 && i_fault==1&&unitlist==0)j=1;
			if(future_node==27 && i_fault==1&&unitlist==0)j=1;
			if(future_node==8 && i_fault==1&&unitlist==1)j=1;
			if(future_node==6 && i_fault==1&&unitlist==1)j=1;
			if(future_node==4 && present_node == 5 && i_fault==1 &&unitlist==1)j=1;
			if(future_node==19 && i_fault==1&&unitlist==2)j=1;
			if(future_node==18 && i_fault==1&&unitlist==2)j=1;
			if(future_node==16 &&present_node==17 && i_fault==1&&unitlist==2)j=1;
			if(future_node==15 && i_fault==1&&unitlist==2)j=1;
			if(future_node==24 && present_node==20 && b_drop==1 && fault_at==24)j=1;
			if(future_node==4 && present_node==3 && b_drop==1 && fault_at==4)j=1;
			if(future_node==2 && present_node==1 && b_drop==1 && fault_at==2)j=1;
			if(future_node==2 && present_node==8 && b_drop==1 && fault_at==2)j=1;
			if(future_node==16 && present_node==18 && b_drop==1 && fault_at==16)j=1;
			if(future_node==16 && present_node==14 && b_drop==1 && fault_at==16)j=1;
			if(future_node==12 && present_node==8 && b_drop==1 && fault_at==12)j=1;
			//if(future_node==10 && (b_drop==1) && unitlist==2)j=1;
			
			
			
			
			
			
			end
end
always@(present_node)begin
case(present_node)
1:begin
if(past_node==0 && future_node==29)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==0 && future_node==2)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==2 && future_node==29)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==29 && future_node==2)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
29:begin
if(past_node==1 && future_node==28)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==1 && future_node==20)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==20 && future_node==28)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==28 && future_node==1)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==20 && future_node==1)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==28 && future_node==20)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
28:begin
if(past_node==29 && future_node==29)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
if(past_node==26 && future_node==29)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==29 && future_node==26)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
26:begin
if(past_node==28 && future_node==27)begin
right_en=0;
forward_en=0;
reverse_en=0;
left_en=1;
end
if(past_node==27 && future_node==28)begin
right_en=0;
forward_en=1;
reverse_en=0;
left_en=0;
end
if(past_node==27 && future_node==25)begin
right_en=0;
forward_en=1;
reverse_en=0;
left_en=0;
end
if(past_node==25 && future_node==27)begin
right_en=1;
forward_en=0;
reverse_en=0;
left_en=0;
end
end
27:begin
if(past_node==26 && future_node==26)begin
right_en=0;
forward_en=0;
reverse_en=1;
left_en=0;
end
end
25:begin
if(past_node==26 && future_node==24)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==24 && future_node==24)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
if(past_node==24 && future_node==26)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
24:begin
if(past_node==25 && future_node==20)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==20 && future_node==25)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
20:begin
if(past_node==29 && future_node==21)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==24 && future_node==29)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==24 && future_node==19)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==21 && future_node==19)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==19 && future_node==21)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==29 && future_node==19)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==19 && future_node==29)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==24 && future_node==21)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==21 && future_node==24)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==21 && future_node==29)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
21:begin
if(past_node==20 && future_node==22)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==20 && future_node==23)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==22 && future_node==20)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==23 && future_node==20)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
22:begin
if(past_node==21 && future_node==21)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
end
10:begin
if(past_node==9 && future_node==9)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
end
11:begin
if(past_node==9 && future_node==9)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
end
23:begin
if(past_node==21 && future_node==21)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
end
19:begin
if(past_node==20 && future_node==18)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==18 && future_node==18)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
if(past_node==18 && future_node==20)begin
right_en=0;
reverse_en=0;
forward_en=0;
left_en=1;
end
if(past_node==12 && future_node==20)begin
right_en=1;
reverse_en=0;
forward_en=0;
left_en=0;
end
if(past_node==12 && future_node==18)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==20 && future_node==12)begin
right_en=1;
reverse_en=0;
forward_en=0;
left_en=0;
end
end
18:begin
if(past_node==19 && future_node==16)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==19 && future_node==19)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
if(past_node==16 && future_node==19)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
16:begin
if(past_node==18 && future_node==17)begin
right_en=0;
reverse_en=0;
forward_en=0;
left_en=1;
end
if(past_node==18 && future_node==14)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==14 && future_node==18)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==17 && future_node==14)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==14 && future_node==17)begin
right_en=1;
reverse_en=0;
forward_en=0;
left_en=0;
end
if(past_node==14 && future_node==18)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==17 && future_node==18)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
17:begin
if(past_node==16 && future_node==16)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
end
14:begin
if(past_node==16 && future_node==15)begin
right_en=0;
reverse_en=0;
forward_en=0;
left_en=1;
end
if(past_node==15 && future_node==16)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==13 && future_node==16)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==16 && future_node==13)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==15 && future_node==13)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==13 && future_node==15)begin
right_en=1;
reverse_en=0;
forward_en=0;
left_en=0;
end
end
15:begin
if(past_node==14 && future_node==14)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
end
13:begin
if(past_node==14 && future_node==12)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==12 && future_node==14)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==12 && future_node==12)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
end
12:begin
if(past_node==13 && future_node==8)begin
right_en=1;
reverse_en=0;
forward_en=0;
left_en=0;
end
if(past_node==8 && future_node==19)begin
right_en=1;
reverse_en=0;
forward_en=0;
left_en=0;
end
if(past_node==8 && future_node==13)begin
right_en=0;
reverse_en=0;
forward_en=0;
left_en=1;
end
if(past_node==13 && future_node==19)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
8:begin
if(past_node==9 && future_node==2)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==12 && future_node==9)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==12 && future_node==7)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==12 && future_node==2)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==7 && future_node==12)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==2 && future_node==12)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==9 && future_node==12)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==9 && future_node==7)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==2 && future_node==9)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==2 && future_node==7)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==7 && future_node==9)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
2:begin
if(past_node==1 && future_node==8)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==1 && future_node==3)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==8 && future_node==1)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==3 && future_node==8)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==8 && future_node==3)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
7:begin
if(past_node==8 && future_node==6)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==6 && future_node==6)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
if(past_node==6 && future_node==8)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
6:begin
if(past_node==7 && future_node==4)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==4 && future_node==7)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==7 && future_node==7)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end

end
4:begin
if(past_node==6 && future_node==5)begin
right_en=0;
reverse_en=0;
forward_en=0;
left_en=1;
end
if(past_node==3 && future_node==6)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==5 && future_node==3)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==3 && future_node==5)begin
right_en=1;
reverse_en=0;
forward_en=0;
left_en=0;
end
if(past_node==6 && future_node==3)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
5:begin
if(past_node==4 && future_node==4)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
end
3:begin
if(past_node==4 && future_node==2)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==2 && future_node==4)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==2 && future_node==2)begin
right_en=0;
reverse_en=1;
forward_en=0;
left_en=0;
end
end
9:begin
if(past_node==10 && future_node==8)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==8 && future_node==10)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==11 && future_node==8)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
if(past_node==8 && future_node==11)begin
right_en=0;
reverse_en=0;
forward_en=1;
left_en=0;
end
end
endcase



end
assign cpu_writes1=cpu_writes;
endmodule