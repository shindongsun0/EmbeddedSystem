`timescale 1 ns/1 ns

module Testbench();
	
	reg [12:0] Index;
	reg [12:0] Correct_Index;
	reg Start_s, Red_s, Green_s, Blue_s;
	reg Clk_s, Rst_s;
	wire U_s;
	
	Code_Detector CompToTest(Start_s, Red_s, Green_s, Blue_s, Clk_s, Rst_s, U_s);
	
	//Clock Procedure
	always begin
		Clk_s <= 0;
		#10;
		Clk_s <= 1;
		#10;
	end

	//Vector Procedure
	initial begin
		Rst_s <= 1;
		Start_s <= 0;
		//@ (posedge Clk_s);
		for (Index = 0; Index <4096; Index = Index + 1)
		begin
			@ (posedge Clk_s);
			Rst_s <= 0;
			Start_s <= 1;
			@ (posedge Clk_s);
			Start_s <= 0;
			
			Red_s <= Index[2];
			Green_s <= Index[1];
			Blue_s <= Index[0];
			

			@ (posedge Clk_s);
			Red_s <= Index[5];
			Green_s <= Index[4];
			Blue_s <= Index[3];

			@ (posedge Clk_s);
			Red_s <= Index[8];
			Green_s <= Index[7];
			Blue_s <= Index[6];

			@ (posedge Clk_s);
			Red_s <= Index[11];
			Green_s <= Index[10];
			Blue_s <= Index[9];
		
			@ (posedge Clk_s);
			#5;
			if (U_s != 1)
				$display ("# %4d: %3b_%3b_%3b_%3b is incorrect!", Index, Index[11:9], Index[8:6], Index[5:3], Index[2:0]);
			else
				begin
					Correct_Index <= Index;
					$display ("# %4d: %3b_%3b_%3b_%3b is correct!", Index, Index[11:9], Index[8:6], Index[5:3], Index[2:0]);
				end	
		end
		
		$display ("# %4d: %3b_%3b_%3b_%3b is correct!", Correct_Index, Correct_Index[11:9], Correct_Index[8:6], Correct_Index[5:3], Correct_Index[2:0]);
		$stop;
	end
endmodule
