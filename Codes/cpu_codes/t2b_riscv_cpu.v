   // risc-v cpu capable of evaluating paths based on djikstra algorithm

module t2b_riscv_cpu (
    input clk, reset,
    input Ext_MemWrite,
    input [31:0] Ext_WriteData, Ext_DataAdr,
    output MemWrite,
    output [31:0] WriteData, DataAdr
);

// wire lines from other modules
wire [31:0] PC, Instr,ReadData;
wire[31:0] node;
wire[7:0] i;

wire MemWrite_rv32;
wire [31:0] DataAdr_rv32, WriteData_rv32;

// instantiate processor and memories
riscv_cpu rvsingle (clk, reset, PC, Instr, MemWrite_rv32, DataAdr_rv32, WriteData_rv32, ReadData);
instr_mem imem (PC, Instr);
data_mem dmem (clk, MemWrite, DataAdr, WriteData, ReadData,Instr[14:12],reset,node,i);

// output assignments
assign MemWrite = (Ext_MemWrite && reset) ? 1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr = (reset) ? Ext_DataAdr : DataAdr_rv32;

endmodule

