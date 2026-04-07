//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/27 09:39:42
// Design Name: 
// Module Name: sram_sp
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


module input_sram
(
    input clk,
    input rstn,

    input cs, // 1 for sram enable
    input wen, // 1 for write, 0 for read
    
    input [$clog2(`InputSRAMDepth)-1:0] addr,
    input [`InputSRAMWidth-1:0]         din,
  
    output reg [`InputSRAMWidth-1:0]    dout   
);

    reg [`InputSRAMWidth-1:0] mem [0:`InputSRAMDepth-1];
    
    // initialize memory
    reg [14:0] i;
    initial begin
        for (i=0; i<`InputSRAMDepth; i=i+1) begin
            //if      (i[1:0]==2'b00) begin mem[i][127:0] = {128{1'b1}}; $display("success!");end
            //else if (i[1:0]==2'b01) mem[i][127:0] = {{32{1'b0}}, {32{1'b1}}, {32{1'b0}}, {32{1'b1}}};
            //else if (i[1:0]==2'b10) mem[i][127:0] = {128{1'b0}};
            //else if (i[1:0]==2'b11) mem[i][127:0] = {{32{1'b1}}, {32{1'b0}}, {32{1'b1}}, {32{1'b0}}};
            if      (i[1:0]==2'b00) begin mem[i][`InputSRAMWidth-1:0] = {(`InputSRAMWidth){1'b1}}; $display("success!");end
            else if (i[1:0]==2'b01) mem[i][`InputSRAMWidth-1:0] = {{(`InputSRAMWidth/4){1'b0}}, {(`InputSRAMWidth/4){1'b1}}, {(`InputSRAMWidth/4){1'b0}}, {(`InputSRAMWidth/4){1'b1}}};
            else if (i[1:0]==2'b10) mem[i][`InputSRAMWidth-1:0] = {(`InputSRAMWidth){1'b0}};
            else if (i[1:0]==2'b11) mem[i][`InputSRAMWidth-1:0] = {{(`InputSRAMWidth/4){1'b1}}, {(`InputSRAMWidth/4){1'b0}}, {(`InputSRAMWidth/4){1'b1}}, {(`InputSRAMWidth/4){1'b0}}};
        end
    end

    wire [`InputSRAMDepth-1:0] wen_i;


    genvar gv_i;
    generate
        for (gv_i=0; gv_i<`InputSRAMDepth; gv_i=gv_i+1) begin:Gen_SRAM_WEN
            assign wen_i[gv_i] = cs & wen & (addr==gv_i);
            always @(posedge clk) begin
                    mem[gv_i][`InputSRAMWidth-1:0] <= wen_i[gv_i] ? din:
                                                 mem[gv_i][`InputSRAMWidth-1:0];
            end
        end
    endgenerate

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            dout[`InputSRAMWidth-1:0] <= 'd0;
        else 
            dout[`InputSRAMWidth-1:0] <= (cs & ~wen) ? mem[addr][`InputSRAMWidth-1:0] : dout;
    end
    
    


endmodule