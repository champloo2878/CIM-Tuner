//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/26 11:19:02
// Design Name: 
// Module Name: defines
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

// fd config
`define InputSRAMDepth 1024
`define InputSRAMWidth 128
`define FDInputWidth 128
`define FDOutputWidth 128
`define FDGoThrough_Enable 1
`define ISChipSelect_Enable 1
`define ISWrite_Enable 1


// single macro paras:
`define SinCIMAddr 9
`define SinCIMrows 2**`SinCIMAddr
`define LocalSwitchAddr 3
`define LocalSwitchrows 2**`LocalSwitchAddr
`define SinCIMInputWidth 64
`define SinCIMOutputBW 14 //wwa psum bw


// macros config:
`define NumParaCIM = 2
`define NumAccCIM = 2
`define CIMsAddr 10 //********
`define CIMsrows 1024
`define CIMsInputWidth 128
`define CIMsWWAOutputBW 15 //******** // wwa 15, wwa+fwa 23
`define CIMsFWAOutputBW 23
`define FeatureWiseAdderTimes 8
`define CIMCompute_Enable 0
`define CIMWrite_Enable 0
`define CIMEnable_Enable 0

//gd config
`define OutputSRAMDepth 1024
`define OutputSRAMWidth 512
`define OSChipSelect_Enable 1
`define OSWrite_Enable 1
`define GD_Enable 1
`define TOS_Enable 1
`define AOS_Enable 1
`define OutputDataBW 32

//top instruction config
`define InstructionWidth 28

`define LoadIS 3'b000
`define WeightUpdate 3'b001
`define ComputeFIS 3'b010
`define ComputeGT 3'b011
`define NOP 3'b111


