module instructionMem(address, dataOut , rst);
input [31:0] address;
output[31:0] dataOut ;
input rst;

reg [31:0] memory [1023:0];

assign dataOut= (~rst)? 32'b0 : memory[address[31:2]];

initial begin
     $readmemh("program.hex", memory);
end

endmodule

module registerFile(clk,rst,A1,A2,A3,WE,WD3, RD1, RD2);
input [4:0] A1,A2,A3;
input [31:0] WD3;
input WE, clk,rst;
output [31:0] RD1, RD2;
reg [31:0] registers [31:0];

assign  RD1  = ~rst? 32'b0: A1==0? 32'b0: registers[A1];
assign RD2   = ~rst? 32'b0: A2==0? 32'b0: registers[A2];

always @(posedge clk) begin
    if(WE && A3!=0) registers[A3]<= WD3;
end

// for testing purposes
  initial begin
        registers[1] = 32'h00000005;
        registers[2] = 32'h0000000F;
        registers[4] =32'h00000100;
        
    end
endmodule

module dataMemory(clk, rst, WE, A,WD, RD);
input clk, rst, WE;
input [31:0] A, WD;
output [31:0 ]RD;
reg [31:0] memory [1023:0];
always @(posedge clk) begin
    if(WE)  memory[A] = WD;     
end
assign RD = (~rst)? 32'b0 : memory[A];

endmodule