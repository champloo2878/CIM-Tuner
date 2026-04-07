`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/02 19:20:20
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb();

reg CLK;
reg RSTN;
reg [28-1:0] INSTRUCTION;
reg [128-1:0] DIN;

parameter period = 4;
always #(period/2) CLK=~CLK;

parameter op_aor = 2'b00;
parameter op_tos = 2'b10;
parameter op_aos = 2'b01;

initial begin
    CLK = 0;
    RSTN = 1;
    #5;
    RSTN = 0;
    #5;
    RSTN = 1;
    #3;
    load_is(10'd20, 128'd0);
    load_is(10'd21, 128'd1);
    load_is(10'd22, 128'd7);
    load_is(10'd23, 128'd3);
    load_is(10'd24, 128'd4);
    load_is(10'd25, 128'd5);
    load_is(10'd26, 128'd6);
    load_is(10'd27, 128'd7);
    //
    weight_update(10'b00_0000_0000, 128'd1);
    weight_update(10'b00_0000_1000, 128'd2);
    weight_update(10'b00_0001_0000, 128'd3);
    weight_update(10'b00_0001_1000, 128'd4);
    weight_update(10'b00_0010_0000, 128'd5);
    weight_update(10'b00_0010_1000, 128'd6);
    weight_update(10'b00_0011_0000, 128'd7);
    weight_update(10'b00_0011_1000, 128'd8);
    //
    weight_update(10'b10_1000_0000, 128'd1);
    weight_update(10'b10_1000_1000, 128'd1);
    weight_update(10'b10_1001_0000, 128'd1);
    weight_update(10'b10_1001_1000, 128'd1);
    weight_update(10'b10_1010_0000, 128'd1);
    weight_update(10'b10_1010_1000, 128'd1);
    weight_update(10'b10_1011_0000, 128'd1);
    weight_update(10'b10_1011_1000, 128'd1);
    //
    compute_ff_is(3'd0,10'd20,op_aor,10'd0);
    compute_ff_is(3'd0,10'd21,op_aor,10'd0);
    compute_ff_is(3'd0,10'd22,op_aor,10'd0);
    compute_ff_is(3'd0,10'd23,op_aor,10'd0);
    compute_ff_is(3'd0,10'd24,op_aor,10'd0);
    compute_ff_is(3'd0,10'd25,op_aor,10'd0);
    compute_ff_is(3'd0,10'd26,op_aor,10'd0);
    compute_ff_is(3'd0,10'd27,op_aor,10'd0);
    //
    compute_ff_is(3'd0,10'd20,op_tos,10'd1);
    compute_ff_is(3'd0,10'd20,op_tos,10'd1);
    compute_ff_is(3'd0,10'd22,op_tos,10'd1);
    compute_ff_is(3'd0,10'd20,op_tos,10'd1);
    compute_ff_is(3'd0,10'd20,op_tos,10'd1);
    compute_ff_is(3'd0,10'd20,op_tos,10'd1);
    compute_ff_is(3'd0,10'd20,op_tos,10'd1);
    compute_ff_is(3'd0,10'd20,op_tos,10'd1);
    //
    // compute_ff_is(3'd0,10'd20,op_aos,10'd1);
    // compute_ff_is(3'd0,10'd20,op_aos,10'd1);
    // compute_ff_is(3'd0,10'd22,op_aos,10'd1);
    // compute_ff_is(3'd0,10'd20,op_aos,10'd1);
    // compute_ff_is(3'd0,10'd20,op_aos,10'd1);
    // compute_ff_is(3'd0,10'd20,op_aos,10'd1);
    // compute_ff_is(3'd0,10'd20,op_aos,10'd1);
    // compute_ff_is(3'd0,10'd20,op_aos,10'd1);
    //
    compute_ff_gt(3'd0,128'd15,op_aos,10'd1);
    compute_ff_gt(3'd0,128'd15,op_aos,10'd1);
    compute_ff_gt(3'd0,128'd15,op_aos,10'd1);
    compute_ff_gt(3'd0,128'd15,op_aos,10'd1);  
    compute_ff_gt(3'd0,128'd15,op_aos,10'd1);
    compute_ff_gt(3'd0,128'd15,op_aos,10'd1);  
    compute_ff_gt(3'd0,128'd15,op_aos,10'd1);
    compute_ff_gt(3'd0,128'd15,op_aos,10'd1);  
    nop;
    nop;
    nop;
    nop;
    #(period*10)
    $finish;
end

top u_top(
    .clk(CLK),
    .rstn(RSTN),
    .instruction(INSTRUCTION),
    .din(DIN)
);

task load_is;
    input [10-1:0] is_addr;
    input [128-1:0] din;
    begin
        INSTRUCTION = {3'b000, is_addr, 15'b0};
        DIN = din;
        #(period);
    end
endtask

task weight_update;
    input [10-1:0] cm_ar;
    input [128-1:0] din;
    begin
        INSTRUCTION = {3'b001, cm_ar, 15'b0};
        DIN = din;
        #(period);
    end
endtask

task compute_ff_is;
    input [3-1:0] cm_ca; 
    input [10-1:0] is_addr;
    input [1:0] os_op;
    input [10-1:0] os_addr;
    begin
        INSTRUCTION = {3'b010, is_addr, cm_ca, os_op, os_addr};
        DIN = 'd0;
        #(period);
    end
endtask

task compute_ff_gt;
    input [3-1:0] cm_ca;
    input [128-1:0] din;
    input [1:0] os_op;
    input [10-1:0] os_addr;
    begin
        INSTRUCTION = {3'b011, 10'b0, cm_ca, os_op, os_addr};
        DIN = din;
        #(period);
    end
endtask

task nop;
    begin
        INSTRUCTION = {3'b111, 25'b0};
        DIN = 'd0;
        #(period);
    end
endtask
endmodule
