//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/02 17:07:40
// Design Name: 
// Module Name: top
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

module top(
    input clk,
    input rstn,
    
    input [`InstructionWidth-1:0] instruction,
    
    input [`InputSRAMWidth-1:0] din
    );

    reg [`InstructionWidth-1:0] instruction_reg;
    reg [`InputSRAMWidth-1:0] din_reg;

    wire [3:0] op_code;
    wire [9:0] addr0;
    wire [2:0] ca;
    wire [1:0] taos_fg;
    wire [9:0] addr1;

    assign op_code = instruction_reg[27:25];
    assign addr0 = instruction_reg[24:15];
    assign ca = instruction_reg[14:12];
    assign taos_fg = instruction_reg[11:10];
    assign addr1 = instruction_reg[9:0];


    reg FD_GO_THROUGH;
    reg IS_WEN;
    reg [$clog2(`InputSRAMDepth)-1:0] IS_ADDR;
    reg CM_CEB;
    reg CM_WEB;
    reg CM_CIMENB;
    reg [`CIMsAddr-1:0] CM_AR;
    reg [`LocalSwitchAddr-1:0] CM_CA;

    reg GD_TOS;
    reg GD_AOS;
    reg [$clog2(`OutputSRAMDepth)-1:0] GD_OS_ADDR;

    wire CM_CEB_FD_S1;
    wire CM_WEB_FD_S1;
    wire CM_CIMENB_FD_S1;
    wire [`CIMsAddr-1:0] CM_AR_FD_S1;
    wire [`LocalSwitchAddr-1:0] CM_CA_FD_S1;

    wire [`FDOutputWidth-1:0] FD_DOUT;

    wire GD_TOS_CM;
    wire GD_AOS_CM;
    wire [$clog2(`OutputSRAMDepth)-1:0] GD_OS_ADDR_CM;

    wire GD_TOS_CM_S1;
    wire GD_AOS_CM_S1;
    wire [$clog2(`OutputSRAMDepth)-1:0] GD_OS_ADDR_CM_S1;

    wire GD_EN_CM;
    wire [`CIMsFWAOutputBW-1:0] psum0;
    wire [`CIMsFWAOutputBW-1:0] psum1;
    wire [`CIMsFWAOutputBW-1:0] psum2;
    wire [`CIMsFWAOutputBW-1:0] psum3;
    wire [`CIMsFWAOutputBW-1:0] psum4;
    wire [`CIMsFWAOutputBW-1:0] psum5;
    wire [`CIMsFWAOutputBW-1:0] psum6;
    wire [`CIMsFWAOutputBW-1:0] psum7;

    wire [`CIMsFWAOutputBW-1:0] psum8;
    wire [`CIMsFWAOutputBW-1:0] psum9;
    wire [`CIMsFWAOutputBW-1:0] psum10;
    wire [`CIMsFWAOutputBW-1:0] psum11;
    wire [`CIMsFWAOutputBW-1:0] psum12;
    wire [`CIMsFWAOutputBW-1:0] psum13;
    wire [`CIMsFWAOutputBW-1:0] psum14;
    wire [`CIMsFWAOutputBW-1:0] psum15;

    always @(posedge clk ) begin
        instruction_reg <= instruction;
        din_reg <= din;
    end

    // instruction decoder
    always @(*) begin
        case (op_code)
            `LoadIS:begin
                //fd ctrls
                FD_GO_THROUGH <= ~`FDGoThrough_Enable;
                IS_WEN <= `ISWrite_Enable;
                IS_ADDR <= addr0;
                //cm ctrls
                CM_CEB <= ~`CIMCompute_Enable;
                CM_WEB <= ~`CIMWrite_Enable;
                CM_CIMENB <= ~`CIMEnable_Enable;
                CM_AR <= 'd0;
                CM_CA <= 'd0;
                // gd ctrls
                GD_TOS <= 'd0;
                GD_AOS <= 'd0;
                GD_OS_ADDR <= 'd0;               
            end
            `WeightUpdate:begin
                //fd ctrls
                FD_GO_THROUGH <= `FDGoThrough_Enable;
                IS_WEN <= ~`ISWrite_Enable;
                IS_ADDR <= 'd0;
                //cm ctrls
                CM_CEB <= ~`CIMCompute_Enable;
                CM_WEB <= `CIMWrite_Enable;
                CM_CIMENB <= `CIMEnable_Enable;
                CM_AR <= addr0;
                CM_CA <= 'd0;
                // gd ctrls
                GD_TOS <= 'd0;
                GD_AOS <= 'd0;
                GD_OS_ADDR <= 'd0;               
            end
            `ComputeFIS:begin
                //fd ctrls
                FD_GO_THROUGH <= ~`FDGoThrough_Enable;
                IS_WEN <= ~`ISWrite_Enable;
                IS_ADDR <= addr0;
                //cm ctrls
                CM_CEB <= `CIMCompute_Enable;
                CM_WEB <= ~`CIMWrite_Enable;
                CM_CIMENB <= `CIMEnable_Enable;
                CM_AR <= 'd0;
                CM_CA <= ca;
                // gd ctrls
                GD_TOS <= taos_fg[1];
                GD_AOS <= taos_fg[0];
                GD_OS_ADDR <= addr1;         
            end
            `ComputeGT:begin
                //fd ctrls
                FD_GO_THROUGH <= `FDGoThrough_Enable;
                IS_WEN <= ~`ISWrite_Enable;
                IS_ADDR <= 'd0;
                //cm ctrls
                CM_CEB <= `CIMCompute_Enable;
                CM_WEB <= ~`CIMWrite_Enable;
                CM_CIMENB <= `CIMEnable_Enable;
                CM_AR <= 'd0;
                CM_CA <= ca;
                // gd ctrls
                GD_TOS <= taos_fg[1];
                GD_AOS <= taos_fg[0];
                GD_OS_ADDR <= addr1;
            end 
            `NOP:begin
                //fd ctrls
                FD_GO_THROUGH <= ~`FDGoThrough_Enable;
                IS_WEN <= ~`ISWrite_Enable;
                IS_ADDR <= 'd0;
                //cm ctrls
                CM_CEB <= ~`CIMCompute_Enable;
                CM_WEB <= ~`CIMWrite_Enable;
                CM_CIMENB <= ~`CIMEnable_Enable;
                CM_AR <= 'd0;
                CM_CA <= 'd0;
                // gd ctrls
                GD_TOS <= 'd0;
                GD_AOS <= 'd0;
                GD_OS_ADDR <= 'd0;
            end
            default: begin
                //fd ctrls
                FD_GO_THROUGH <= ~`FDGoThrough_Enable;
                IS_WEN <= ~`ISWrite_Enable;
                IS_ADDR <= 'd0;
                //cm ctrls
                CM_CEB <= ~`CIMCompute_Enable;
                CM_WEB <= ~`CIMWrite_Enable;
                CM_CIMENB <= ~`CIMEnable_Enable;
                CM_AR <= 'd0;
                CM_CA <= 'd0;
                // gd ctrls
                GD_TOS <= 'd0;
                GD_AOS <= 'd0;
                GD_OS_ADDR <= 'd0;
            end 
        endcase
    end

    fd ufd(
        .clk(clk),
        .rstn(rstn),
        .fd_go_through(FD_GO_THROUGH),
        .is_wen(IS_WEN),
        .din(din_reg),
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
        .gd_tos(GD_TOS),
        .gd_aos(GD_AOS),
        .gd_os_addr(GD_OS_ADDR),
        .dout(FD_DOUT),
        .gd_tos_fd_s1(GD_TOS_CM),
        .gd_aos_fd_s1(GD_AOS_CM),
        .gd_os_addr_fd_s1(GD_OS_ADDR_CM)
    );

    macros u_macros(
        .clk(clk),
        .ceb(CM_CEB_FD_S1),
        .web(CM_WEB_FD_S1),
        .cimenb(CM_CIMENB_FD_S1),
        .ar(CM_AR_FD_S1),
        .ca(CM_CA_FD_S1),
        .in(FD_DOUT),        
        .gd_tos_cm(GD_TOS_CM),
        .gd_aos_cm(GD_AOS_CM),
        .gd_os_addr_cm(GD_OS_ADDR_CM),
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
        .cm_gd_en(GD_EN_CM),
        .gd_tos_cm_s1(GD_TOS_CM_S1),
        .gd_aos_cm_s1(GD_AOS_CM_S1),
        .gd_os_addr_cm_s1(GD_OS_ADDR_CM_S1)
    );

    gd ugd(
        .clk(clk),
        .rstn(rstn),
        .gd_en(GD_EN_CM),
        .tos(GD_TOS_CM_S1),
        .aos(GD_AOS_CM_S1),
        .os_addr(GD_OS_ADDR_CM_S1),
        .psum0(psum0),
        .psum1(psum1),
        .psum2(psum2),
        .psum3(psum3),
        .psum4(psum4),
        .psum5(psum5),
        .psum6(psum6),
        .psum7(psum7),
        .psum8(psum8),
        .psum9(psum9),
        .psum10(psum10),
        .psum11(psum11),
        .psum12(psum12),
        .psum13(psum13),
        .psum14(psum14),
        .psum15(psum15)
    );

endmodule
