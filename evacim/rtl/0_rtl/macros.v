//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/26 15:49:04
// Design Name: 
// Module Name: macros
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
`include "defines.v"

module macros(
    input clk,
    input ceb, // compute enable, 0 for compute, 1 for w&r
    input web, // write enable, 0 for write, 1 for read
    input cimenb, // cim enable, 0 for cim enable
    input [`CIMsAddr-1:0] ar,
    input [`LocalSwitchAddr-1:0] ca,
    input [`CIMsInputWidth-1:0] in,
    input sign,

    //for gd
    input gd_tos_cm,
    input gd_aos_cm,
    input [$clog2(`OutputSRAMDepth)-1:0] gd_os_addr_cm,

    output reg gd_tos_cm_s1,
    output reg gd_aos_cm_s1,
    output reg [$clog2(`OutputSRAMDepth)-1:0] gd_os_addr_cm_s1,

    output [`CIMsFWAOutputBW-1:0] psum_cm0,
    output [`CIMsFWAOutputBW-1:0] psum_cm1,
    output [`CIMsFWAOutputBW-1:0] psum_cm2,
    output [`CIMsFWAOutputBW-1:0] psum_cm3,
    output [`CIMsFWAOutputBW-1:0] psum_cm4,
    output [`CIMsFWAOutputBW-1:0] psum_cm5,
    output [`CIMsFWAOutputBW-1:0] psum_cm6,
    output [`CIMsFWAOutputBW-1:0] psum_cm7,

    output [`CIMsFWAOutputBW-1:0] psum_cm8,
    output [`CIMsFWAOutputBW-1:0] psum_cm9,
    output [`CIMsFWAOutputBW-1:0] psum_cm10,
    output [`CIMsFWAOutputBW-1:0] psum_cm11,
    output [`CIMsFWAOutputBW-1:0] psum_cm12,
    output [`CIMsFWAOutputBW-1:0] psum_cm13,
    output [`CIMsFWAOutputBW-1:0] psum_cm14,
    output [`CIMsFWAOutputBW-1:0] psum_cm15,
    output cm_gd_en
    );

    reg ceb_reg;
    reg web_reg;
    reg web0;
    reg web1;
    reg cimenb_reg;
    reg cimenb0;
    reg cimenb1;
    reg [`SinCIMAddr-1:0] ar_sin_reg;
    reg ar_para_reg;
    reg [`LocalSwitchAddr-1:0] ca_reg;
    reg [`CIMsInputWidth-1:0] in_reg;
    reg sign_reg;
    
    reg [$clog2(`FeatureWiseAdderTimes)-1:0] fwa_sfg_reg_s0;
    reg [$clog2(`FeatureWiseAdderTimes)-1:0] fwa_sfg_reg_s1;
    reg cimenb_reg_s1;
    reg ceb_reg_s1;

    wire [`SinCIMOutputBW-1:0] psum0p0a0;
    wire [`SinCIMOutputBW-1:0] psum1p0a0;
    wire [`SinCIMOutputBW-1:0] psum2p0a0;
    wire [`SinCIMOutputBW-1:0] psum3p0a0;
    wire [`SinCIMOutputBW-1:0] psum4p0a0;
    wire [`SinCIMOutputBW-1:0] psum5p0a0;
    wire [`SinCIMOutputBW-1:0] psum6p0a0;
    wire [`SinCIMOutputBW-1:0] psum7p0a0;

    wire [`SinCIMOutputBW-1:0] psum0p1a0;
    wire [`SinCIMOutputBW-1:0] psum1p1a0;
    wire [`SinCIMOutputBW-1:0] psum2p1a0;
    wire [`SinCIMOutputBW-1:0] psum3p1a0;
    wire [`SinCIMOutputBW-1:0] psum4p1a0;
    wire [`SinCIMOutputBW-1:0] psum5p1a0;
    wire [`SinCIMOutputBW-1:0] psum6p1a0;
    wire [`SinCIMOutputBW-1:0] psum7p1a0;

    wire [`SinCIMOutputBW-1:0] psum0p0a1;
    wire [`SinCIMOutputBW-1:0] psum1p0a1;
    wire [`SinCIMOutputBW-1:0] psum2p0a1;
    wire [`SinCIMOutputBW-1:0] psum3p0a1;
    wire [`SinCIMOutputBW-1:0] psum4p0a1;
    wire [`SinCIMOutputBW-1:0] psum5p0a1;
    wire [`SinCIMOutputBW-1:0] psum6p0a1;
    wire [`SinCIMOutputBW-1:0] psum7p0a1;

    wire [`SinCIMOutputBW-1:0] psum0p1a1;
    wire [`SinCIMOutputBW-1:0] psum1p1a1;
    wire [`SinCIMOutputBW-1:0] psum2p1a1;
    wire [`SinCIMOutputBW-1:0] psum3p1a1;
    wire [`SinCIMOutputBW-1:0] psum4p1a1;
    wire [`SinCIMOutputBW-1:0] psum5p1a1;
    wire [`SinCIMOutputBW-1:0] psum6p1a1;
    wire [`SinCIMOutputBW-1:0] psum7p1a1;

    wire [`CIMsWWAOutputBW-1:0] psum_wwa0;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa1;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa2;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa3;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa4;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa5;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa6;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa7;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa8;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa9;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa10;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa11;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa12;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa13;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa14;
    wire [`CIMsWWAOutputBW-1:0] psum_wwa15;

    reg [`CIMsFWAOutputBW-1:0] psum_fwa0;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa1;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa2;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa3;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa4;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa5;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa6;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa7;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa8;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa9;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa10;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa11;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa12;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa13;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa14;
    reg [`CIMsFWAOutputBW-1:0] psum_fwa15;

    reg gd_tos_cm_s0;
    reg gd_aos_cm_s0;
    reg [$clog2(`OutputSRAMDepth)-1:0] gd_os_addr_cm_s0;


    always@(posedge clk)begin
        ceb_reg <= ceb;
        web_reg <= web;
        cimenb_reg <= cimenb;
        ar_sin_reg <= ar[`SinCIMAddr-1:0];
        ar_para_reg <= ar[9];        
        ca_reg <= ca;
        in_reg <= in;
        sign_reg <= sign;
        gd_tos_cm_s0 <= gd_tos_cm;
        gd_aos_cm_s0 <= gd_aos_cm;
        gd_os_addr_cm_s0 <= gd_os_addr_cm;     
        gd_tos_cm_s1 <= gd_tos_cm_s0;
        gd_aos_cm_s1 <= gd_aos_cm_s0;
        gd_os_addr_cm_s1 <= gd_os_addr_cm_s0;
    end

    always @(*) begin
        if((!cimenb_reg)&&(ceb_reg))begin // update
            if((!web_reg)&&(ar_para_reg == 0))begin
                cimenb0 <= 0; cimenb1 <= 1; web0 <= 0; web1 <= 1;
            end
            else if((!web_reg)&&(ar_para_reg == 1))begin
                cimenb0 <= 1; cimenb1 <= 0; web0 <= 1; web1 <= 0;                
            end
            else begin // check read logic
                cimenb0 <= 1; cimenb1 <= 1; web0 <= 1; web1 <= 1;                
            end
        end 
        else if((!cimenb_reg)&&(!ceb_reg))begin // compute
            cimenb0 <= 0; cimenb1 <= 0; web0 <= 1; web1 <= 1;
        end
        else begin // cimenb = 1
            cimenb0 <= 1; cimenb1 <= 1; web0 <= 1; web1 <= 1;
        end
    end

    always @(posedge clk ) begin
        fwa_sfg_reg_s0 <= ((!cimenb_reg)&&(!ceb_reg)) ? fwa_sfg_reg_s0 + 1 : 'd0;
    end

    always @(posedge clk ) begin
        fwa_sfg_reg_s1 <= fwa_sfg_reg_s0;
        cimenb_reg_s1 <= cimenb_reg;
        ceb_reg_s1 <= ceb_reg;
    end


    sin_macro um0(
        .clk(clk),
        .ceb(ceb_reg),
        .web(web0),
        .cimenb(cimenb0),
        .ar(ar_sin_reg),
        .ca(ca_reg),
        .in(in_reg[127:64]),
        .sign(sign_reg),
        .psum0_w(psum0p0a0),
        .psum1_w(psum1p0a0),
        .psum2_w(psum2p0a0),
        .psum3_w(psum3p0a0),
        .psum4_w(psum4p0a0),
        .psum5_w(psum5p0a0),
        .psum6_w(psum6p0a0),
        .psum7_w(psum7p0a0)
    );

    sin_macro um1(
        .clk(clk),
        .ceb(ceb_reg),
        .web(web1),
        .cimenb(cimenb1),
        .ar(ar_sin_reg),
        .ca(ca_reg),
        .in(in_reg[127:64]),
        .sign(sign_reg),
        .psum0_w(psum0p1a0),
        .psum1_w(psum1p1a0),
        .psum2_w(psum2p1a0),
        .psum3_w(psum3p1a0),
        .psum4_w(psum4p1a0),
        .psum5_w(psum5p1a0),
        .psum6_w(psum6p1a0),
        .psum7_w(psum7p1a0)
    );

    sin_macro um2(
        .clk(clk),
        .ceb(ceb_reg),
        .web(web0),
        .cimenb(cimenb0),
        .ar(ar_sin_reg),
        .ca(ca_reg),
        .in(in_reg[63:0]),
        .sign(sign_reg),
        .psum0_w(psum0p0a1),
        .psum1_w(psum1p0a1),
        .psum2_w(psum2p0a1),
        .psum3_w(psum3p0a1),
        .psum4_w(psum4p0a1),
        .psum5_w(psum5p0a1),
        .psum6_w(psum6p0a1),
        .psum7_w(psum7p0a1)
    );

    sin_macro um3(
        .clk(clk),
        .ceb(ceb_reg),
        .web(web1),
        .cimenb(cimenb1),
        .ar(ar_sin_reg),
        .ca(ca_reg),
        .in(in_reg[63:0]),
        .sign(sign_reg),
        .psum0_w(psum0p1a1),
        .psum1_w(psum1p1a1),
        .psum2_w(psum2p1a1),
        .psum3_w(psum3p1a1),
        .psum4_w(psum4p1a1),
        .psum5_w(psum5p1a1),
        .psum6_w(psum6p1a1),
        .psum7_w(psum7p1a1)
    );



    // inter macro adder
    assign psum_wwa0 = psum0p0a0 + psum0p0a1;
    assign psum_wwa1 = psum1p0a0 + psum1p0a1;
    assign psum_wwa2 = psum2p0a0 + psum2p0a1;
    assign psum_wwa3 = psum3p0a0 + psum3p0a1;
    assign psum_wwa4 = psum4p0a0 + psum4p0a1;
    assign psum_wwa5 = psum5p0a0 + psum5p0a1;
    assign psum_wwa6 = psum6p0a0 + psum6p0a1;
    assign psum_wwa7 = psum7p0a0 + psum7p0a1;

    assign psum_wwa8 = psum0p1a0 + psum0p1a1;
    assign psum_wwa9 = psum1p1a0 + psum1p1a1;
    assign psum_wwa10 = psum2p1a0 + psum2p1a1;
    assign psum_wwa11 = psum3p1a0 + psum3p1a1;
    assign psum_wwa12 = psum4p1a0 + psum4p1a1;
    assign psum_wwa13 = psum5p1a0 + psum5p1a1;
    assign psum_wwa14 = psum6p1a0 + psum6p1a1;
    assign psum_wwa15 = psum7p1a0 + psum7p1a1;

    always @(posedge clk ) begin
        if ((!cimenb_reg_s1)&&(!ceb_reg_s1)) begin
            psum_fwa0 <= (fwa_sfg_reg_s1==0) ? psum_wwa0 : psum_fwa0 + (psum_wwa0 << fwa_sfg_reg_s1);
            psum_fwa1 <= (fwa_sfg_reg_s1==0) ? psum_wwa1 : psum_fwa1 + (psum_wwa1 << fwa_sfg_reg_s1);
            psum_fwa2 <= (fwa_sfg_reg_s1==0) ? psum_wwa2 : psum_fwa2 + (psum_wwa2 << fwa_sfg_reg_s1);
            psum_fwa3 <= (fwa_sfg_reg_s1==0) ? psum_wwa3 : psum_fwa3 + (psum_wwa3 << fwa_sfg_reg_s1);
            psum_fwa4 <= (fwa_sfg_reg_s1==0) ? psum_wwa4 : psum_fwa4 + (psum_wwa4 << fwa_sfg_reg_s1);
            psum_fwa5 <= (fwa_sfg_reg_s1==0) ? psum_wwa5 : psum_fwa5 + (psum_wwa5 << fwa_sfg_reg_s1);
            psum_fwa6 <= (fwa_sfg_reg_s1==0) ? psum_wwa6 : psum_fwa6 + (psum_wwa6 << fwa_sfg_reg_s1);
            psum_fwa7 <= (fwa_sfg_reg_s1==0) ? psum_wwa7 : psum_fwa7 + (psum_wwa7 << fwa_sfg_reg_s1);
            psum_fwa8 <= (fwa_sfg_reg_s1==0) ? psum_wwa8 : psum_fwa8 + (psum_wwa8 << fwa_sfg_reg_s1);
            psum_fwa9 <= (fwa_sfg_reg_s1==0) ? psum_wwa9 : psum_fwa9 + (psum_wwa9 << fwa_sfg_reg_s1);
            psum_fwa10 <= (fwa_sfg_reg_s1==0) ? psum_wwa10 : psum_fwa10 + (psum_wwa10 << fwa_sfg_reg_s1);
            psum_fwa11 <= (fwa_sfg_reg_s1==0) ? psum_wwa11 : psum_fwa11 + (psum_wwa11 << fwa_sfg_reg_s1);
            psum_fwa12 <= (fwa_sfg_reg_s1==0) ? psum_wwa12 : psum_fwa12 + (psum_wwa12 << fwa_sfg_reg_s1);
            psum_fwa13 <= (fwa_sfg_reg_s1==0) ? psum_wwa13 : psum_fwa13 + (psum_wwa13 << fwa_sfg_reg_s1);
            psum_fwa14 <= (fwa_sfg_reg_s1==0) ? psum_wwa14 : psum_fwa14 + (psum_wwa14 << fwa_sfg_reg_s1);
            psum_fwa15 <= (fwa_sfg_reg_s1==0) ? psum_wwa15 : psum_fwa15 + (psum_wwa15 << fwa_sfg_reg_s1);
        end
        else begin
            psum_fwa0 <= psum_fwa0; 
            psum_fwa1 <= psum_fwa1;
            psum_fwa2 <= psum_fwa2;
            psum_fwa3 <= psum_fwa3;
            psum_fwa4 <= psum_fwa4;
            psum_fwa5 <= psum_fwa5;
            psum_fwa6 <= psum_fwa6;
            psum_fwa7 <= psum_fwa7;
            psum_fwa8 <= psum_fwa8;
            psum_fwa9 <= psum_fwa9;
            psum_fwa10 <= psum_fwa10;
            psum_fwa11 <= psum_fwa11;
            psum_fwa12 <= psum_fwa12;
            psum_fwa13 <= psum_fwa13;
            psum_fwa14 <= psum_fwa14;
            psum_fwa15 <= psum_fwa15;           
        end
    end

    assign psum_cm0 = (fwa_sfg_reg_s1 == 7) ? psum_fwa0 : psum_cm0;
    assign psum_cm1 = (fwa_sfg_reg_s1 == 7) ? psum_fwa1 : psum_cm1;
    assign psum_cm2 = (fwa_sfg_reg_s1 == 7) ? psum_fwa2 : psum_cm2;
    assign psum_cm3 = (fwa_sfg_reg_s1 == 7) ? psum_fwa3 : psum_cm3;
    assign psum_cm4 = (fwa_sfg_reg_s1 == 7) ? psum_fwa4 : psum_cm4;
    assign psum_cm5 = (fwa_sfg_reg_s1 == 7) ? psum_fwa5 : psum_cm5;
    assign psum_cm6 = (fwa_sfg_reg_s1 == 7) ? psum_fwa6 : psum_cm6;
    assign psum_cm7 = (fwa_sfg_reg_s1 == 7) ? psum_fwa7 : psum_cm7;
    assign psum_cm8 = (fwa_sfg_reg_s1 == 7) ? psum_fwa8 : psum_cm8;
    assign psum_cm9 = (fwa_sfg_reg_s1 == 7) ? psum_fwa9 : psum_cm9;
    assign psum_cm10 = (fwa_sfg_reg_s1 == 7) ? psum_fwa10 : psum_cm10;
    assign psum_cm11 = (fwa_sfg_reg_s1 == 7) ? psum_fwa11 : psum_cm11;
    assign psum_cm12 = (fwa_sfg_reg_s1 == 7) ? psum_fwa12 : psum_cm12;
    assign psum_cm13 = (fwa_sfg_reg_s1 == 7) ? psum_fwa13 : psum_cm13;
    assign psum_cm14 = (fwa_sfg_reg_s1 == 7) ? psum_fwa14 : psum_cm14;
    assign psum_cm15 = (fwa_sfg_reg_s1 == 7) ? psum_fwa15 : psum_cm15;

    assign cm_gd_en = (fwa_sfg_reg_s1 == 7) ? `GD_Enable : ~`GD_Enable;

endmodule
