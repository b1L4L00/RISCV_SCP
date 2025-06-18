module alu(A,B, ALUControl, Result, zero, carry, negative , overflow);
//
input [31:0] A,B;
input [2:0] ALUControl;
output reg [31:0] Result;
output zero, carry, negative, overflow;
wire [31:0] a_and_b;
wire [31:0] a_or_b ;
wire [31:0] not_b;
wire[31:0] a_sum_b;
wire[31:0] ALU_mux = ALUControl[0] ? not_b : B;
wire [31:0] ALU_mux2;
wire cout;
wire[31:0] slt = {31'b0,a_sum_b[31]};
assign not_b= ~B;

assign a_and_b = A&B;

assign a_or_b = A|B;

assign {cout, a_sum_b} = A+ALU_mux+ALUControl[0];

always @(*) begin
    case (ALUControl[2:0])
        3'b000: Result = a_sum_b;
        3'b001: Result = a_sum_b;
        3'b010: Result = a_and_b;
        3'b011: Result = a_or_b;
        3'b101: Result = slt;
        default: Result = 32'b0;
    endcase
end
assign carry = ~(ALUControl[1])? cout: 1'b0;
assign overflow = (A[31]^a_sum_b[31])&(~(B[31]^A[31]^ALUControl[0]))& ~ALUControl[1];
assign negative = Result[31];
assign zero =(Result == 32'b0)?1'b1: 1'b0;

endmodule