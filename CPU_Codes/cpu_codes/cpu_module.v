 /*comprises many modules for generating appropraite control signals for the bot movement.*/
 


module cpu_module(
	clk,
	rx,
	node_update,
	echo,
	ultra_reset,
	cpu_done,
	right_en,
	left_en,
	forwar_en,
	reverse_en,
	prev_right,
	prev_left,
	prev_forward,
	prev_reverse,
	trigger,
	ultra_out,
	i_fault,
	p_block,
	b_drop,
	future_node,
	past_node,
	present_node,
	delatch,send_msg_fim,send_msg_bpm,send_msg_bdm,su,r,g,z,stop,ru_red,cu_red,eu_red,ru_blue,cu_blue,eu_blue,ru_green,cu_green,eu_green
);


input wire	clk;
input wire	rx;
input wire	node_update;
input wire	echo;
input wire	ultra_reset;
output wire	cpu_done;
output wire	right_en;
output wire	left_en;
output wire	forwar_en;
output wire	reverse_en;
output wire	prev_right;
output wire	prev_left;
output wire	prev_forward;
output wire	prev_reverse;
output wire	trigger;
output wire	ultra_out;
output wire	i_fault;
output wire	p_block;
output wire	b_drop;
output wire	[4:0] future_node;
output wire	[4:0] past_node;
output wire	[4:0] present_node;
output wire delatch;
output wire [2:0] su;
output wire[2:0] r,g,z;
output wire send_msg_fim,send_msg_bpm;
output wire[2:0] send_msg_bdm;
output wire[3:0] stop;
output wire ru_red,cu_red,eu_red,ru_blue,cu_blue,eu_blue,ru_green,cu_green,eu_green;

wire	SYNTHESIZED_WIRE_25;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_4;
wire	[4:0] SYNTHESIZED_WIRE_5;
wire	[2:0] SYNTHESIZED_WIRE_6;
wire	[1:0] SYNTHESIZED_WIRE_7;
wire[2:0] red,blue,green;
wire	SYNTHESIZED_WIRE_26;
wire	SYNTHESIZED_WIRE_10;
wire	[31:0] SYNTHESIZED_WIRE_11;
wire	[31:0] SYNTHESIZED_WIRE_12;
wire	SYNTHESIZED_WIRE_14;
wire	[4:0] SYNTHESIZED_WIRE_15;
wire	[4:0] SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_22;
wire 	SYNTHESIZED_WIRE_1;
wire 	SYNTHESIZED_WIRE_30;
wire 	SYNTHESIZED_WIRE_31;
wire 	SYNTHESIZED_WIRE_37;
wire[2:0] SYNTHESIZED_WIRE_32;
wire [1:0] SYNTHESIZED_WIRE_33;
wire [3:0] SYNTHESIZED_WIRE_34;
wire [2:0] SYNTHESIZED_WIRE_35;
wire [4:0] SYNTHESIZED_WIRE_36;
wire 	SYNTHESIZED_WIRE_38;
wire 	SYNTHESIZED_WIRE_39;
wire 	SYNTHESIZED_WIRE_40;
wire 	SYNTHESIZED_WIRE_41;
wire 	SYNTHESIZED_WIRE_42;
wire 	SYNTHESIZED_WIRE_43;
wire 	SYNTHESIZED_WIRE_44;
wire 	SYNTHESIZED_WIRE_45;


wire	[31:0] SYNTHESIZED_WIRE_23;
wire	[31:0] SYNTHESIZED_WIRE_24;

assign	ultra_out = SYNTHESIZED_WIRE_2;
assign	i_fault = SYNTHESIZED_WIRE_20;
assign	p_block = SYNTHESIZED_WIRE_21;
assign	b_drop = SYNTHESIZED_WIRE_22;
assign	future_node = SYNTHESIZED_WIRE_16;
assign	present_node = SYNTHESIZED_WIRE_5;
assign   delatch=  SYNTHESIZED_WIRE_1;
assign send_msg_fim=SYNTHESIZED_WIRE_30;
assign send_msg_bpm=SYNTHESIZED_WIRE_31;
assign send_msg_bdm=SYNTHESIZED_WIRE_32;
assign su=SYNTHESIZED_WIRE_6;
assign stop=SYNTHESIZED_WIRE_34;
assign r=red;
assign g=green;
assign z=blue;
//.ru_red(SYNTHESIZED_WIRE_37),.cu_red(SYNTHESIZED_WIRE_38),.eu_red(SYNTHESIZED_WIRE_39),.ru_blue(SYNTHESIZED_WIRE_40),.cu_blue(SYNTHESIZED_WIRE_41),.eu_blue(SYNTHESIZED_WIRE_42),.ru_green(SYNTHESIZED_WIRE_43),.cu_green(SYNTHESIZED_WIRE_44),.eu_green(SYNTHESIZED_WIRE_45);
assign ru_red=SYNTHESIZED_WIRE_37;assign cu_red=SYNTHESIZED_WIRE_38;assign eu_red=SYNTHESIZED_WIRE_39;
assign ru_blue=SYNTHESIZED_WIRE_40;assign cu_blue=SYNTHESIZED_WIRE_41;assign eu_blue=SYNTHESIZED_WIRE_42;
assign ru_green=SYNTHESIZED_WIRE_43;assign cu_green=SYNTHESIZED_WIRE_44;assign eu_green=SYNTHESIZED_WIRE_45;



leds led1(
	.unitlist(SYNTHESIZED_WIRE_33),
	.i_fault(SYNTHESIZED_WIRE_20),
	.p_block(SYNTHESIZED_WIRE_21),
	.b_drop(SYNTHESIZED_WIRE_22),
	.r(red),
	.g(green),
	.z(blue)
	

);

