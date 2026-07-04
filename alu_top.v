`timescale 1ns / 1ps

module alu_top (
    input  wire       clk,         
    input  wire       rst_n,       
    input  wire [7:0] data_in_a,   
    input  wire [7:0] data_in_b,   
    input  wire [2:0] op_select,   
    output reg  [7:0] final_out,   
    output reg        final_carry  
);

    reg [7:0] reg_a;
    reg [7:0] reg_b;
    reg [2:0] reg_op;
    wire [7:0] alu_wire_out;
    wire       alu_wire_carry;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_a  <= 8'h00;
            reg_b  <= 8'h00;
            reg_op <= 3'b000;
        end else begin
            reg_a  <= data_in_a;
            reg_b  <= data_in_b;
            reg_op <= op_select;
        end
    end

    // Instantiates your exact alu_rtl module
    alu_rtl alu_inst (
        .alu_in_a(reg_a),
        .alu_in_b(reg_b),
        .alu_op(reg_op),
        .alu_out(alu_wire_out),
        .carry_out(alu_wire_carry)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_out   <= 8'h00;
            final_carry <= 1'b0;
        end else begin
            final_out   <= alu_wire_out;
            final_carry <= alu_wire_carry;
        end
    end
endmodule