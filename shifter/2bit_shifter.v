`include "define.h"
module shifter_2bit(SH_DIR, SH_EN, D_IN, D_OUT);

	input SH_DIR;
	input [(`WIDTH2-1):0] D_IN;
	input SH_EN;
	wire [(`WIDTH2-1):0] D_OUT_before;
	output [(`WIDTH2-1):0] D_OUT;

	shifter_1bit shifter_1bit_1 (SH_DIR, SH_EN, D_IN, D_OUT_before);
	shifter_1bit shifter_1bit_2 (SH_DIR, SH_EN, D_OUT_before, D_OUT);
	
endmodule
