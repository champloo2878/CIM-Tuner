`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/26 15:21:14
// Design Name: 
// Module Name: sin_macro_tb
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


module sin_macro_tb();
parameter period = 4;

reg CLK;
reg CEB;
reg WEB;
reg CIMENB;
reg [9-1:0] AR;
reg [3-1:0] CA;
reg [64-1:0] IN;

wire [64-1:0] Q;
wire [14-1:0] psum0_w;
wire [14-1:0] psum1_w;
wire [14-1:0] psum2_w;
wire [14-1:0] psum3_w;
wire [14-1:0] psum4_w;
wire [14-1:0] psum5_w;
wire [14-1:0] psum6_w;
wire [14-1:0] psum7_w;

sin_macro u_sin_macro(
    .clk(CLK),
    .ceb(CEB),
    .web(WEB),
    .cimenb(CIMENB),
    .ar(AR),
    .ca(CA),
    .in(IN),
    .Q(Q),
    .psum0_w(psum0_w),
    .psum1_w(psum1_w),
    .psum2_w(psum2_w),    
    .psum3_w(psum3_w),
    .psum4_w(psum4_w),
    .psum5_w(psum5_w),
    .psum6_w(psum6_w),
    .psum7_w(psum7_w)
);

initial begin
    CLK = 0;
    CIMENB = 1;
    #(period/4);
    wu(9'd0,64'd1);
    wu(9'd8,64'd2);
    wu(9'd16,64'd3);
    wu(9'd24,64'd4);
    wu(9'd32,64'd5);
    wu(9'd40,64'd6);
    wu(9'd48,64'd7);
    wu(9'd56,64'd8);
    check_read(9'd0);
    check_read(9'd8);
    check_read(9'd16);
    check_read(9'd24);
    check_read(9'd32);
    check_read(9'd40);
    check_read(9'd48);
    check_read(9'd56);
    #(100);
    compute(3'd0,64'hffff_ffff_ffff_ffff);
    #(100);
    compute(3'd1,64'hffff_ffff_ffff_ffff);
    $finish;
end

always #(period/2) CLK = ~CLK;

task wu;
    input [9-1:0] addr;
    input [64-1:0] weight;
    begin
        CEB=1;
        WEB=0;
        CIMENB=0;
        AR = addr;
        IN = weight;
        #(period);
    end
endtask

task check_read;
    input [9-1:0] addr;
    begin
        CEB=1;
        WEB=1;
        CIMENB=0;
        AR=addr;
        #(period);
    end
endtask

task compute;
    input [3-1:0] ca_temp;
    input [64-1:0] in_temp;
    begin
        CEB=0;
        CIMENB=0;
        IN = in_temp;
        CA = ca_temp;
        #(period);
    end
endtask

endmodule
