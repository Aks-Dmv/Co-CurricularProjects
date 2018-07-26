// Instruction Memory Design

module D_ff_IM(input clk, input reset, input d, output reg q);
	always@(reset or posedge clk)
	if(reset)
		q=d;
endmodule

module register_IM(input clk, input reset, input [15:0] d_in, output [15:0] q_out);
	D_ff_IM dIM0 (clk, reset, d_in[0], q_out[0]);
	D_ff_IM dIM1 (clk, reset, d_in[1], q_out[1]);
	D_ff_IM dIM2 (clk, reset, d_in[2], q_out[2]);
	D_ff_IM dIM3 (clk, reset, d_in[3], q_out[3]);
	D_ff_IM dIM4 (clk, reset, d_in[4], q_out[4]);
	D_ff_IM dIM5 (clk, reset, d_in[5], q_out[5]);
	D_ff_IM dIM6 (clk, reset, d_in[6], q_out[6]);
	D_ff_IM dIM7 (clk, reset, d_in[7], q_out[7]);
	D_ff_IM dIM8 (clk, reset, d_in[8], q_out[8]);
	D_ff_IM dIM9 (clk, reset, d_in[9], q_out[9]);
	D_ff_IM dIM10 (clk, reset, d_in[10], q_out[10]);
	D_ff_IM dIM11 (clk, reset, d_in[11], q_out[11]);
	D_ff_IM dIM12 (clk, reset, d_in[12], q_out[12]);
	D_ff_IM dIM13 (clk, reset, d_in[13], q_out[13]);
	D_ff_IM dIM14 (clk, reset, d_in[14], q_out[14]);
	D_ff_IM dIM15 (clk, reset, d_in[15], q_out[15]);
endmodule

module mux32to1_IM(input [15:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15,
	outR16,outR17,outR18,outR19,outR20,outR21,outR22,outR23,outR24,outR25,outR26,outR27,outR28,outR29,outR30,outR31,
	input [4:0] Sel, output reg [31:0] outBus );
	
	always@(outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15,
		outR16,outR17,outR18,outR19,outR20,outR21,outR22,outR23,outR24,outR25,outR26,outR27,outR28,outR29,outR30,outR31,
		Sel)
		case (Sel)
			5'd0: outBus = {outR1,outR0};
			5'd1: outBus = {outR2,outR1};
			5'd2: outBus = {outR3,outR2};
			5'd3: outBus = {outR4,outR3};
			5'd4: outBus = {outR5,outR4};
			5'd5: outBus = {outR6,outR5};
			5'd6: outBus = {outR7,outR6};
			5'd7: outBus = {outR8,outR7};
			5'd8: outBus = {outR9,outR8};
			5'd9: outBus = {outR10,outR9};
			5'd10: outBus = {outR11,outR10};
			5'd11: outBus = {outR12,outR11};
			5'd12: outBus = {outR13,outR12};
			5'd13: outBus = {outR14,outR13};
			5'd14: outBus = {outR15,outR14};
			5'd15: outBus = {outR16,outR15};
			5'd16: outBus = {outR17,outR16};
			5'd17: outBus = {outR18,outR17};
			5'd18: outBus = {outR19,outR18};
			5'd19: outBus = {outR20,outR19};
			5'd20: outBus = {outR21,outR20};
			5'd21: outBus = {outR22,outR21};
			5'd22: outBus = {outR23,outR22};
			5'd23: outBus = {outR24,outR23};
			5'd24: outBus = {outR25,outR24};
			5'd25: outBus = {outR26,outR25};
			5'd26: outBus = {outR27,outR26};
			5'd27: outBus = {outR28,outR27};
			5'd28: outBus = {outR29,outR28};
			5'd29: outBus = {outR30,outR29};
			5'd30: outBus = {outR31,outR30};
			5'd31: outBus = {32'b0,outR31};
		endcase
endmodule

