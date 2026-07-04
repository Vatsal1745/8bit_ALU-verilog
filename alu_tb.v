`timescale 1ns / 1ps

module alu_tb;

    reg [7:0] tb_in_a;
    reg [7:0] tb_in_b;
    reg [2:0] tb_op;
    wire [7:0] tb_out;
    wire       tb_carry;
    integer error_count = 0;

    localparam OP_ADD = 3'b000, OP_SUB = 3'b001, OP_AND = 3'b010,
               OP_OR  = 3'b011, OP_XOR = 3'b100, OP_NOT = 3'b101;

    // Directly tests your alu_rtl module instance
    alu_rtl uut (
        .alu_in_a(tb_in_a),
        .alu_in_b(tb_in_b),
        .alu_op(tb_op),
        .alu_out(tb_out),
        .carry_out(tb_carry)
    );

    task verify_alu(
        input [7:0] a, input [7:0] b, input [2:0] op,
        input [7:0] exp_out, input exp_carry, input [8*20:1] op_name
    );
        begin
            tb_in_a = a; tb_in_b = b; tb_op = op;
            #10;
            if ((tb_out !== exp_out) || (tb_carry !== exp_carry)) begin
                $display("[ERROR] Mismatch on %s! A=%h, B=%h", op_name, a, b);
                error_count = error_count + 1;
            end else begin
                $display("[SUCCESS] %s passed.", op_name);
            end
        end
    endtask

    initial begin
        // Dumps waveform file matching your file naming convention
        $dumpfile("alu_tb.vcd"); 
        $dumpvars(0, alu_tb);       

        verify_alu(8'h05, 8'h0A, OP_ADD, 8'h0F, 1'b0, "ADD_NORMAL");
        verify_alu(8'hFF, 8'h01, OP_ADD, 8'h00, 1'b1, "ADD_OVERFLOW"); 
        verify_alu(8'h0A, 8'h05, OP_SUB, 8'h05, 1'b0, "SUB_NORMAL");
        verify_alu(8'h00, 8'h01, OP_SUB, 8'hFF, 1'b1, "SUB_UNDERFLOW"); 
        verify_alu(8'hFF, 8'h0F, OP_AND, 8'h0F, 1'b0, "AND_MASK");
        
        $finish; 
    end
endmodule