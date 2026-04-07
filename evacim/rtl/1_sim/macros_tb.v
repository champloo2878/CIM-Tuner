`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/26 19:43:06
// Design Name: 
// Module Name: macros_tb
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
module macros_tb();
parameter period = 4;

reg CLK;
reg CEB;
reg WEB;
reg CIMENB;
reg [10-1:0] AR;
reg [3-1:0] CA;
reg [128-1:0] IN;

wire [15-1:0] psum0p0;
wire [15-1:0] psum1p0;
wire [15-1:0] psum2p0;
wire [15-1:0] psum3p0;
wire [15-1:0] psum4p0;
wire [15-1:0] psum5p0;
wire [15-1:0] psum6p0;
wire [15-1:0] psum7p0;

wire [15-1:0] psum0p1;
wire [15-1:0] psum1p1;
wire [15-1:0] psum2p1;
wire [15-1:0] psum3p1;
wire [15-1:0] psum4p1;
wire [15-1:0] psum5p1;
wire [15-1:0] psum6p1;
wire [15-1:0] psum7p1;

macros u_macros(
    .clk(CLK),
    .ceb(CEB),
    .web(WEB),
    .cimenb(CIMENB),
    .ar(AR),
    .ca(CA),
    .in(IN),
    .psum0p0(psum0p0),
    .psum1p0(psum1p0),
    .psum2p0(psum2p0),
    .psum3p0(psum3p0),
    .psum4p0(psum4p0),
    .psum5p0(psum5p0),
    .psum6p0(psum6p0),
    .psum7p0(psum7p0),    
    .psum0p1(psum0p1),
    .psum1p1(psum1p1),
    .psum2p1(psum2p1),
    .psum3p1(psum3p1),
    .psum4p1(psum4p1),
    .psum5p1(psum5p1),
    .psum6p1(psum6p1),
    .psum7p1(psum7p1)
);

always #(period/2) CLK = ~CLK;

initial begin
    CLK = 0;
    CIMENB = 1;
    #(period/4);
    wu(10'b00_0000_0000, 128'd1);
    wu(10'b00_0000_1000, 128'd2);
    wu(10'b00_0001_0000, 128'd3);
    wu(10'b00_0001_1000, 128'd4);
    wu(10'b00_0010_0000, 128'd5);
    wu(10'b00_0010_1000, 128'd6);
    wu(10'b00_0011_0000, 128'd7);
    wu(10'b00_0011_1000, 128'd8);
    #(100) compute(3'd0, 128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff);
    wu(10'b10_0000_0000, 128'd1);
    wu(10'b10_0000_1000, 128'd2);
    wu(10'b10_0001_0000, 128'd3);
    wu(10'b10_0001_1000, 128'd4);
    wu(10'b10_0010_0000, 128'd5);
    wu(10'b10_0010_1000, 128'd6);
    wu(10'b10_0011_0000, 128'd7);
    wu(10'b10_0011_1000, 128'd8);
    #(100) compute(3'd0, 128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff);
    compute(3'd1, 128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff);
    $finish;
end

task wu;
    input [10-1:0] addr;
    input [128-1:0] weight;
    begin
        CEB=1;
        WEB=0;
        CIMENB=0;
        AR = addr;
        IN = weight;
        #(period);
    end
endtask

task compute;
    input [3-1:0] ca_temp;
    input [128-1:0] in_temp;
    begin
        CEB=0;
        CIMENB=0;
        IN = in_temp;
        CA = ca_temp;
        #(period);
    end
endtask

endmodule
