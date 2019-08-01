`timescale 1 ns/1 ns
`define A_WIDTH 15
`define D_WIDTH 8
`define Ac_WIDTH 7
`define Dc_WIDTH 32

module Testbench();
	reg Go_s;
	wire [(`A_WIDTH - 1) : 0] A_Addr_s, B_Addr_s;
	wire [(`D_WIDTH - 1) : 0] A_Data_s, B_Data_s, A_Di_s, B_Di_s;
	wire [(`Ac_WIDTH - 1) : 0] C_Addr_s;
	wire [(`Dc_WIDTH - 1) : 0] C_Data_s;
	wire I_RW_s, I_En_s, O_RW_s, O_En_s, Done_s;
	reg Clk_s, Rst_s, Rst_m;
	wire [31:0] SAD_Out_s;
	
	reg [(`Dc_WIDTH - 1): 0] test_memory[0:(2**`Ac_WIDTH - 1)];
	parameter ClkPeriod = 20;
	integer I;
	SAD CompToTest(Go_s, A_Addr_s, A_Data_s, B_Addr_s, B_Data_s, C_Addr_s, I_RW_s, I_En_s, O_RW_s, O_En_s, Done_s, SAD_Out_s, Clk_s, Rst_s);
	Sram_Operand SADMemA(A_Di_s, A_Data_s, A_Addr_s, I_RW_s, I_En_s, Clk_s, Rst_m);
	Sram_Operand SADMemB(B_Di_s, B_Data_s, B_Addr_s, I_RW_s, I_En_s, Clk_s, Rst_m);
	Sram_Result SADMemC(SAD_Out_s, C_Data_s, C_Addr_s, O_RW_s, O_En_s, Clk_s, Rst_s);

	//clock procedure
	always begin
		Clk_s <= 1'b0; #(ClkPeriod/2);
		Clk_s <= 1'b1; #(ClkPeriod/2);
	end
	
	//Initialize Arrays
	initial $readmemh("MemA.txt", SADMemA.Memory);
	initial $readmemh("MemB.txt", SADMemB.Memory);
	initial $readmemh("sw_result.txt", test_memory);
	
	
	//Vector procedure
	initial begin
		Rst_m <= 1'b0; Rst_s <= 1'b1; Go_s <= 1'b0;
		@(posedge Clk_s);
		Rst_s <= 1'b0; Go_s <= 1'b1;
		@(posedge Clk_s);
		Go_s <= 1'b0;
		@(posedge Clk_s);
		while(Done_s != 1'b1)
			@(posedge Clk_s);
		#5;
		for(I = 0; I < (2**`Ac_WIDTH); I= I+1) begin
			if(SADMemC.Memory[I] != test_memory[I])
				$display("SAD failed with %8x -- should equal to %8x", SADMemC.Memory[I], test_memory[I]);
			else
				$display("%3d. SAD is %8x from HW -- It is equal to %8x from SW",I, SADMemC.Memory[I], test_memory[I]);
		end 
		$stop;
	end
endmodule
