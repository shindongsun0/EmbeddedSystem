`include "define.h"
module shifter_16bit(SH_DIR, SH_EN, D_IN, D_OUT);

	input SH_DIR;
	input SH_EN;
	input [(`WIDTH2-1):0] D_IN;
	wire [(`WIDTH2-1):0] D_OUT_before;
	output [(`WIDTH2-1):0] D_OUT;

	shifter_8bit shifter_8bit_1 (SH_DIR, SH_EN, D_IN, D_OUT_before);
	shifter_8bit shifter_8bit_2 (SH_DIR, SH_EN, D_OUT_before, D_OUT);
	
endmodule
