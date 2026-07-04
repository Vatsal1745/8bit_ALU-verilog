`timescale 1ns / 1ps

module alu_rtl (
    input  wire [7:0] alu_in_a,    // 8-bit Input Operand A
    input  wire [7:0] alu_in_b,    // 8-bit Input Operand B
    input  wire [2:0] alu_op,      // 3-bit Operation Select
    output reg  [7:0] alu_out,     // 8-bit ALU Data Output
    output reg        carry_out    // 1-bit Carry/Borrow Out Flag
);

    localparam OP_ADD = 3'b000,
               OP_SUB = 3'b001,
               OP_AND = 3'b010,
               OP_OR  = 3'b011,
               OP_XOR = 3'b100,
               OP_NOT = 3'b101;

    // Combinational Logic Block
    always @* begin
        // Default assignments to prevent Latch Generation - so that we dont explicitly have to mention carry_out = 1'b0 in each operation
        alu_out   = 8'h00;
        carry_out = 1'b0;

        case (alu_op)
            OP_ADD: begin
                // 9-bit addition to cleanly extract the carry bit
                {carry_out, alu_out} = alu_in_a + alu_in_b;
            end
            
            OP_SUB: begin
                // 9-bit subtraction to capture borrow bit
                {carry_out, alu_out} = alu_in_a - alu_in_b;
            end
            
            OP_AND: begin
                alu_out   = alu_in_a & alu_in_b;
                carry_out = 1'b0; // Logical operations clear carry
            end
            
            OP_OR: begin
                alu_out   = alu_in_a | alu_in_b;
                carry_out = 1'b0;
            end
            
            OP_XOR: begin
                alu_out   = alu_in_a ^ alu_in_b;
                carry_out = 1'b0;
            end
            
            OP_NOT: begin
                alu_out   = ~alu_in_a; // Unary NOT operation on Operand A
                carry_out = 1'b0;
            end
            
            default: begin //we have used only 6 cases but 2^3 = 8 so thats why this default statement 
                alu_out   = 8'h00;
                carry_out = 1'b0;
            end
        endcase
    end

endmodule