ultrasonic	b2v_inst10(
	.clk_50M(SYNTHESIZED_WIRE_25),
	.reset(ultra_reset),
	.echo_rx(echo),
	.trigger(trigger),
	.out(SYNTHESIZED_WIRE_2)
	
	);
	defparam	b2v_inst10.read_input = 2'b10;
	defparam	b2v_inst10.trigger_pulse = 2'b01;
	defparam	b2v_inst10.warm_up = 2'b00;


bot_states	b2v_inst2(
	.clk(SYNTHESIZED_WIRE_25),
	.en(SYNTHESIZED_WIRE_2),
	.unit_msg(SYNTHESIZED_WIRE_3),
	.pbm_complete(SYNTHESIZED_WIRE_4),
	.present_node(SYNTHESIZED_WIRE_5),
	.su(SYNTHESIZED_WIRE_6),
	.unit_pulse(SYNTHESIZED_WIRE_7),
	.cpu_en(SYNTHESIZED_WIRE_14),
	.i_fault(SYNTHESIZED_WIRE_20),
	.p_block(SYNTHESIZED_WIRE_21),
	.b_drop(SYNTHESIZED_WIRE_22),
	.EP(SYNTHESIZED_WIRE_15),
	.delatch(SYNTHESIZED_WIRE_1),
	.send_msg_fim(SYNTHESIZED_WIRE_30),
	.send_msg_bpm(SYNTHESIZED_WIRE_31),
	.send_msg_bdm(SYNTHESIZED_WIRE_32),
	.unitlist(SYNTHESIZED_WIRE_33),
	.stop(SYNTHESIZED_WIRE_34),
	.future_node(SYNTHESIZED_WIRE_16),
	.msg_count(SYNTHESIZED_WIRE_35),
	.b(SYNTHESIZED_WIRE_36),
	.ru_red(SYNTHESIZED_WIRE_37),
	.cu_red(SYNTHESIZED_WIRE_38),
	.eu_red(SYNTHESIZED_WIRE_39),
	.ru_blue(SYNTHESIZED_WIRE_40),
	.cu_blue(SYNTHESIZED_WIRE_41),
	.eu_blue(SYNTHESIZED_WIRE_42),
	.ru_green(SYNTHESIZED_WIRE_43),
	.cu_green(SYNTHESIZED_WIRE_44),
	.eu_green(SYNTHESIZED_WIRE_45)
	
	
	
	
	);
	defparam	b2v_inst2.BLOCK_DROP = 2'b10;
	defparam	b2v_inst2.IDENTIFY_FAULT = 2'b00;
	defparam	b2v_inst2.PICK_BLOCK = 2'b01;


t2b_riscv_cpu	b2v_inst3(
	.clk(SYNTHESIZED_WIRE_25),
	.reset(SYNTHESIZED_WIRE_26),
	.Ext_MemWrite(SYNTHESIZED_WIRE_10),
	.Ext_DataAdr(SYNTHESIZED_WIRE_11),
	.Ext_WriteData(SYNTHESIZED_WIRE_12),
	.MemWrite(SYNTHESIZED_WIRE_18),
	.DataAdr(SYNTHESIZED_WIRE_23),
	.WriteData(SYNTHESIZED_WIRE_24));


cpu_starter	b2v_inst4(
	.clk(SYNTHESIZED_WIRE_25),
	.cpu_en(SYNTHESIZED_WIRE_14),
	.EP(SYNTHESIZED_WIRE_15),
	.future_node(SYNTHESIZED_WIRE_16),
	.reset(SYNTHESIZED_WIRE_26),
	.Ext_MemWrite(SYNTHESIZED_WIRE_10),
	.Ext_DataAdr(SYNTHESIZED_WIRE_11),
	.Ext_WriteData(SYNTHESIZED_WIRE_12));


Frequency_Scaling	b2v_inst5(
	.clk_50M(clk),
	.adc_clk_out(SYNTHESIZED_WIRE_25));


rx_test	b2v_inst6(
	.clk(clk),
	.rx(rx),
	.unit_msg(SYNTHESIZED_WIRE_3),
	.pbm_complete(SYNTHESIZED_WIRE_4),
	.su(SYNTHESIZED_WIRE_6),
	.msg_count(SYNTHESIZED_WIRE_35),
	.unit_pulse(SYNTHESIZED_WIRE_7));
	defparam	b2v_inst6.DATA_BITS = 2;
	defparam	b2v_inst6.IDLE = 0;
	defparam	b2v_inst6.START_BIT = 1;
	defparam	b2v_inst6.STOP = 3;


sampler	b2v_inst9(
	.clk(SYNTHESIZED_WIRE_25),
	.MemWrite(SYNTHESIZED_WIRE_18),
	.reset(SYNTHESIZED_WIRE_26),
	.node_update(node_update),
	.i_fault(SYNTHESIZED_WIRE_20),
	.p_block(SYNTHESIZED_WIRE_21),
	.b_drop(SYNTHESIZED_WIRE_22),
	.DataAdr(SYNTHESIZED_WIRE_23),
	.WriteData(SYNTHESIZED_WIRE_24),
	.cpu_done(cpu_done),
	.right_en(right_en),
	.left_en(left_en),
	.forward_en(forwar_en),
	.reverse_en(reverse_en),
	.prev_right_en(prev_right),
	.prev_left_en(prev_left),
	.prev_forward_en(prev_forward),
	.prev_reverse_en(prev_reverse),
	.future_node(SYNTHESIZED_WIRE_16),
	.past_node(past_node),
	.unitlist(SYNTHESIZED_WIRE_33),
	.present_node(SYNTHESIZED_WIRE_5),
	.fault_at(SYNTHESIZED_WIRE_36)
	
	);


endmodule
