`timescale 1 ns/1 ns
`define Ac_WIDTH 17
`define Dc_WIDTH 16
module Sram_Result(Data_In, Data_Out, Addr, RW, En, Clk, Rst);
	input [(`Ac_WIDTH - 1):0]Addr;
	input RW;
	input En;
	input Clk;
	input Rst;
	input [15:0]Data_In;
	output reg [15:0]Data_Out;
	reg [(`Dc_WIDTH - 1):0] Memory [0 : (2**`Ac_WIDTH - 1)];
	integer Index;
	
	always @(posedge Clk) begin
		if (Rst == 1) begin
			for(Index=0; Index < (2**`Ac_WIDTH); Index = Index + 1)
				Memory[Index] <= `Dc_WIDTH'b0;
		end
		else if (En == 1'b1 && RW == 1'b1) //write operation
			Memory[Addr] <= Data_In;
		else if (En == 1'b1 && RW == 1'b0) //read
			Data_Out <= Memory[Addr];
	end
endmodule
