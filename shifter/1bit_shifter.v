`include "define.h"
module shifter_1bit(SH_DIR, SH_EN, D_IN, D_OUT);
	
	input SH_DIR;
	input SH_EN;
	input [(`WIDTH2-1):0]D_IN;
	output [(`WIDTH2-1):0]D_OUT;
	reg [(`WIDTH2-1):0] D_OUT;

	//integer Index_1;
	
	always @(SH_DIR, SH_EN, D_IN) begin
		if(SH_EN == 1) begin
			if(SH_DIR == 0) //Shift Left
				D_OUT <= D_IN * 2;
			else //Shift Right
				begin
					if(D_IN[31] == 0) // MSB is 0
						D_OUT <= D_IN / 2;
					else // MSB is 1
						D_OUT <= ~((~D_IN) / 2);
				end
			end
		else
			D_OUT <= D_IN;
		end
endmodule
