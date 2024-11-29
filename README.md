# Astrotinker-Bot
Problem statement:
Build an Astro Tinker Bot [AB] that can smartly traverse through the space station using single-cycle RISC-V CPU on an FPGA.
Steps:
1.	Bot building: AstroTinker Bot is powered by an FPGA that controls sensors and actuators and pick-drop mechanism.
2.	Serial communication: Central hub informs AB about the unit of malfunctioning.
3.	Parallel processing: AB identifies the fault in particular subunit. 
4.	Point Parallel processing: AB informs CH about the malfunctioning of a particular subunit.
5.	Path planning: Navigate efficiently using the path planning algorithm implemented on RISC-V CPU.
6.	Pick and drop: AB picks the block that can fix the fault in the corresponding subunit.

Proposed solution:
This multifunctional bot employs bidirectional UART communication via HC-05 Bluetooth module between a laptop and the bot. It efficiently navigates using a 3-channel line follower array and employs the Dijkstra algorithm for optimal routes. Fault detection is done with an HC-SR04 ultrasonic sensor, and it performs pick and place tasks using an electromagnet. A RISC-V CPU developed in Verilog handles path planning, while an Altera Cyclone IV E FPGA acts as the primary controller. I used Intel Quartus Prime for FPGA programming and ModelSim for simulation and debugging. I utilized Quartus block design files for integrating various Verilog modules.
