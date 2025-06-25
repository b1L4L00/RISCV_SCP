module dataPath(clk, rst,instr, RegWrite, ALUControl, ResultSrc,MemWrite, ALUSrc, immSrc, zero, immediate);
input [31:0] instr;
input clk, rst;
input RegWrite, MemWrite, ALUSrc, ResultSrc;
input [1:0]immSrc;
input [2:0] ALUControl;
output zero;
output [31:0] immediate;
wire[4:0] A1 ;
wire[4:0] A2 ;
wire [4:0] A3; 
wire [31:0] WD3, RD1, RD2 ,  RD, SrcB,aluOut , pc;
wire   carry, negative, overflow;

assign SrcB = ALUSrc?immediate:RD2;
assign WD3 = ResultSrc ? RD : aluOut;

assign A1 = instr[19:15];
assign A2 = instr[24:20];
assign  A3 = instr [11:7];

registerFile regFile(.clk(clk),.rst(rst),.A1(A1),.A2(A2),.A3(A3),.WE(RegWrite),.WD3(WD3), .RD1(RD1), .RD2(RD2));
signExtension imm(.instr(instr), .immSrc(immSrc), . imm_out(immediate));
alu ALU(.A(RD1),.B(SrcB), .ALUControl(ALUControl), .Result(aluOut), .zero(zero), .carry(carry), .negative(negative) , .overflow(overflow));
dataMemory   dataMem(.clk(clk), .rst(rst), .WE(MemWrite), .A(aluOut),.WD(RD2), .RD(RD));
endmodule

module signExtension(
    input   [31:0] instr,
    input   [1:0] immSrc,
    output reg [31:0] imm_out
);
always @(*) begin
     case (immSrc)
        2'b00: imm_out ={{20{instr[31]}}, instr[31:20]};
        2'b01: imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]}; 
        2'b10: imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; 
        default: ;
    endcase
end

endmodule