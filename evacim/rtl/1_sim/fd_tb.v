`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 15:14:23
// Design Name: 
// Module Name: fd_tb
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


module fd_tb();

reg CLK;
reg RSTN;
reg FD_GO_THROUGH;
reg IS_WEN;
reg [128-1:0] DIN;
reg [$clog2(1024)-1:0] IS_ADDR;

wire [128-1:0] DOUT;

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
    load_is(10'd555, 128'd0);
    load_is(10'd556, 128'd1);
    load_is(10'd557, 128'd2);
    load_is(10'd558, 128'd3);
    read_is(10'd555);
    read_is(10'd556);
    read_is(10'd557);
    read_is(10'd558);
    gt(128'd4);
    gt(128'd5);
    gt(128'd6);
    gt(128'd7);
    #(period*5);
    $finish;

end

fd ufd(
    .clk(CLK),
    .rstn(RSTN),
    .fd_go_through(FD_GO_THROUGH),
    .is_wen(IS_WEN),
    .din(DIN),
    .is_addr(IS_ADDR),
    .dout(DOUT)
);

task load_is;
    input [$clog2(1024)-1:0] addr;
    input [128-1:0] din;
    begin
        FD_GO_THROUGH = 0;
        IS_WEN = 1;
        IS_ADDR = addr;
        DIN = din;
        #(period);
    end
endtask

task read_is;
    input [$clog2(1024)-1:0] addr;
    begin
        FD_GO_THROUGH = 0;
        IS_WEN = 0;
        IS_ADDR = addr;
        #(period);
    end
endtask

task gt;
    input [128-1:0] din;
    begin
       FD_GO_THROUGH = 1;
       DIN = din;
       #(period); 
    end
endtask

endmodule
