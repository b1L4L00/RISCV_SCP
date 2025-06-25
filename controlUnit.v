module controlUnit(
    input [6:0] opCode,
    input [2:0] funct3,
    input [6:0] funct7,
    input zero,
    output RegWrite, ALUSrc, MemWrite, ResultSrc, PCSrc,
    output [1:0] ImmSrc,
    output [2:0] ALUControl
);
    wire [1:0] ALUOp;

    mainDecoder decoder(
        .opCode(opCode),
        .zero(zero),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .PCSrc(PCSrc),
        .ALUOp(ALUOp)
    );

    ALU_Decoder alu_decoder(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7[5]),
        .op5(opCode[5]),
        .ALUControl(ALUControl)
    );
endmodule

module mainDecoder(opCode, zero, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, PCSrc, ALUOp);
input[6:0] opCode;
input zero;
output reg RegWrite, ALUSrc, MemWrite, ResultSrc, PCSrc;
output reg [1:0] ImmSrc, ALUOp;

localparam lw =7'b0000011, sw = 7'b0100011, R_Type = 7'b0110011, beq = 7'b1100011 ;
always @(*) begin
    case (opCode)
        lw:begin
            RegWrite = 1'b1;
            ImmSrc = 2'b00;
            ALUSrc = 1'b1;
            MemWrite = 1'b0;
            ResultSrc = 1'b1;
            PCSrc = 1'b0;
            ALUOp = 2'b00;
            end 
        sw:begin
            RegWrite = 1'b0;
            ImmSrc = 2'b01;
            ALUSrc = 1'b1;
            MemWrite = 1'b1;
            ResultSrc = 1'bx;
            PCSrc = 1'b0;
            ALUOp = 2'b00;
            end 
        R_Type:begin
            RegWrite = 1'b1;
            ImmSrc = 2'bx;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
            PCSrc = 1'b0;
            ALUOp = 2'b10;
        end 
        beq:begin
            RegWrite = 1'b0;
            ImmSrc = 2'b10;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'bx;
            PCSrc = zero;
            ALUOp = 2'b01;
            end 
        default: begin
            RegWrite = 1'b0;
            ImmSrc = 2'b0;
            ALUSrc = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
            PCSrc = 1'b0;
            ALUOp = 2'b0; 
         end
    endcase
end
endmodule

module ALU_Decoder(ALUOp, op5, funct3, funct7, ALUControl);
input[1:0] ALUOp;
input [2:0] funct3;
input op5, funct7;
output reg [2:0] ALUControl;
always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 3'b000;
        2'b01:ALUControl= 3'b001;
        2'b10: begin
            case (funct3)
                3'b000:begin
                    ALUControl= ({op5,funct7} == 2'b11)?3'b001: 3'b000;
                end 
                3'b010: ALUControl  = 3'b010;
                3'b110: ALUControl =   3'b011;
                3'b111: ALUControl = 3'b010;
                default:  ALUControl  = 3'bx;
            endcase
        end
        default: ALUControl = 3'bx;
    endcase
end
endmodule