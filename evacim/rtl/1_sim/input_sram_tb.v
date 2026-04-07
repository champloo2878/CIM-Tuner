`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 10:01:38
// Design Name: 
// Module Name: input_sram_tb
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

module input_sram_tb();

parameter period = 4;

reg CLK;
reg RSTN;
reg CS;
reg WEN;
reg [$clog2(`InputSRAMDepth)-1:0] ADDR;
reg [`InputSRAMWidth-1:0] DIN;
wire [`InputSRAMWidth-1:0] DOUT;   


input_sram uis(
    .clk(CLK),
    .rstn(RSTN),
    .cs(CS),
    .wen(WEN),
    .addr(ADDR),
    .din(DIN),
    .dout(DOUT)
);

always #(period/2) CLK=~CLK;

initial begin
    CLK = 0;
    RSTN = 1;
    CS = 0;
    #1
    RSTN = 0;
    #1
    RSTN = 1;
    #(period/4);
    write(10'd0, 128'd0);
    write(10'd1, 128'd10);
    write(10'd2, 128'd100);
    write(10'd3, 128'd1000);
    read(10'd0);
    read(10'd1);
    read(10'd2);
    read(10'd3);
    $finish;
end

task write;
    input [10-1:0] addr;
    input [128-1:0] data;
    begin
        CS = 1;
        WEN = 1;
        ADDR = addr;
        DIN = data;
        #(period);
    end
endtask

task read;
    input [10-1:0] addr;
    begin
        CS = 1;
        WEN = 0;
        ADDR = addr;
        #(period);
    end
endtask



endmodule
