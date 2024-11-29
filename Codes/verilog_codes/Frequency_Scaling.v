 Used to downscale the input clock signal by 16 times


module Frequency_Scaling(
    input clk_50M,
    output reg adc_clk_out
);

// Declaring registers
reg [2:0] s_clk_counter = 0;

// For ADC Module 50Mhz to 3.125Mhz
always @(negedge clk_50M) begin
/*
Purpose:
---
To downscale the 50Mhz frequence to 3.125 Mhz by using 16 bit counter
*/

    if (s_clk_counter == 7) adc_clk_out = ~adc_clk_out;
    s_clk_counter = s_clk_counter + 1'b1;
end

endmodule

