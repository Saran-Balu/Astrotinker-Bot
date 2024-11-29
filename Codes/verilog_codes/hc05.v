module hc05(clk,tx,en,jreset);
input clk;
input jreset;
input en;
output reg tx;
reg[7:0] data;
integer i,count,edge_count,j;
reg flag,a,b,stage;
initial begin
i=0;
j=0;
flag=1;

count=0;

/*data[0]="U";
data[1]="A";
data[2]="R";
data[3]="T";*/
data="U";
end


always@(posedge clk)begin
if(jreset==1)begin
j=0;
end

if(j==0 && flag==1)begin
data="F";


end
if(j==1 && flag==1)begin
data="I";
end
if(j==2 && flag==1)begin
data="M";
end
if(j==3 && flag==1)begin
data="-";
end
if(j==4 && flag==1)begin
data="E";
end
if(j==5 && flag==1)begin
data="S";
end
if(j==6 && flag==1)begin
data="U";
end
if(j==7 && flag==1)begin
data="3";
end
if(j==8 && flag==1)begin
data="-";
end
if(j==9 && flag==1)begin
data="#";


end
if(j==0 && flag==0)begin
data="F";

end
if(j==1 && flag==0)begin
data="I";
end
if(j==2 && flag==0)begin
data="M";
end
if(j==3 && flag==0)begin
data="-";
end
if(j==4 && flag==0)begin
data="C";
end
if(j==5 && flag==0)begin
data="S";
end
if(j==6 && flag==0)begin
data="U";
end
if(j==7 && flag==0)begin
data="1";
end
if(j==8 && flag==0)begin
data="-";
end
if(j==9 && flag==0)begin
data="#";

end

if(j<10 && !en)begin
count=count+1;
if(count>0 && count<=434)begin
tx=0;
end


if(count>434 && count<=3906)begin
if((count-1)%434==0)begin
i=i+1;
end
tx=data[i-1];
end

if(count>3906 && count<=4340)begin
tx=1;
if(count==4340)begin
count=0;

i=0;
j=j+1;
flag=~flag;

end

end
end

end



endmodule