`include "define.h"
module shifter_8bit(SH_DIR, SH_EN, D_IN, D_OUT);

	input SH_DIR;
	input SH_EN;
	input [(`WIDTH2-1):0] D_IN;
	wire [(`WIDTH2-1):0] D_OUT_before;
	output [(`WIDTH2-1):0] D_OUT;

	shifter_4bit shifter_4bit_1 (SH_DIR, SH_EN, D_IN, D_OUT_before);
	shifter_4bit shifter_4bit_2 (SH_DIR, SH_EN, D_OUT_before, D_OUT);
	
endmodule
