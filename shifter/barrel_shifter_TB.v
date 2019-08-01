`timescale 1 ns/1 ns
`include "define.h"
module Testbench();
	
	reg SH_DIR_s;
	reg [(`WIDTH-1):0] SH_AMT_s;
	reg [(`WIDTH2-1):0] D_IN_s;
	wire [(`WIDTH2-1):0]D_OUT_s;
	
	integer Index;
	
	Barrel_Shifter CompToTest(SH_DIR_s, SH_AMT_s, D_IN_s, D_OUT_s);
	

	//Vector Procedure
	initial begin
		//Shift-Right Operation Test with Negative Value!
		$display("# 1.Shift-Right Operation Test with Negative Value!");
		for(Index = 0; Index < 32; Index = Index + 1) begin
			SH_DIR_s <= 1;
			D_IN_s <= 32'b1000_0000_0000_0000_0000_0000_0000_0000;
			SH_AMT_s <= Index;
			#5 $display("# shift-right with amount %2d is %32b",  Index, D_OUT_s);
		end
		
		$display("# 2.Shift-Right Operation Test with Positive Value!");
		for(Index = 0; Index < 32; Index = Index + 1) begin
			SH_DIR_s <= 1;
			D_IN_s <= 32'b0100_0000_0000_0000_0000_0000_0000_0000;
			SH_AMT_s <= Index;
			#5 $display("# shift-right with amount %2d is %32b",  Index, D_OUT_s);
		end
		
		$display("# 3.Shift-Left Operation Test with Number 1!");
		for(Index = 0; Index < 32; Index = Index + 1) begin
			SH_DIR_s <= 0;
			D_IN_s <= 32'b0000_0000_0000_0000_0000_0000_0000_0001;
			SH_AMT_s <= Index;
			#5 $display("# shift-left with amount %2d is %32b", Index, D_OUT_s);
		end
	end
endmodule
