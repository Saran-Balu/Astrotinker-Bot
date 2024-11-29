 Used to turn on the appropriate LEDs

module leds (
  unitlist,i_fault,p_block,b_drop,
   r, g, z
);
input [1:0] unitlist;
input i_fault,p_block,b_drop;
  output reg [2:0] r, g, z;


initial begin
	{r,g,z}=9'b0;
end

always@(*)begin


	if(unitlist==0 && i_fault==1) {r,g,z}=9'b100_000_000;
	else if(unitlist==0 && p_block==1) {r,g,z}=9'b000_000_100;
	else if(unitlist==0 && b_drop==1) {r,g,z}=9'b000_100_000;
	else if(unitlist==1 && i_fault==1) {r,g,z}=9'b010_000_000;
	else if(unitlist==1 && p_block==1) {r,g,z}=9'b000_000_010;
	else if(unitlist==1 && b_drop==1) {r,g,z}=9'b000_010_000;
	else if(unitlist==2 && i_fault==1) {r,g,z}=9'b001_000_000;
	else if(unitlist==2 && p_block==1) {r,g,z}=9'b000_000_001;
	else if(unitlist==2 && b_drop==1) {r,g,z}=9'b000_001_000;
end
    
  
endmodule
