//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 10:48:27
// Design Name: 
// Module Name: fd
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

module fd(
    input clk, 
    input rstn,
    // ctrl_fd
    input fd_go_through, // 1 for go through, 0 for is operation
    input is_wen, // fd_go_through=0, 1 for load is, 0 for is2cim
    input [$clog2(`InputSRAMDepth)-1:0] is_addr,
    // ctrl_cm
    input cm_ceb,
    input cm_web,
    input cm_cimenb,
    input [`CIMsAddr-1:0] cm_ar,
    input [`LocalSwitchAddr-1:0] cm_ca,
    // ctrl_gd
    input gd_tos,
    input gd_aos,
    input [$clog2(`OutputSRAMDepth)-1:0] gd_os_addr,

    // input_data
    input [`FDInputWidth-1:0] din,

    //output_ctrl
    output reg cm_ceb_fd_s1,
    output reg cm_web_fd_s1,
    output reg cm_cimenb_fd_s1,
    output reg [`CIMsAddr-1:0] cm_ar_fd_s1,
    output reg [`LocalSwitchAddr-1:0] cm_ca_fd_s1,
    // output sign,
    output reg gd_tos_fd_s1,
    output reg gd_aos_fd_s1,
    output reg [$clog2(`OutputSRAMDepth)-1:0] gd_os_addr_fd_s1,
    
    //output_data
    output [`FDOutputWidth-1:0] dout
);

    reg fd_go_through_reg_s0;
    reg is_wen_reg_s0;
    reg [$clog2(`InputSRAMDepth)-1:0] is_addr_reg_s0;
    reg [`FDInputWidth-1:0] din_s0;
    reg cm_ceb_fd_s0;
    reg cm_web_fd_s0;
    reg cm_cimenb_fd_s0;
    reg [`CIMsAddr-1:0] cm_ar_fd_s0;
    reg [`LocalSwitchAddr-1:0] cm_ca_fd_s0;

    reg gd_tos_fd_s0;
    reg gd_aos_fd_s0;
    reg [$clog2(`OutputSRAMDepth)-1:0] gd_os_addr_fd_s0;

    reg fd_go_through_reg_s1;
    reg is_wen_reg_s1;
    reg [`FDInputWidth-1:0] din_s1;
    
    reg [`FDOutputWidth-1:0] dout_reg;

    always @(posedge clk ) begin
        fd_go_through_reg_s0 <= fd_go_through;
        is_wen_reg_s0 <= is_wen;
        is_addr_reg_s0 <= is_addr;
        din_s0 <= din;
        // for cm
        cm_ceb_fd_s0 <= cm_ceb;
        cm_web_fd_s0 <= cm_web;
        cm_cimenb_fd_s0 <= cm_cimenb;
        cm_ar_fd_s0 <= cm_ar;
        cm_ca_fd_s0 <= cm_ca;
        // for gd
        gd_tos_fd_s0 <= gd_tos;
        gd_aos_fd_s0 <= gd_aos;
        gd_os_addr_fd_s0 <= gd_os_addr;
    end

    always @(posedge clk ) begin
        fd_go_through_reg_s1 <= fd_go_through_reg_s0;
        is_wen_reg_s1 <= is_wen_reg_s0;
        din_s1 <= din_s0;
        // for cm
        cm_ceb_fd_s1 <= cm_ceb_fd_s0;
        cm_web_fd_s1 <= cm_web_fd_s0;
        cm_cimenb_fd_s1 <= cm_cimenb_fd_s0;
        cm_ar_fd_s1 <= cm_ar_fd_s0;
        cm_ca_fd_s1 <= cm_ca_fd_s0;
        //for gd
        gd_tos_fd_s1 <= gd_tos_fd_s0;
        gd_aos_fd_s1 <= gd_aos_fd_s0;
        gd_os_addr_fd_s1 <= gd_os_addr_fd_s0;        
    end    

    // signals for IS, IS is in s0
    reg is_cs;
    reg [`InputSRAMWidth-1:0] is_din;
    wire [`InputSRAMWidth-1:0] is_dout;

    always @(*) begin //
        is_cs <= fd_go_through_reg_s0 ? ~(`ISChipSelect_Enable) : `ISChipSelect_Enable;
        is_din <= (fd_go_through_reg_s0 != `FDGoThrough_Enable)&&(is_wen_reg_s0 == 1) ? din_s0 : is_din;
    end

    input_sram uis(
        .clk(clk),
        .rstn(rstn),
        .cs(is_cs),
        .wen(is_wen_reg_s0),
        .addr(is_addr_reg_s0),
        .din(is_din),
        .dout(is_dout)            
    );

    always @(*) begin
        if (fd_go_through_reg_s1 == `FDGoThrough_Enable) dout_reg <= din_s1;
        else if (is_wen_reg_s1==0) dout_reg <= is_dout;
        else dout_reg <= dout_reg;        
    end
    assign dout = dout_reg;


endmodule