module IM(input clk, input reset, input [4:0] pc_5bits, output [31:0] IR);
	wire [15:0] Qout0, Qout1, Qout2, Qout3, Qout4, Qout5, Qout6, Qout7,
					Qout8, Qout9, Qout10, Qout11, Qout12, Qout13, Qout14, Qout15,
					Qout16, Qout17, Qout18, Qout19, Qout20, Qout21, Qout22, Qout23,
					Qout24, Qout25, Qout26, Qout27, Qout28, Qout29, Qout30, Qout31;
	register_IM rIM0 (clk, reset, 16'h00ED, Qout0); // c.addi $1, 1B
	register_IM rIM1 (clk, reset, 16'h0637, Qout1); // lui  0F300, $12
	register_IM rIM2 (clk, reset, 16'h0F30, Qout2);
	register_IM rIM3 (clk, reset, 16'h36EF, Qout3); // j 3, $11
	register_IM rIM4 (clk, reset, 16'h0000, Qout4);
	register_IM rIM5 (clk, reset, 16'h8092, Qout5); // c.mv $1, $5
	register_IM rIM6 (clk, reset, 16'h8486, Qout6); // c.mv $1, $9
	register_IM rIM7 (clk, reset, 16'h0233, Qout7); // sub $12, $9, $4
	register_IM rIM8 (clk, reset, 16'h4096, Qout8);
	register_IM rIM9 (clk, reset, 16'h5193, Qout9); // srai $4, 5, $3 
	register_IM rIM10 (clk, reset, 16'h4042, Qout10); 	
	register_IM rIM11 (clk, reset, 16'h6233, Qout11); // or $12, $3, $4
	register_IM rIM12 (clk, reset, 16'h0036, Qout12); 
	register_IM rIM13 (clk, reset, 16'h7513, Qout13); // andi $4, B6B, $10
	register_IM rIM14 (clk, reset, 16'hB6B2, Qout14); 	
	register_IM rIM15 (clk, reset, 16'h0000, Qout15);
	register_IM rIM16 (clk, reset, 16'h0000, Qout16);
	register_IM rIM17 (clk, reset, 16'h0000, Qout17);
	register_IM rIM18 (clk, reset, 16'h0000, Qout18);
	register_IM rIM19 (clk, reset, 16'h0000, Qout19);
	register_IM rIM20 (clk, reset, 16'h0000, Qout20);
	register_IM rIM21 (clk, reset, 16'h0000, Qout21);
	register_IM rIM22 (clk, reset, 16'h0000, Qout22);
	register_IM rIM23 (clk, reset, 16'h0000, Qout23);
	register_IM rIM24 (clk, reset, 16'h0000, Qout24);
	register_IM rIM25 (clk, reset, 16'h0000, Qout25); 		
	register_IM rIM26 (clk, reset, 16'h0000, Qout26); 	
	register_IM rIM27 (clk, reset, 16'h0000, Qout27); 	
	register_IM rIM28 (clk, reset, 16'h0000, Qout28); 
	register_IM rIM29 (clk, reset, 16'h0000, Qout29); 
	register_IM rIM30 (clk, reset, 16'h0000, Qout30); 	
	register_IM rIM31 (clk, reset, 16'h0000, Qout31); 		
	mux32to1_IM mIM (Qout0,Qout1,Qout2,Qout3,Qout4,Qout5,Qout6,Qout7,Qout8,Qout9,Qout10,Qout11,Qout12,Qout13,Qout14,Qout15,
		Qout16,Qout17,Qout18,Qout19,Qout20,Qout21,Qout22,Qout23,Qout24,Qout25,Qout26,Qout27,Qout28,Qout29,Qout30,Qout31,
		pc_5bits[4:0],IR);
endmodule

//Instruction Memory Design Ends

// Register Memory Starts

module D_ff_reg(input clk, input reset, input regWrite, input decOut1b , input d, output reg q);
	always @ (negedge clk)
	begin
	if(reset==1)
		q=0;
	else
		if(regWrite == 1 && decOut1b==1)
		begin
			q=d;
		end
	end
endmodule

module register32bit(input clk, input reset, input writeLow, input writeHigh, input decOut1b, input [31:0] writeData, output  [31:0] outR);

	D_ff_reg d0(clk, reset, writeLow, decOut1b, writeData[0], outR[0]);
	D_ff_reg d1(clk, reset, writeLow, decOut1b, writeData[1], outR[1]);
	D_ff_reg d2(clk, reset, writeLow, decOut1b, writeData[2], outR[2]);
	D_ff_reg d3(clk, reset, writeLow, decOut1b, writeData[3], outR[3]);
	D_ff_reg d4(clk, reset, writeLow, decOut1b, writeData[4], outR[4]);
	D_ff_reg d5(clk, reset, writeLow, decOut1b, writeData[5], outR[5]);
	D_ff_reg d6(clk, reset, writeLow, decOut1b, writeData[6], outR[6]);
	D_ff_reg d7(clk, reset, writeLow, decOut1b, writeData[7], outR[7]);
	D_ff_reg d8(clk, reset, writeLow, decOut1b, writeData[8], outR[8]);
	D_ff_reg d9(clk, reset, writeLow, decOut1b, writeData[9], outR[9]);
	D_ff_reg d10(clk, reset, writeLow, decOut1b, writeData[10], outR[10]);
	D_ff_reg d11(clk, reset, writeLow, decOut1b, writeData[11], outR[11]);
	D_ff_reg d12(clk, reset, writeLow, decOut1b, writeData[12], outR[12]);
	D_ff_reg d13(clk, reset, writeLow, decOut1b, writeData[13], outR[13]);
	D_ff_reg d14(clk, reset, writeLow, decOut1b, writeData[14], outR[14]);
	D_ff_reg d15(clk, reset, writeLow, decOut1b, writeData[15], outR[15]);
	D_ff_reg d16(clk, reset, writeHigh, decOut1b, writeData[16], outR[16]);
	D_ff_reg d17(clk, reset, writeHigh, decOut1b, writeData[17], outR[17]);
	D_ff_reg d18(clk, reset, writeHigh, decOut1b, writeData[18], outR[18]);
	D_ff_reg d19(clk, reset, writeHigh, decOut1b, writeData[19], outR[19]);
	D_ff_reg d20(clk, reset, writeHigh, decOut1b, writeData[20], outR[20]);
	D_ff_reg d21(clk, reset, writeHigh, decOut1b, writeData[21], outR[21]);
	D_ff_reg d22(clk, reset, writeHigh, decOut1b, writeData[22], outR[22]);
	D_ff_reg d23(clk, reset, writeHigh, decOut1b, writeData[23], outR[23]);
	D_ff_reg d24(clk, reset, writeHigh, decOut1b, writeData[24], outR[24]);
	D_ff_reg d25(clk, reset, writeHigh, decOut1b, writeData[25], outR[25]);
	D_ff_reg d26(clk, reset, writeHigh, decOut1b, writeData[26], outR[26]);
	D_ff_reg d27(clk, reset, writeHigh, decOut1b, writeData[27], outR[27]);
	D_ff_reg d28(clk, reset, writeHigh, decOut1b, writeData[28], outR[28]);
	D_ff_reg d29(clk, reset, writeHigh, decOut1b, writeData[29], outR[29]);
	D_ff_reg d30(clk, reset, writeHigh, decOut1b, writeData[30], outR[30]);
	D_ff_reg d31(clk, reset, writeHigh, decOut1b, writeData[31], outR[31]);
	
endmodule

module registerSet(input clk, input reset, input writeLow, input writeHigh, input [15:0] decOut, input [31:0] writeData,
	output [31:0] outR0, output [31:0] outR1, output [31:0] outR2, output [31:0] outR3,
	output [31:0] outR4, output [31:0] outR5, output [31:0] outR6, output [31:0] outR7,
	output [31:0] outR8, output [31:0] outR9, output [31:0] outR10, output [31:0] outR11,
	output [31:0] outR12, output [31:0] outR13, output [31:0] outR14, output [31:0] outR15);

	register32bit register0(clk, reset, writeLow, writeHigh, decOut[0], writeData, outR0);
	register32bit register1(clk, reset, writeLow, writeHigh, decOut[1], writeData, outR1);
	register32bit register2(clk, reset, writeLow, writeHigh, decOut[2], writeData, outR2);
	register32bit register3(clk, reset, writeLow, writeHigh, decOut[3], writeData, outR3);
	register32bit register4(clk, reset, writeLow, writeHigh, decOut[4], writeData, outR4);
	register32bit register5(clk, reset, writeLow, writeHigh, decOut[5], writeData, outR5);
	register32bit register6(clk, reset, writeLow, writeHigh, decOut[6], writeData, outR6);
	register32bit register7(clk, reset, writeLow, writeHigh, decOut[7], writeData, outR7);
	register32bit register8(clk, reset, writeLow, writeHigh, decOut[8], writeData, outR8);
	register32bit register9(clk, reset, writeLow, writeHigh, decOut[9], writeData, outR9);
	register32bit register10(clk, reset, writeLow, writeHigh, decOut[10], writeData, outR10);
	register32bit register11(clk, reset, writeLow, writeHigh, decOut[11], writeData, outR11);
	register32bit register12(clk, reset, writeLow, writeHigh, decOut[12], writeData, outR12);
	register32bit register13(clk, reset, writeLow, writeHigh, decOut[13], writeData, outR13);
	register32bit register14(clk, reset, writeLow, writeHigh, decOut[14], writeData, outR14);
	register32bit register15(clk, reset, writeLow, writeHigh, decOut[15], writeData, outR15);
	
endmodule

module decoder4to16(input [3:0] destReg, output reg [15:0] decOut);
	always @(destReg)
		case(destReg)
			4'd0: decOut=16'b0000_0000_0000_0001;
			4'd1: decOut=16'b0000_0000_0000_0010;
			4'd2: decOut=16'b0000_0000_0000_0100;
			4'd3: decOut=16'b0000_0000_0000_1000;
			4'd4: decOut=16'b0000_0000_0001_0000;
			4'd5: decOut=16'b0000_0000_0010_0000;
			4'd6: decOut=16'b0000_0000_0100_0000;
			4'd7: decOut=16'b0000_0000_1000_0000;
			4'd8: decOut=16'b0000_0001_0000_0000;
			4'd9: decOut=16'b0000_0010_0000_0000;
			4'd10: decOut=16'b0000_0100_0000_0000;
			4'd11: decOut=16'b0000_1000_0000_0000;
			4'd12: decOut=16'b0001_0000_0000_0000;
			4'd13: decOut=16'b0010_0000_0000_0000;
			4'd14: decOut=16'b0100_0000_0000_0000;
			4'd15: decOut=16'b1000_0000_0000_0000;
		endcase
endmodule

module mux16to1(input [31:0] outR0, input [31:0] outR1, input [31:0] outR2, input [31:0] outR3,
	input [31:0] outR4, input [31:0] outR5, input [31:0] outR6, input [31:0] outR7,
	input [31:0] outR8, input [31:0] outR9, input [31:0] outR10, input [31:0] outR11,
	input [31:0] outR12, input [31:0] outR13, input [31:0] outR14, input [31:0] outR15,
	input [3:0] Sel, output reg [31:0] outBus);

	always@(outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15,Sel)
		case(Sel)
			4'd0:outBus=outR0;
			4'd1:outBus=outR1;
			4'd2:outBus=outR2;
			4'd3:outBus=outR3;
			4'd4:outBus=outR4;
			4'd5:outBus=outR5;
			4'd6:outBus=outR6;
			4'd7:outBus=outR7;
			4'd8:outBus=outR8;
			4'd9:outBus=outR9;
			4'd10:outBus=outR10;
			4'd11:outBus=outR11;
			4'd12:outBus=outR12;
			4'd13:outBus=outR13;
			4'd14:outBus=outR14;
			4'd15:outBus=outR15;
		endcase
endmodule

module mux2to1_16bits(input [15:0] in0, input [15:0] in1, input Sel, output reg [15:0] outBus);
	always@(in0,in1,Sel)
		case(Sel)
			1'd0:outBus=in0;
			1'd1:outBus=in1;
		endcase
endmodule

module busOutput(input [31:0] reg_rx, input mode, input rx3, output [31:0] rxOut);
	reg lowSelect;
	mux2to1_16bits m0(16'b0, reg_rx[31:16], mode, rxOut[31:16]);
	mux2to1_16bits m1(16'b0, reg_rx[15:0], lowSelect, rxOut[15:0]);
	always @ (mode,rx3)
		begin
			lowSelect = ~rx3 | mode;
		end
endmodule

module registerFile(input clk, input reset, input regWrite, input mode, input [4:0] rs, input [4:0] rt,input [4:0] rd, 
input [31:0] writeData, output [31:0] rsOut, output [31:0] rtOut);
	wire [15:0] decOut;
	wire [31:0] outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7, outR8, outR9, outR10, outR11, outR12, outR13, outR14, outR15;
	reg writeLow, writeHigh;
	wire [31:0] regRs, regRt;
	
	decoder4to16 d1(rd[3:0],decOut);
	registerSet rSet(clk, reset, writeLow, writeHigh, decOut, writeData,
		outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7, outR8, outR9, outR10, outR11, outR12, outR13, outR14, outR15);
	mux16to1 m0(outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7, outR8, outR9, outR10, outR11, outR12, outR13, outR14, outR15, rs[3:0], regRs);
	mux16to1 m1(outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7, outR8, outR9, outR10, outR11, outR12, outR13, outR14, outR15, rt[3:0], regRt);
	busOutput bo0(regRs, mode, rs[3], rsOut);
	busOutput bo1(regRt, mode, rt[3], rtOut);
	
	always @ (mode, regWrite, rd[3])
		begin
			writeLow = (mode | ~rd[3]) & regWrite;
			writeHigh = regWrite & mode;
		end		
endmodule


// Register Memory Ends

module ctrlCkt(input [6:0] opcode, input [2:0] funct3_32,
	output reg [2:0] aluOp, output reg [1:0] aluSrcB, output reg [1:0] toReg, output reg regWrite, output reg jump);
	
	always @ (opcode, funct3_32)
		begin
			aluOp = 3'b000; aluSrcB = 2'b00; toReg = 2'b00; regWrite = 1'b0; jump = 1'b0;
			if(opcode[1:0] == 2'b11)
				begin
					case(opcode[6:2])
						// sub/or
						5'b01100:
							case(funct3_32)
								// sub (funct7 not needed)
								3'b000:
									begin
										aluSrcB = 2'b00;
										aluOp = 3'b001;
										toReg = 2'b00;
										regWrite = 1'b1;
										jump = 1'b0;
									end
								// or
								3'b110:
									begin
										aluSrcB = 2'b00;
										aluOp = 3'b010;
										toReg = 2'b00;
										regWrite = 1'b1;
										jump = 1'b0;
									end
							endcase
						// andi/srai
						5'b00100:
							case(funct3_32)
								// andi
								3'b111:
									begin
										aluSrcB = 2'b01;
										aluOp = 3'b011;
										toReg = 2'b00;
										regWrite = 1'b1;
										jump = 1'b0;
									end
								// srai
								3'b101:
									begin
										aluSrcB = 2'b10;
										aluOp = 3'b100;
										toReg = 2'b00;
										regWrite = 1'b1;
										jump = 1'b0;
									end
							endcase
						// lui
						5'b01101:
							begin
								aluSrcB = 2'b00;
								aluOp = 3'b000;
								toReg = 2'b10;
								regWrite = 1'b1;
								jump = 1'b0;
							end
						// j
						5'b11011:
							begin
								aluSrcB = 2'b00;
								aluOp = 3'b000;
								toReg = 2'b00;
								regWrite = 1'b0;
								jump = 1'b1;
							end
					endcase
				end
			else
				case(opcode[1:0])
					// c.addi
					2'b01:
						begin
							aluSrcB = 2'b11;
							aluOp = 3'b000;
							toReg = 2'b00;
							regWrite = 1'b1;
							jump = 1'b0;
						end
					// c.mv
					2'b10:
						begin
							aluSrcB = 2'b00;
							aluOp = 3'b000;
							toReg = 2'b01;
							regWrite = 1'b1;
							jump = 1'b0;
						end
				endcase
		end
	
endmodule

module ALU(input signed [31:0] aluIn1, input signed [31:0] aluIn2, input [2:0] aluOp, output reg [31:0] aluOut);
	always@(aluIn1 or aluIn2 or aluOp)
	begin
		case(aluOp)
			3'd0: aluOut = aluIn1 + aluIn2;
			3'd1:	aluOut = aluIn1 - aluIn2;
			3'd2: aluOut = aluIn1 | aluIn2;
			3'd3: aluOut = aluIn1 & aluIn2;
			3'd4: aluOut = aluIn1 >>> aluIn2;
		endcase
	end
endmodule

module signExt12to32(input [11:0] in, output reg [31:0] signExtin);
	always@(in)
		signExtin={{20{in[11]}},in};
endmodule

module zeroExt5to32(input [4:0] in, output reg [31:0] zeroExtin);
	always@(in)
		zeroExtin={27'b0,in};
endmodule

module signExt20to32(input [19:0] in, output reg [31:0] signExtin);
	always@(in)
		signExtin={{12{in[19]}},in};
endmodule

module signExt6to32(input [5:0] in, output reg [31:0] signExtin);
	always@(in)
		signExtin={{26{in[5]}},in};
endmodule

module mux2to1_32bits(input [31:0] in0, input [31:0] in1, input sel, output reg [31:0] muxOut);
    always@(in0, in1, sel)
		begin
			case(sel)
				1'b0: muxOut=in0;
				1'b1: muxOut=in1;
			endcase
		end
endmodule

module mux4to1_32bits(input [31:0] in0, input [31:0] in1, input [31:0] in2, input [31:0] in3, input [1:0] sel, output reg [31:0] muxOut);
    always@(in0, in1, in2, in3, sel)
		begin
			case(sel)
				2'd0: muxOut=in0;
				2'd1: muxOut=in1;
				2'd2: muxOut=in2;
				2'd3: muxOut=in3;
			endcase
		end
endmodule

module D_ff(input clk, input reset, input regWrite, input d, output reg q);
	always@(negedge clk)
		begin
			if(reset)
				q=0;
			else
				if(regWrite == 1) begin q=d; end
		end
endmodule

module register32bit_PC(input clk, input reset, input regWrite, input [31:0] writeData, output  [31:0] outR);
	D_ff d0(clk,reset,regWrite,writeData[0],outR[0]);
	D_ff d1(clk,reset,regWrite,writeData[1],outR[1]);
	D_ff d2(clk,reset,regWrite,writeData[2],outR[2]);
	D_ff d3(clk,reset,regWrite,writeData[3],outR[3]);
	D_ff d4(clk,reset,regWrite,writeData[4],outR[4]);
	D_ff d5(clk,reset,regWrite,writeData[5],outR[5]);
	D_ff d6(clk,reset,regWrite,writeData[6],outR[6]);
	D_ff d7(clk,reset,regWrite,writeData[7],outR[7]);
	D_ff d8(clk,reset,regWrite,writeData[8],outR[8]);
	D_ff d9(clk,reset,regWrite,writeData[9],outR[9]);
	D_ff d10(clk,reset,regWrite,writeData[10],outR[10]);
	D_ff d11(clk,reset,regWrite,writeData[11],outR[11]);
	D_ff d12(clk,reset,regWrite,writeData[12],outR[12]);
	D_ff d13(clk,reset,regWrite,writeData[13],outR[13]);
	D_ff d14(clk,reset,regWrite,writeData[14],outR[14]);
	D_ff d15(clk,reset,regWrite,writeData[15],outR[15]);
	D_ff d16(clk,reset,regWrite,writeData[16],outR[16]);
	D_ff d17(clk,reset,regWrite,writeData[17],outR[17]);
	D_ff d18(clk,reset,regWrite,writeData[18],outR[18]);
	D_ff d19(clk,reset,regWrite,writeData[19],outR[19]);
	D_ff d20(clk,reset,regWrite,writeData[20],outR[20]);
	D_ff d21(clk,reset,regWrite,writeData[21],outR[21]);
	D_ff d22(clk,reset,regWrite,writeData[22],outR[22]);
	D_ff d23(clk,reset,regWrite,writeData[23],outR[23]);
	D_ff d24(clk,reset,regWrite,writeData[24],outR[24]);
	D_ff d25(clk,reset,regWrite,writeData[25],outR[25]);
	D_ff d26(clk,reset,regWrite,writeData[26],outR[26]);
	D_ff d27(clk,reset,regWrite,writeData[27],outR[27]);
	D_ff d28(clk,reset,regWrite,writeData[28],outR[28]);
	D_ff d29(clk,reset,regWrite,writeData[29],outR[29]);
	D_ff d30(clk,reset,regWrite,writeData[30],outR[30]);
	D_ff d31(clk,reset,regWrite,writeData[31],outR[31]);
endmodule

module mux2to1_5bits(input [4:0] in0, input [4:0] in1, input sel, output reg [4:0] muxOut);
    always@(in0, in1, sel)
		begin
			case(sel)
				1'b0: muxOut=in0;
				1'b1: muxOut=in1;
			endcase
		end
endmodule

module pc_adder(input [31:0] in1, input [31:0] in2, output reg [31:0] adder_out);
	always@(in1 or in2)
	begin
		adder_out = in1 + in2;
	end
endmodule

module singleCycle(input clk, input reset, output [31:0] Result);
	
	//Write your code here
	
endmodule

module testbench;
	reg clk;
	reg reset;
	wire [31:0] Result;
	singleCycle SC(clk, reset, Result);

	always
	#5 clk=~clk;
	
	initial
	begin
		clk=0; reset=1;
		#5  reset=0;	
		#75 $finish;
	end
endmodule
