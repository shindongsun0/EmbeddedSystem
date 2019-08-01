`include "define.h"
module Barrel_Shifter(SH_DIR, SH_AMT, D_IN, D_OUT);
	input SH_DIR;
	reg SH_EN_0, SH_EN_1, SH_EN_2, SH_EN_3, SH_EN_4;
	input [(`WIDTH-1):0] SH_AMT;
	input [(`WIDTH2-1):0] D_IN;

	wire [(`WIDTH2-1):0] D_OUT_0; 
	wire [(`WIDTH2-1):0] D_OUT_1;
	wire [(`WIDTH2-1):0] D_OUT_2;
	wire [(`WIDTH2-1):0] D_OUT_3;

	output [(`WIDTH2-1):0] D_OUT;
	

	shifter_1bit shifter_1bit_0 (SH_DIR, SH_EN_0, D_IN, D_OUT_0);
	shifter_2bit shifter_2bit_1 (SH_DIR, SH_EN_1, D_OUT_0, D_OUT_1);
	shifter_4bit shifter_4bit_2 (SH_DIR, SH_EN_2, D_OUT_1, D_OUT_2);
	shifter_8bit shifter_8bit_3 (SH_DIR, SH_EN_3, D_OUT_2, D_OUT_3);
	shifter_16bit shifter_16bit_4 (SH_DIR, SH_EN_4, D_OUT_3, D_OUT);

	always @(SH_DIR, SH_AMT, D_IN) begin
		SH_EN_0 <= SH_AMT[0];
		SH_EN_1 <= SH_AMT[1];
		SH_EN_2 <= SH_AMT[2];
		SH_EN_3 <= SH_AMT[3];
		SH_EN_4 <= SH_AMT[4];
		
	end
endmodule

