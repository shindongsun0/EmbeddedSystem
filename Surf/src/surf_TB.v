`timescale 1 ns/1 ns
`define A_WIDTH 17
`define D_WIDTH 16
`define COL 320
`define ROW 240
`define DetMSize 75516
`define XA_WIDTH 4
`define XD_WIDTH 32
`define YA_WIDTH 4
`define YD_WIDTH 32
`define XYA_WIDTH 5
`define XYD_WIDTH 32	

module Testbench();

	reg Go_s;
	wire [(`D_WIDTH - 1) : 0] I_Data_s, D_Data_s, I_Di_s, D_Di_s;
	wire [(`A_WIDTH - 1) : 0] I_Addr_s, D_Addr_s;
	wire I_RW_s, I_En_s, O_RW_s, O_En_s, Done_s;
	wire [(`D_WIDTH - 1) : 0] Surf_Out_s;
	reg Clk_s, Rst_s, Rst_m;
	wire [(`XA_WIDTH - 1) : 0] X_Addr_s, Y_Addr_s;
	wire [(`XYA_WIDTH - 1) : 0] XY_Addr_s;
	wire [(`XYD_WIDTH - 1) : 0] X_Data_s, Y_Data_s, XY_Data_s, X_Di_s, Y_Di_s, XY_Di_s;
	
	reg [(`D_WIDTH - 1): 0] test_memory[0:(2**`A_WIDTH - 1)];
	parameter ClkPeriod = 20;
	integer I, J;
	CalcDeterminant CompToTest(Go_s, I_Addr_s, I_Data_s, X_Addr_s, X_Data_s, Y_Addr_s, Y_Data_s, XY_Addr_s, XY_Data_s,
			D_Addr_s, I_RW_s, I_En_s, O_RW_s, O_En_s, Done_s, Surf_Out_s, Clk_s, Rst_s);
	Sram_Operand integralImage(I_Di_s, I_Data_s, I_Addr_s, I_RW_s, I_En_s, Clk_s, Rst_m);
	regfile_Operand Dx(X_Di_s, X_Data_s, X_Addr_s, I_RW_s, I_En_s, Clk_s, Rst_m);
	regfile_Operand Dy(Y_Di_s, Y_Data_s, Y_Addr_s, I_RW_s, I_En_s, Clk_s, Rst_m);
	regfile2_Operand Dxy(XY_Di_s, XY_Data_s, XY_Addr_s, I_RW_s, I_En_s, Clk_s, Rst_m);
	Sram_Result determinantM(Surf_Out_s, D_Data_s, D_Addr_s, O_RW_s, O_En_s, Clk_s, Rst_s);

	//clock procedure
	always begin
		Clk_s <= 1'b0; #(ClkPeriod/2);
		Clk_s <= 1'b1; #(ClkPeriod/2);
	end
	
	//Initialize Arrays
	initial $readmemh("integralImage.txt", integralImage.Memory);
	initial $readmemh("sw_result.txt", test_memory);
	initial $readmemh("Dx.txt", Dx.Memory);
	initial $readmemh("Dy.txt", Dy.Memory);
	initial $readmemh("Dxy.txt", Dxy.Memory);
	
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
		@(posedge Clk_s);
		/*for(J = 0; J < `DetMSize; J = J + 0) begin
			for(I = 0; I < `DetMSize; I = I + 1) begin
				if(determinantM.Memory[I] != 0) begin
					if(determinantM.Memory[I] != test_memory[J]) begin
						$display("Surf failed with %8x -- should equal to %8x", determinantM.Memory[I], test_memory[J]);
					end
					else begin
						$display("%d. Surf is %8x from HW -- It is equal to %8x from SW",I, determinantM.Memory[I], test_memory[J]);
						J = J + 1;
					end
					
				end
			end
		end*/
		
		for(I = 0; I < `DetMSize; I = I + 1) begin
			if(determinantM.Memory[I] !=0) begin
				if(determinantM.Memory[I] != test_memory[I]) begin
					$display("Surf failed with %8x -- should equal to %8x", determinantM.Memory[I], test_memory[I]);
				end
				else begin
					$display("%d. Surf is %8x from HW -- It is equal to %8x from SW",I, determinantM.Memory[I], test_memory[I]);	
				end
			end
		end
		$stop;
	end
endmodule
