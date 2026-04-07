`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/29 16:35:28
// Design Name: 
// Module Name: top_test
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
`define OutputSRAMDepth 1024

module top_test();

reg CLK;
reg RSTN;

reg FD_GO_THROUGH;
reg IS_WEN;
reg [128-1:0] DIN;
reg [10-1:0] IS_ADDR;
reg CM_CEB;
reg CM_WEB;
reg CM_CIMENB;
reg [10-1:0] CM_AR;
reg [3-1:0] CM_CA;

reg GD_TOS;
reg GD_AOS;
reg [$clog2(`OutputSRAMDepth)-1:0] GD_OS_ADDR;

wire CM_CEB_FD_S1;
wire CM_WEB_FD_S1;
wire CM_CIMENB_FD_S1;
wire [10-1:0] CM_AR_FD_S1;
wire [3-1:0] CM_CA_FD_S1;

wire GD_TOS_CM;
wire GD_AOS_CM;
wire [$clog2(`OutputSRAMDepth)-1:0] GD_OS_ADDR_CM;
wire GD_TOS_CM_S1;
wire GD_AOS_CM_S1;
wire [$clog2(`OutputSRAMDepth)-1:0] GD_OS_ADDR_CM_S1;

wire [128-1:0] FD_DOUT;

wire [23-1:0] psum0;
wire [23-1:0] psum1;
wire [23-1:0] psum2;
wire [23-1:0] psum3;
wire [23-1:0] psum4;
wire [23-1:0] psum5;
wire [23-1:0] psum6;
wire [23-1:0] psum7;

wire [23-1:0] psum8;
wire [23-1:0] psum9;
wire [23-1:0] psum10;
wire [23-1:0] psum11;
wire [23-1:0] psum12;
wire [23-1:0] psum13;
wire [23-1:0] psum14;
wire [23-1:0] psum15;

fd ufd(
    .clk(CLK),
    .rstn(RSTN),
    .fd_go_through(FD_GO_THROUGH),
    .is_wen(IS_WEN),
    .din(DIN),
    .is_addr(IS_ADDR),
    .cm_ceb(CM_CEB),
    .cm_web(CM_WEB),
    .cm_cimenb(CM_CIMENB),
    .cm_ar(CM_AR),
    .cm_ca(CM_CA),
    .cm_ceb_fd_s1(CM_CEB_FD_S1),
    .cm_web_fd_s1(CM_WEB_FD_S1),
    .cm_cimenb_fd_s1(CM_CIMENB_FD_S1),
    .cm_ar_fd_s1(CM_AR_FD_S1),
    .cm_ca_fd_s1(CM_CA_FD_S1),
    .dout(FD_DOUT),
    .gd_tos(GD_TOS),
    .gd_aos(GD_AOS),
    .gd_os_addr(GD_OS_ADDR),
    .gd_tos_fd_s1(GD_TOS_CM),
    .gd_aos_fd_s1(GD_AOS_CM),
    .gd_os_addr_fd_s1(GD_OS_ADDR_CM)
);

macros u_macros(
    .clk(CLK),
    .ceb(CM_CEB_FD_S1),
    .web(CM_WEB_FD_S1),
    .cimenb(CM_CIMENB_FD_S1),
    .ar(CM_AR_FD_S1),
    .ca(CM_CA_FD_S1),
    .in(FD_DOUT),
    .psum_cm0(psum0),
    .psum_cm1(psum1),
    .psum_cm2(psum2),
    .psum_cm3(psum3),
    .psum_cm4(psum4),
    .psum_cm5(psum5),
    .psum_cm6(psum6),
    .psum_cm7(psum7),    
    .psum_cm8(psum8),
    .psum_cm9(psum9),
    .psum_cm10(psum10),
    .psum_cm11(psum11),
    .psum_cm12(psum12),
    .psum_cm13(psum13),
    .psum_cm14(psum14),
    .psum_cm15(psum15),
    .gd_tos_cm(GD_TOS_CM),
    .gd_aos_cm(GD_AOS_CM),
    .gd_os_addr_cm(GD_OS_ADDR_CM)
);

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
    load_is(10'd20, 128'd0);
    load_is(10'd21, 128'd1);
    load_is(10'd22, 128'd2);
    load_is(10'd23, 128'd3);
    load_is(10'd24, 128'd4);
    load_is(10'd25, 128'd5);
    load_is(10'd26, 128'd6);
    load_is(10'd27, 128'd6);
    weight_update(10'b00_0000_0000, 128'd1);
    weight_update(10'b00_0000_1000, 128'd2);
    weight_update(10'b00_0001_0000, 128'd3);
    weight_update(10'b00_0001_1000, 128'd4);
    weight_update(10'b00_0010_0000, 128'd5);
    weight_update(10'b00_0010_1000, 128'd6);
    weight_update(10'b00_0011_0000, 128'd7);
    weight_update(10'b00_0011_1000, 128'd8);
    //just aor
    compute_ff_is(3'd0,10'd20,2'd0,10'd0);
    compute_ff_is(3'd0,10'd21,2'd0,10'd0);
    compute_ff_is(3'd0,10'd22,2'd0,10'd0);
    compute_ff_is(3'd0,10'd23,2'd0,10'd0);
    compute_ff_is(3'd0,10'd24,2'd0,10'd0);
    compute_ff_is(3'd0,10'd25,2'd0,10'd0);
    compute_ff_is(3'd0,10'd26,2'd0,10'd0);
    compute_ff_is(3'd0,10'd27,2'd0,10'd0);
    //result tos
    compute_ff_is(3'd0,10'd20,2'd1,10'd0);
    compute_ff_is(3'd0,10'd21,2'd1,10'd0);
    compute_ff_is(3'd0,10'd22,2'd1,10'd0);
    compute_ff_is(3'd0,10'd23,2'd1,10'd0);
    compute_ff_is(3'd0,10'd24,2'd1,10'd0);
    compute_ff_is(3'd0,10'd25,2'd1,10'd0);
    compute_ff_is(3'd0,10'd26,2'd1,10'd0);
    compute_ff_is(3'd0,10'd27,2'd1,10'd0);
    //result aos
    compute_ff_is(3'd0,10'd20,2'd2,10'd0);
    compute_ff_is(3'd0,10'd21,2'd2,10'd0);
    compute_ff_is(3'd0,10'd22,2'd2,10'd0);
    compute_ff_is(3'd0,10'd23,2'd2,10'd0);
    compute_ff_is(3'd0,10'd24,2'd2,10'd0);
    compute_ff_is(3'd0,10'd25,2'd2,10'd0);
    compute_ff_is(3'd0,10'd26,2'd2,10'd0);
    compute_ff_is(3'd0,10'd27,2'd2,10'd0);
    compute_ff_gt(3'd0,128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff);
    compute_ff_gt(3'd5,128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff);
    load_is(10'd27, 128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff);
    nop;
    nop;
    nop;
    nop;
    nop;
    load_is(10'd455, 128'd0);
    nop;
    nop;
    nop;
    nop;
    nop;
    $finish;

end

/*  instructions (task)
1. load IS;
2. weight update (fd go through);
3. compute, feature from IS; 
4. compute, feature went through;
*/

`define FDGoThrough_Enable 1
`define ISWrite_Enable 1
`define CIMCompute_Enable 0
`define CIMWrite_Enable 0
`define CIMEnable_Enable 0

task load_is;
    input [10-1:0] is_addr;
    input [128-1:0] din;
    begin
        FD_GO_THROUGH = ~`FDGoThrough_Enable;
        IS_WEN = `ISWrite_Enable;
        DIN = din;
        IS_ADDR = is_addr;
        CM_CEB = ~`CIMCompute_Enable;
        CM_WEB = ~`CIMWrite_Enable;
        CM_CIMENB = ~`CIMEnable_Enable;
        CM_AR = 10'd0;
        CM_CA = 3'd0;
        GD_TOS = 0;
        GD_AOS = 0;
        GD_OS_ADDR = 10'd0; 
        #(period);

    end
endtask

task weight_update;
    input [10-1:0] cm_ar;
    input [128-1:0] din;
    begin
        FD_GO_THROUGH = `FDGoThrough_Enable;
        IS_WEN = ~`ISWrite_Enable;
        DIN = din;
        IS_ADDR = 10'd0;
        CM_CEB = ~`CIMCompute_Enable;
        CM_WEB = `CIMWrite_Enable;
        CM_CIMENB = `CIMEnable_Enable;
        CM_AR = cm_ar;
        CM_CA = 3'd0;
        GD_TOS = 0;
        GD_AOS = 0;
        GD_OS_ADDR = 10'd0;
        #(period);
    end
endtask

task compute_ff_is;
    input [3-1:0] cm_ca; 
    input [10-1:0] is_addr;
    input [1:0] os_op;
    input [10-1:0] os_addr;
    begin
        FD_GO_THROUGH = ~`FDGoThrough_Enable;
        IS_WEN = ~`ISWrite_Enable; //Read
        DIN = 128'd0;
        IS_ADDR = is_addr;
        CM_CEB = `CIMCompute_Enable;
        CM_WEB = ~`CIMWrite_Enable;
        CM_CIMENB = `CIMEnable_Enable;
        CM_AR = 10'd0;
        CM_CA = cm_ca;
        case (os_op)
            2'd0://aor
            begin
                GD_TOS = 0;
                GD_AOS = 0;   
            end
            2'd1://tos
            begin
                GD_TOS = 1;
                GD_AOS = 0;   
            end
            2'd2://aos
            begin
                GD_TOS = 0;
                GD_AOS = 1;   
            end
            default:
            begin
                GD_TOS = 0;
                GD_AOS = 0;   
            end
        endcase
        GD_OS_ADDR = os_addr;
        #(period);
    end
endtask

task compute_ff_gt;
    input [3-1:0] cm_ca;
    input [128-1:0] din;
    begin
        FD_GO_THROUGH = `FDGoThrough_Enable;
        IS_WEN = ~`ISWrite_Enable; //Read
        DIN = din;
        IS_ADDR = 10'd0;
        CM_CEB = `CIMCompute_Enable;
        CM_WEB = ~`CIMWrite_Enable;
        CM_CIMENB = `CIMEnable_Enable;
        CM_AR = 10'd0;
        CM_CA = cm_ca;
        #(period);
    end
endtask

task nop;
    begin
        FD_GO_THROUGH = `FDGoThrough_Enable;
        IS_WEN = ~`ISWrite_Enable; //Read
        DIN = 128'd0;
        IS_ADDR = 10'd0;
        CM_CEB = ~`CIMCompute_Enable;
        CM_WEB = ~`CIMWrite_Enable;
        CM_CIMENB = ~`CIMEnable_Enable;
        CM_AR = 10'd0;
        CM_CA = 3'd0;
        #(period);        
    end
endtask


endmodule
