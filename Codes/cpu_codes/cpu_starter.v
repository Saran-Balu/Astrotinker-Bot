
/* feeds start and end points to cpu to plan the path*/


module cpu_starter(clk,cpu_en,future_node,EP,reset,Ext_MemWrite,Ext_WriteData,Ext_DataAdr);
input clk;
input cpu_en;
input [4:0] future_node,EP;
output reg reset;
output reg Ext_MemWrite;
output reg [31:0] Ext_WriteData,Ext_DataAdr;
integer count;
reg en;


initial begin
en=0;
count=0;

reset = 1;
end

always@(posedge clk)begin
/*
Purpose:
	Exactly turns on the cpu whenever needed
*/
if(cpu_en==1 || en==1)begin
en=1;

count=count+1;
if(count==1)begin
 reset = 1; Ext_MemWrite = 1; Ext_WriteData =future_node; Ext_DataAdr = 32'h02000000;
end
if(count==2)begin
	Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0;
end

if(count==3)begin
	Ext_MemWrite = 1; Ext_WriteData = EP; Ext_DataAdr = 32'h02000004;
end

if(count==4)begin
	 Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0;
end

if(count==5)begin
	 Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h02000008;
end

if(count==6)begin
	 Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0;
end
if(count==7)begin
	   Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h0200000c;

end
if(count==8)begin
	Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0;

end
if(count==9)begin
reset = 0;
    // External Memory Access Disabled
    Ext_MemWrite = 0; Ext_WriteData = 0; Ext_DataAdr = 0;
	 en=0;
	 count=0;

end
end


end





endmodule