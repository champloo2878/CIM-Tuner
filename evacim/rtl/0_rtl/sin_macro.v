//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/26 11:14:20
// Design Name: 
// Module Name: sin_macro
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

module sin_macro(
    input clk,
    input ceb, // compute enable, 0 for compute, 1 for w&r
    input web, // write enable, 0 for write, 1 for read
    input cimenb, // cim enable, 0 for cim enable
    input [`SinCIMAddr-1:0] ar,
    input [`LocalSwitchAddr-1:0] ca,
    input [`SinCIMInputWidth-1:0] in,
    input sign,
    //weightwise adder results:
    output reg [`SinCIMInputWidth-1:0] Q, //for check read
    output [`SinCIMOutputBW-1:0] psum0_w,
    output [`SinCIMOutputBW-1:0] psum1_w,
    output [`SinCIMOutputBW-1:0] psum2_w,
    output [`SinCIMOutputBW-1:0] psum3_w,
    output [`SinCIMOutputBW-1:0] psum4_w,
    output [`SinCIMOutputBW-1:0] psum5_w,
    output [`SinCIMOutputBW-1:0] psum6_w,
    output [`SinCIMOutputBW-1:0] psum7_w
);


    reg [`SinCIMInputWidth-1:0] mem [0:`SinCIMrows]; //cmux=1
    reg ceb_reg;
    reg web_reg;
    reg cimenb_reg;
    reg [`SinCIMAddr-1:0] ar_reg;
    reg [`SinCIMInputWidth-1:0] in_reg;
    reg [`LocalSwitchAddr-1:0] ca_reg;
    reg sign_reg;
    reg [`SinCIMInputWidth-1:0] multi_res [64-1:0];

    wire [7-1:0] csum [64-1:0];

    always@(posedge clk)begin
        ceb_reg <= ceb;
        web_reg <= web;
        cimenb_reg <= cimenb;
        ar_reg <= ar;
        ca_reg <= ca;
        in_reg <= in;
        sign_reg <= sign;
    end

    //write & check read
    always @(*) begin
        if((ceb_reg)&&(!cimenb_reg))begin
            if(!web_reg)begin
                mem[ar_reg] = in_reg;
            end
            else if(web_reg)begin
                Q = mem[ar_reg];
            end
        end
    end

    integer i,j;
    always @(*) begin
        if((!ceb_reg)&&(!cimenb_reg))begin
            for(i=0;i<64;i=i+1)
                multi_res[i] = in_reg & mem[8*i+ca_reg];
        end
    end

    genvar gi;
    generate
        for(gi=0;gi<64;gi=gi+1)begin:adder64_
            adder64 u_adder64(.a(multi_res[gi]), .o(csum[gi]));
        end
    endgenerate

    wwa u_wwa_0(.csum0(csum[0]), .csum1(csum[1]), .csum2(csum[2]), .csum3(csum[3]), .csum4(csum[4]), .csum5(csum[5]), .csum6(csum[6]), .csum7(csum[7]), .psum_w(psum0_w));
    wwa u_wwa_1(.csum0(csum[8]), .csum1(csum[9]), .csum2(csum[10]), .csum3(csum[11]), .csum4(csum[12]), .csum5(csum[13]), .csum6(csum[14]), .csum7(csum[15]), .psum_w(psum1_w));
    wwa u_wwa_2(.csum0(csum[16]), .csum1(csum[17]), .csum2(csum[18]), .csum3(csum[19]), .csum4(csum[20]), .csum5(csum[21]), .csum6(csum[22]), .csum7(csum[23]), .psum_w(psum2_w));
    wwa u_wwa_3(.csum0(csum[24]), .csum1(csum[25]), .csum2(csum[26]), .csum3(csum[27]), .csum4(csum[28]), .csum5(csum[29]), .csum6(csum[30]), .csum7(csum[31]), .psum_w(psum3_w));
    wwa u_wwa_4(.csum0(csum[32]), .csum1(csum[33]), .csum2(csum[34]), .csum3(csum[35]), .csum4(csum[36]), .csum5(csum[37]), .csum6(csum[38]), .csum7(csum[39]), .psum_w(psum4_w));
    wwa u_wwa_5(.csum0(csum[40]), .csum1(csum[41]), .csum2(csum[42]), .csum3(csum[43]), .csum4(csum[44]), .csum5(csum[45]), .csum6(csum[46]), .csum7(csum[47]), .psum_w(psum5_w));
    wwa u_wwa_6(.csum0(csum[48]), .csum1(csum[49]), .csum2(csum[50]), .csum3(csum[51]), .csum4(csum[52]), .csum5(csum[53]), .csum6(csum[54]), .csum7(csum[55]), .psum_w(psum6_w));
    wwa u_wwa_7(.csum0(csum[56]), .csum1(csum[57]), .csum2(csum[58]), .csum3(csum[59]), .csum4(csum[60]), .csum5(csum[61]), .csum6(csum[62]), .csum7(csum[63]), .psum_w(psum7_w));

    endmodule


    module wwa (
        input [7-1:0] csum0,
        input [7-1:0] csum1,
        input [7-1:0] csum2,
        input [7-1:0] csum3,
        input [7-1:0] csum4,
        input [7-1:0] csum5,
        input [7-1:0] csum6,
        input [7-1:0] csum7,
        output reg [14-1:0] psum_w
    );
    always @(*) begin
        psum_w = csum0 + (csum1<<1) + (csum2<<2) +
            (csum3<<3) + (csum4<<4) + (csum5<<5) +
            (csum6<<6) + (csum7<<7);
    end
    endmodule

    module adder64 (
        input [64-1:0] a,
        output reg [7-1:0] o
    );
    wire [5-1:0] o0,o1,o2,o3;
    adder16 ad0(.a(a[15:0]), .o(o0));
    adder16 ad1(.a(a[31:16]), .o(o1));
    adder16 ad2(.a(a[47:32]), .o(o2));
    adder16 ad3(.a(a[63:48]), .o(o3));
    always @(*) begin
        o = o0 + o1 + o2 + o3;
    end
    endmodule

    module adder16 (
        input [16-1:0] a, 
        output reg [5-1:0] o
    );
    always @(*) begin
        o = a[0] + a[1] + a[2] + a[3] +
            a[4] + a[5] + a[6] + a[7] +
            a[8] + a[9] + a[10] + a[11] +
            a[12] + a[13] + a[14] + a[15];
    end
endmodule
