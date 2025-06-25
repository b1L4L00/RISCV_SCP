module nextPC (
    input         clk,
    input         reset,
    input  [31:0] next_pc,  // Next PC value from control logic
    output [31:0] pc        // Current PC value
);

    reg [31:0] pc_reg;

    // Output current PC value
    assign pc = pc_reg;

    // Update PC on rising edge
    always @(posedge clk or negedge reset) begin
        if (~reset)
            pc_reg <= 32'h00000000;  // Reset PC to 0
        else
            pc_reg <= next_pc;
    end

endmodule


