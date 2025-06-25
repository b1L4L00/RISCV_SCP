module SCP(clk, rst);
input clk, rst;
wire RegWrite, MemWrite, ALUSrc, ResultSrc, PCSrc, zero;
wire [1:0]immSrc;
wire [2:0] ALUControl;

wire [31:0] pc, next_pc,instr, immediate;
assign next_pc = PCSrc?(pc+(immediate<<1)): pc+4;

 nextPC  programcntr(
    .clk(clk),
    .reset(rst),
     .next_pc(next_pc),  // Next PC value from control logic
     .pc(pc)        // Current PC value
);
instructionMem instrmem(.address(pc), .dataOut(instr) , .rst(rst));

 controlUnit ctrU(
    .opCode(instr[6:0]),
    .funct3(instr[14:12]),
    .funct7(instr[31:25]),
    .zero(zero),
    .RegWrite(RegWrite), .ALUSrc(ALUSrc), .MemWrite(MemWrite), .ResultSrc(ResultSrc), .PCSrc(PCSrc),
    .ImmSrc(immSrc),
    .ALUControl(ALUControl)
);
dataPath datapath(.clk(clk), .rst(rst),.instr(instr), .RegWrite(RegWrite), .ALUControl(ALUControl), .ResultSrc(ResultSrc)
                  ,.MemWrite(MemWrite), .ALUSrc(ALUSrc), .immSrc(immSrc), .zero(zero), .immediate(immediate));

endmodule