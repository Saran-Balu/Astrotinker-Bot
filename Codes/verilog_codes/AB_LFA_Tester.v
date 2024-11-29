//For generating lfa data and motor control

module AB_LFA_Tester(
	dout,
	clk_50M,
	reset,
	adc_sclk,
	adc_cs_n,
	din,
	d,
	c,
	b,
	a
);


input wire	dout;
input wire	clk_50M;
input wire	reset;
output wire	adc_sclk;
output wire	adc_cs_n;
output wire	din;
output wire	d;
output wire	c;
output wire	b;
output wire	a;

wire	SYNTHESIZED_WIRE_5;
wire	[11:0] SYNTHESIZED_WIRE_2;
wire	[11:0] SYNTHESIZED_WIRE_3;
wire	[11:0] SYNTHESIZED_WIRE_4;

assign	adc_sclk = SYNTHESIZED_WIRE_5;




ADC_Controller	b2v_inst(
	.dout(dout),
	.adc_sck(SYNTHESIZED_WIRE_5),
	.adc_cs_n(adc_cs_n),
	.din(din),
	.center_value(SYNTHESIZED_WIRE_2),
	.left_value(SYNTHESIZED_WIRE_3),
	.right_value(SYNTHESIZED_WIRE_4));


motor_control	b2v_inst1(
	.clk(SYNTHESIZED_WIRE_5),
	.reset(reset),
	.center1(SYNTHESIZED_WIRE_2),
	.left1(SYNTHESIZED_WIRE_3),
	.right1(SYNTHESIZED_WIRE_4),
	.a(a),
	.b(b),
	.c(c),
	.d(d));
	defparam	b2v_inst1.forward = 0;
	defparam	b2v_inst1.junction = 4;
	defparam	b2v_inst1.left = 1;
	defparam	b2v_inst1.right = 2;
	defparam	b2v_inst1.stop = 3;


Frequency_Scaling	b2v_inst2(
	.clk_50M(clk_50M),
	.adc_clk_out(SYNTHESIZED_WIRE_5));


endmodule
