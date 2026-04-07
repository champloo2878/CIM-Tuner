`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/02 09:53:22
// Design Name: 
// Module Name: gd_tb
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


module gd_tb();

reg CLK;
reg RSTN;
reg GD_EN;
reg TOS;
reg AOS;
reg [10-1:0] OS_ADDR;
reg [23-1:0] PSUM0;
reg [23-1:0] PSUM1;
reg [23-1:0] PSUM2;
reg [23-1:0] PSUM3;
reg [23-1:0] PSUM4;
reg [23-1:0] PSUM5;
reg [23-1:0] PSUM6;
reg [23-1:0] PSUM7;
reg [23-1:0] PSUM8;
reg [23-1:0] PSUM9;
reg [23-1:0] PSUM10;
reg [23-1:0] PSUM11;
reg [23-1:0] PSUM12;
reg [23-1:0] PSUM13;
reg [23-1:0] PSUM14;
reg [23-1:0] PSUM15;


parameter period = 4;
always #(period/2) CLK=~CLK;

initial begin
    CLK = 0;
    RSTN = 1;
    #5;
    RSTN = 0;
    #5;
    RSTN = 1;
    #3;
    a_w_or(23'd1);
    a_w_or(23'd1);
    a_w_or(23'd1);
    aor_tos(23'd1, 10'd33);
    a_w_or(23'd1);
    a_w_or(23'd1);
    a_w_or(23'd1);
    aor_aos(23'd1, 10'd33);
    a_w_or(23'd1);
    a_w_or(23'd1);
    a_w_or(23'd1);
    aor_aos(23'd1, 10'd33);
    a_w_or(23'd1);
    a_w_or(23'd5);
    a_w_or(23'd1);
    aor_aos(23'd1, 10'd33);
    aor_tos(23'd1, 10'd555);
    aor_aos(23'h3a, 10'd555); 

    #(period*5);
    $finish;
end

gd ugd(
    .clk(CLK),
    .rstn(RSTN),
    .gd_en(GD_EN),
    .tos(TOS),
    .aos(AOS),
    .psum0(PSUM0),
    .psum1(PSUM1),
    .psum2(PSUM2),
    .psum3(PSUM3),
    .psum4(PSUM4),
    .psum5(PSUM5),
    .psum6(PSUM6),
    .psum7(PSUM7),
    .psum8(PSUM8),
    .psum9(PSUM9),
    .psum10(PSUM10),
    .psum11(PSUM11),
    .psum12(PSUM12),
    .psum13(PSUM13),
    .psum14(PSUM14),
    .psum15(PSUM15),
    .os_addr(OS_ADDR)
);

task a_w_or;
    input [23-1:0] psum;
    begin
        GD_EN = 1;
        TOS = 0;
        AOS = 0;
        OS_ADDR = 'd0;
        PSUM0 = psum;
        PSUM1 = psum;
        PSUM2 = psum;
        PSUM3 = psum;
        PSUM4 = psum;
        PSUM5 = psum;
        PSUM6 = psum;
        PSUM7 = psum;
        PSUM8 = psum;
        PSUM9 = psum;
        PSUM10 = psum;
        PSUM11 = psum;
        PSUM12 = psum;
        PSUM13 = psum;
        PSUM14 = psum;
        PSUM15 = psum;
        #(period);
        GD_EN = 0;
        #(period*7);
    end
endtask

task aor_tos;
    input [23-1:0] psum;
    input [10-1:0] os_addr;
    begin
        GD_EN = 1;
        TOS = 1;
        AOS = 0;
        OS_ADDR = os_addr;
        PSUM0 = psum;
        PSUM1 = psum;
        PSUM2 = psum;
        PSUM3 = psum;
        PSUM4 = psum;
        PSUM5 = psum;
        PSUM6 = psum;
        PSUM7 = psum;
        PSUM8 = psum;
        PSUM9 = psum;
        PSUM10 = psum;
        PSUM11 = psum;
        PSUM12 = psum;
        PSUM13 = psum;
        PSUM14 = psum;
        PSUM15 = psum;
        #(period);
        GD_EN = 0;
        #(period*7);        
    end
endtask

task aor_aos;
    input [23-1:0] psum;
    input [10-1:0] os_addr;
    begin
        GD_EN = 1;
        TOS = 1;
        AOS = 1;
        OS_ADDR = os_addr;
        PSUM0 = psum;
        PSUM1 = psum;
        PSUM2 = psum;
        PSUM3 = psum;
        PSUM4 = psum;
        PSUM5 = psum;
        PSUM6 = psum;
        PSUM7 = psum;
        PSUM8 = psum;
        PSUM9 = psum;
        PSUM10 = psum;
        PSUM11 = psum;
        PSUM12 = psum;
        PSUM13 = psum;
        PSUM14 = psum;
        PSUM15 = psum;
        #(period);
        GD_EN = 0;
        #(period*7);           
    end
endtask


endmodule
