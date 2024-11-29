//For detecting any fault in the arena using the ultrasonic sensor and sending an alert

//Output : trigger, distance, pulses, state

// module declaration
module ultrasonic (
    input clk_50M, reset, echo_rx,
    output reg trigger, out,
    output reg [21:0] pulses,
    output reg [1:0] state
);

initial begin
    trigger = 0; out = 1; pulses = 0; state = 0;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////
reg[1:0] next_state;
reg flag=0;
reg[21:0] distance;

integer warm_count;
integer trigger_count;
integer read_count;
integer count;

initial begin
warm_count=0;
trigger_count=0;
read_count=0;
count=0;
distance=0;

end


parameter warm_up =2'b00,trigger_pulse=2'b01,read_input=2'b10;
always @(posedge clk_50M)begin

count=count+1;
if(flag)begin
trigger=1;
end
else begin
trigger=0;
end

if(!reset)begin
 pulses=0;
 state=0;
 trigger=0;
 
 
 count=0;
 
 end

else begin

case(state)
warm_up : begin
if(!reset)begin


count=0;
next_state=warm_up;
end
else begin
if(count==4) begin
next_state=trigger_pulse;
//trigger=1;
flag=1;
count=0;
end
else begin
next_state=warm_up;
end
end
end // end of first state
trigger_pulse : begin
if(!reset)begin
next_state=warm_up;

count=0;
end
else begin

if(count==32)begin
//trigger=0;
flag=0;
next_state=read_input;
count=0;
end
else begin
next_state=trigger_pulse;
end
end


end// end of trigger state
read_input : begin
if(!reset)begin
next_state=warm_up;
count=0;
pulses=0;

end
else begin

if(count>=1 && count<218820)begin // 70ms
if( echo_rx==1) begin
pulses=pulses+1;
next_state=read_input;
end// end of 118 if
end//end of 117 if
else begin
if(pulses==29410)begin
//out=1;
pulses=0;
count=0;

next_state=warm_up;
end
else begin 
pulses=0;
count=0;


next_state=warm_up;

end
end //end of 123 else
end //end of 115 else
end //endof read state
endcase
state=next_state;
end
end
always@(negedge echo_rx) begin
distance=pulses;
out=distance>1200?1:0;//

end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule
