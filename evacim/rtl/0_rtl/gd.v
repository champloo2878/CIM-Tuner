//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/30 14:41:33
// Design Name: 
// Module Name: gd
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

module gd(
    input clk,
    input rstn,
    input gd_en, // enable the data gathering

    input tos, // to output sram flag
    input aos, // acc with output sram

    input [`CIMsFWAOutputBW-1:0] psum0,
    input [`CIMsFWAOutputBW-1:0] psum1,
    input [`CIMsFWAOutputBW-1:0] psum2,
    input [`CIMsFWAOutputBW-1:0] psum3,
    input [`CIMsFWAOutputBW-1:0] psum4,
    input [`CIMsFWAOutputBW-1:0] psum5,
    input [`CIMsFWAOutputBW-1:0] psum6,
    input [`CIMsFWAOutputBW-1:0] psum7,
    input [`CIMsFWAOutputBW-1:0] psum8,
    input [`CIMsFWAOutputBW-1:0] psum9,
    input [`CIMsFWAOutputBW-1:0] psum10,
    input [`CIMsFWAOutputBW-1:0] psum11,
    input [`CIMsFWAOutputBW-1:0] psum12,
    input [`CIMsFWAOutputBW-1:0] psum13,
    input [`CIMsFWAOutputBW-1:0] psum14,
    input [`CIMsFWAOutputBW-1:0] psum15,

    input [$clog2(`OutputSRAMDepth)-1:0] os_addr

    // input s0~s15
    );
    reg gd_en_reg;
    reg tos_reg;
    reg tos_reg_s0;
    reg aos_reg;
    reg aos_reg_s0;

    reg [`CIMsFWAOutputBW-1:0] psum0_reg;
    reg [`CIMsFWAOutputBW-1:0] psum1_reg;
    reg [`CIMsFWAOutputBW-1:0] psum2_reg;
    reg [`CIMsFWAOutputBW-1:0] psum3_reg;
    reg [`CIMsFWAOutputBW-1:0] psum4_reg;
    reg [`CIMsFWAOutputBW-1:0] psum5_reg;
    reg [`CIMsFWAOutputBW-1:0] psum6_reg;
    reg [`CIMsFWAOutputBW-1:0] psum7_reg;
    reg [`CIMsFWAOutputBW-1:0] psum8_reg;
    reg [`CIMsFWAOutputBW-1:0] psum9_reg;
    reg [`CIMsFWAOutputBW-1:0] psum10_reg;
    reg [`CIMsFWAOutputBW-1:0] psum11_reg;
    reg [`CIMsFWAOutputBW-1:0] psum12_reg;
    reg [`CIMsFWAOutputBW-1:0] psum13_reg;
    reg [`CIMsFWAOutputBW-1:0] psum14_reg;
    reg [`CIMsFWAOutputBW-1:0] psum15_reg;

    reg [`OutputDataBW-1:0] out_reg0;
    reg [`OutputDataBW-1:0] out_reg1;
    reg [`OutputDataBW-1:0] out_reg2;
    reg [`OutputDataBW-1:0] out_reg3;
    reg [`OutputDataBW-1:0] out_reg4;
    reg [`OutputDataBW-1:0] out_reg5;
    reg [`OutputDataBW-1:0] out_reg6;
    reg [`OutputDataBW-1:0] out_reg7;
    reg [`OutputDataBW-1:0] out_reg8;
    reg [`OutputDataBW-1:0] out_reg9;
    reg [`OutputDataBW-1:0] out_reg10;
    reg [`OutputDataBW-1:0] out_reg11;
    reg [`OutputDataBW-1:0] out_reg12;
    reg [`OutputDataBW-1:0] out_reg13;
    reg [`OutputDataBW-1:0] out_reg14;
    reg [`OutputDataBW-1:0] out_reg15;

    reg os_cs_reg;
    reg os_wen_reg;
    reg [$clog2(`OutputSRAMDepth)-1:0] os_addr_reg;
    reg [`OutputSRAMWidth-1:0] os_din_reg;

    reg [1:0] tos_cnt;
    reg [1:0] aos_cnt;

    wire [`OutputSRAMWidth-1:0] os_dout;


    always @(posedge clk ) begin
        gd_en_reg <= gd_en;
        tos_reg <= tos;
        tos_reg_s0 <= tos_reg;
        aos_reg <= aos;
        aos_reg_s0 <= aos_reg;

        psum0_reg <= psum0;
        psum1_reg <= psum1;
        psum2_reg <= psum2;
        psum3_reg <= psum3;
        psum4_reg <= psum4;
        psum5_reg <= psum5;
        psum6_reg <= psum6;
        psum7_reg <= psum7; 
        psum8_reg <= psum8;
        psum9_reg <= psum9;
        psum10_reg <= psum10;
        psum11_reg <= psum11; 
        psum12_reg <= psum12;
        psum13_reg <= psum13;
        psum14_reg <= psum14;
        psum15_reg <= psum15; 

        os_addr_reg <= (gd_en == `GD_Enable) ? os_addr : os_addr_reg;

    end

    parameter IDLE = 2'd0;
    parameter ST_AOR = 2'd1;
    parameter ST_AOS = 2'd2;
    parameter ST_TOS = 2'd3;

    reg [1:0] st_next;
    reg [1:0] st_cur;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            st_cur <= 'b0;
        end
        else begin
            st_cur <= st_next;
        end
    end

    always @(posedge clk ) begin
        if (!rstn) aos_cnt <= 2'd0;
        else if (aos_cnt != 2'd0) aos_cnt <= aos_cnt -1;
        else if ((st_cur == ST_AOR)&&(st_next == ST_AOS)) aos_cnt <= 2'd3;
        else aos_cnt <= 2'd0;        
    end

    always @(posedge clk ) begin
        if (!rstn) tos_cnt <= 2'd0;
        else if (tos_cnt != 2'd0) tos_cnt <= tos_cnt -1;
        else if ((st_cur == ST_AOR)&&(st_next == ST_TOS)) tos_cnt <= 2'd1;
        else if ((st_cur == ST_AOS)&&(st_next == ST_TOS)) tos_cnt <= 2'd1;
        else tos_cnt <= 2'd0;
    end

    always@(*)begin
        case (st_cur)
            IDLE:
                case (gd_en_reg)
                    1'b0: st_next = IDLE;
                    1'b1: st_next = ST_AOR; 
                    default: st_next = IDLE;
                endcase 
            ST_AOR:
                case ({aos_reg_s0, tos_reg_s0})
                    2'b00: st_next = IDLE;
                    2'b01: st_next <= ST_TOS;
                    2'b10: st_next <= ST_AOS;
                    2'b11: st_next <= ST_AOS;
                    default: st_next = IDLE;
                endcase
            ST_TOS:
                case (tos_cnt)
                    2'b11: st_next <= ST_TOS;
                    2'b10: st_next <= ST_TOS;
                    2'b01: st_next <= ST_TOS;
                    2'b00: st_next <= IDLE;
                    default: st_next <= IDLE;
                endcase
            ST_AOS:
                case (aos_cnt)
                    2'b11: st_next <= ST_AOS;
                    2'b10: st_next <= ST_AOS;
                    2'b01: st_next <= ST_AOS;
                    2'b00: st_next <= ST_TOS; 
                    default: st_next <= IDLE;
                endcase
            default: st_next <= IDLE;
        endcase
    end



    always @(posedge clk or negedge rstn) begin
        if (!rstn)begin
            out_reg0 <= 'd0;
            out_reg1 <= 'd0;
            out_reg2 <= 'd0;
            out_reg3 <= 'd0;
            out_reg4 <= 'd0;
            out_reg5 <= 'd0;
            out_reg6 <= 'd0;
            out_reg7 <= 'd0;
            out_reg8 <= 'd0;
            out_reg9 <= 'd0;
            out_reg10 <= 'd0;
            out_reg11 <= 'd0;
            out_reg12 <= 'd0;
            out_reg13 <= 'd0;
            out_reg14 <= 'd0;
            out_reg15 <= 'd0;
            os_cs_reg <= ~`OSChipSelect_Enable;
            os_wen_reg <= ~`OSWrite_Enable;
        end
        else if (st_cur == ST_AOR) begin
            out_reg0 <= out_reg0 + psum0_reg;
            out_reg1 <= out_reg1 + psum1_reg;
            out_reg2 <= out_reg2 + psum2_reg;
            out_reg3 <= out_reg3 + psum3_reg;
            out_reg4 <= out_reg4 + psum4_reg;
            out_reg5 <= out_reg5 + psum5_reg;
            out_reg6 <= out_reg6 + psum6_reg;
            out_reg7 <= out_reg7 + psum7_reg;
            out_reg8 <= out_reg8 + psum8_reg;
            out_reg9 <= out_reg9 + psum9_reg;
            out_reg10 <= out_reg10 + psum10_reg;
            out_reg11 <= out_reg11 + psum11_reg;
            out_reg12 <= out_reg12 + psum12_reg;
            out_reg13 <= out_reg13 + psum13_reg;
            out_reg14 <= out_reg14 + psum14_reg;
            out_reg15 <= out_reg15 + psum15_reg;
            os_cs_reg <= ~`OSChipSelect_Enable;
            os_wen_reg <= ~`OSWrite_Enable;
        end

        else if ((st_cur == ST_TOS)&&(tos_cnt == 2'd1))begin
            // enable the os and write it
            os_cs_reg <= `OSChipSelect_Enable;
            os_wen_reg <= `OSWrite_Enable;
            os_din_reg <= {out_reg0, out_reg1, out_reg2, out_reg3, out_reg4, out_reg5, out_reg6, out_reg7, out_reg8, out_reg9, out_reg10, out_reg11, out_reg12, out_reg13, out_reg14, out_reg15};
        end
        else if ((st_cur == ST_TOS)&&(tos_cnt == 2'd0))begin
            out_reg0 <= 'd0;
            out_reg1 <= 'd0;
            out_reg2 <= 'd0;
            out_reg3 <= 'd0;
            out_reg4 <= 'd0;
            out_reg5 <= 'd0;
            out_reg6 <= 'd0;
            out_reg7 <= 'd0;
            out_reg8 <= 'd0;
            out_reg9 <= 'd0;
            out_reg10 <= 'd0;
            out_reg11 <= 'd0;
            out_reg12 <= 'd0;
            out_reg13 <= 'd0;
            out_reg14 <= 'd0;
            out_reg15 <= 'd0;
            os_cs_reg <= ~`OSChipSelect_Enable;
            os_wen_reg <= ~`OSWrite_Enable;
        end

        else if ((st_cur == ST_AOS)&&(aos_cnt == 2'd3))begin
            // enable the os read
            os_cs_reg <= `OSChipSelect_Enable;
            os_wen_reg <= ~`OSWrite_Enable;
        end
        else if ((st_cur == ST_AOS)&&(aos_cnt == 2'd1))begin
            // acc the outreg
            out_reg0 <= out_reg0 + os_dout[511:480];
            out_reg1 <= out_reg1 + os_dout[479:448];
            out_reg2 <= out_reg2 + os_dout[447:416];
            out_reg3 <= out_reg3 + os_dout[415:384];
            out_reg4 <= out_reg4 + os_dout[383:352];
            out_reg5 <= out_reg5 + os_dout[351:320];
            out_reg6 <= out_reg6 + os_dout[319:288];
            out_reg7 <= out_reg7 + os_dout[287:256];
            out_reg8 <= out_reg8 + os_dout[255:224];
            out_reg9 <= out_reg9 + os_dout[223:192];
            out_reg10 <= out_reg10 + os_dout[191:160];
            out_reg11 <= out_reg11 + os_dout[159:128];
            out_reg12 <= out_reg12 + os_dout[127:96];
            out_reg13 <= out_reg13 + os_dout[95:64];
            out_reg14 <= out_reg14 + os_dout[63:32];
            out_reg15 <= out_reg15 + os_dout[31:0];
        end
        else begin
            os_cs_reg <= ~`OSChipSelect_Enable;
        end

    end

    output_sram uos(
        .clk(clk),
        .rstn(rstn),
        .cs(os_cs_reg),
        .wen(os_wen_reg),
        .addr(os_addr_reg),
        .din(os_din_reg),
        .dout(os_dout)            
    );



endmodule
