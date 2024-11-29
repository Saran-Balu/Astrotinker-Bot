//  data memory for single-cycle RISC-V CPU

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input       [ADDR_WIDTH-1:0] wr_addr,
    input       [DATA_WIDTH-1:0] wr_data,
    output reg  [DATA_WIDTH-1:0] rd_data_mem,
	 input [2:0]  funct3,
	 input reset,output[31:0] node,output[7:0] i
);

    // array of 64 32-bit words or data
    reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
	 reg[4:0] path_planned [0:15];
	  wire[4:0] path_planned1 [0:15];
	 reg [31:0] noder=35;
	 reg [5:0] j=0;
	 
	 reg[7:0] ir=0;
	 initial begin
		 path_planned[0]=5'b0; path_planned[1]=5'b0; path_planned[2]=5'b0; path_planned[3]=5'b0; path_planned[4]=5'b0; path_planned[5]=5'b0;
	  path_planned[6]=5'b0; path_planned[7]=5'b0; path_planned[8]=5'b0; path_planned[9]=5'b0; path_planned[10]=5'b0; path_planned[11]=5'b0;
	   path_planned[12]=5'b0; path_planned[13]=5'b0; path_planned[14]=5'b0; path_planned[15]=5'b0;
	 end
	

    // combinational read logic
    // word-aligned memory access
	 

    always @* begin
	 
	 case(funct3)
	 
	 3'b000 : begin
        case (wr_addr[1:0])
            2'b00: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][7:0]};
            2'b01: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:8]};
            2'b10: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][23:16]};
            2'b11: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:24]};
            default: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][7:0]};
        endcase
end
		  
	3'b001 : begin
		case (wr_addr[1:0])
            2'b00: rd_data_mem = {16'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:0]};
//            2'b01: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:8];
            2'b10: rd_data_mem = {16'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:16]};
//            2'b11: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:24];
            default: rd_data_mem = {16'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:0]};
				endcase
end
				
	3'b010 : begin
	case (wr_addr[1:0])
            2'b00: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % 64];
//            2'b01: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:8];
//            2'b10: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][23:16];
//            2'b11: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:24];
            default: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % 64];
				endcase
end
	 3'b100 : begin
        case (wr_addr[1:0])
            2'b00: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][7:0]};
            2'b01: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:8]};
            2'b10: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][23:16]};
            2'b11: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:24]};
            default: rd_data_mem = {24'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][7:0]};
        endcase
end
		  
	3'b101 : begin
		case (wr_addr[1:0])
            2'b00: rd_data_mem = {16'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:0]};
//            2'b01: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:8];
            2'b10: rd_data_mem = {16'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:16]};
//            2'b11: rd_data_mem = data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:24];
            default: rd_data_mem = {16'b0, data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:0]};
				endcase
end
			
	endcase			
    end

	 

	 
    // synchronous write logic
    always @(posedge clk) begin
	 noder=data_ram[2];
        	if(!reset) begin
        if (wr_en) begin
		 if(wr_addr==32'h02000008) begin ir=ir+1;end
		  case(funct3)
		  
		  3'b000 : begin
            case (wr_addr[1:0])
                2'b00: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][7:0] <= wr_data[7:0];
                2'b01: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:8] <= wr_data[7:0];
                2'b10: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][23:16] <= wr_data[7:0];
                2'b11: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:24] <= wr_data[7:0];
                default: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64] <= wr_data;
            endcase
			end
			
			3'b001 : begin
			            case (wr_addr[1:0])
                2'b00: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:0] <= wr_data[15:0];
//                2'b01: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:8] <= wr_data[7:0];
                2'b10: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:16] <= wr_data[15:0];
//                2'b11: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:24] <= wr_data[7:0];
                default: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64] <= wr_data;
            endcase
			end
			
			3'b010 : begin
			            case (wr_addr[1:0])
                2'b00: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64] <= wr_data;
//                2'b01: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][15:8] <= wr_data[7:0];
//                2'b10: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:16] <= wr_data[15:0];
//                2'b11: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64][31:24] <= wr_data[7:0];
                default: data_ram[wr_addr[ADDR_WIDTH-1:2] % 64] <= wr_data;
            endcase
			end
			endcase
        end
    end

    else begin
        if (wr_en) begin
        data_ram[wr_addr[ADDR_WIDTH-1:2] % 64] <= wr_data;
		  end
    end
    end
assign node=noder;
assign i=ir;


endmodule