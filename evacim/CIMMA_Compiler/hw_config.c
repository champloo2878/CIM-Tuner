#include "hw_config.h"
#include <stdio.h>

void InitConfig(Config *config, int bus_width, int al, int pc, int scr, int is_depth, int os_depth, int freq) {
    config->AL = al;
    config->PC = pc;
    config->SCR = scr;
    config->IS_DEPTH = is_depth;
    config->OS_DEPTH = os_depth;
    config->BUS_WIDTH = bus_width;

    // 固定值
    config->PIPELINE_STAGES = 8;

    config->DATA_WIDTH = 8;
    config->RESULT_WIDTH = 32;

    config->WEIGHT_ROW = 4;
    config->WEIGHT_COL = 2;

    config->SIN_AL = 64;
    config->SIN_PC = 8;

    // 计算衍生数据
    config->MACRO_ROW = config->PC / config->SIN_PC;
    config->MACRO_COL = config->AL / config->SIN_AL;

    config->CIM_ROW = config->SIN_PC * config->SCR * config->WEIGHT_ROW;
    config->CIM_COL = config->SIN_AL * config->WEIGHT_COL;

    config->CIMs_ROW = config->CIM_ROW * config->MACRO_ROW;
    config->CIMs_COL = config->CIM_COL * config->MACRO_COL;

    config->CIMsComputeWidth = config->SIN_AL * config->MACRO_COL * config->DATA_WIDTH;
    config->CIMsWriteWidth = config->CIMs_COL;
    config->freq = freq;
}

void Inithwc(hwc *hw, Config config) {
    hw->AL = config.AL;
    hw->PC = config.PC;
    hw->SCR = config.SCR;
    hw->BusWidth = config.BUS_WIDTH;
    hw->freq = config.freq;
    hw->PIPELINE_STAGES = config.PIPELINE_STAGES;
    hw->CIMsWriteWidth = config.CIMsWriteWidth;
    hw->CIMsComputeWidth = config.CIMsComputeWidth;
    hw->CIMsrows = config.CIMs_ROW;
    hw->MACRO_ROW = config.MACRO_ROW;
    hw->MACRO_COL = config.MACRO_COL;
    hw->CIMsParaChannel = config.PC;
    hw->LocalSwitchrows = config.SCR;
    hw->InputSRAMWidth = config.CIMsComputeWidth;
    hw->InputSRAMDepth = config.IS_DEPTH;
    hw->OutputSRAMWidth = config.PC * config.DATA_WIDTH * 4;
    hw->OutputSRAMDepth = config.OS_DEPTH;
    hw->IS_size = hw->InputSRAMWidth * hw->InputSRAMDepth / config.DATA_WIDTH / 1024; // kB
    hw->OS_size = hw->OutputSRAMWidth * hw->OutputSRAMDepth / config.DATA_WIDTH / 1024; // kB
    hw->CIM_size = config.CIMs_ROW * config.CIMs_COL / config.DATA_WIDTH / 1024; // kB
}

void Check(const hwc *hw) {
    printf("AXI Width: %d\n", hw->BusWidth);
    printf("IS Size  : %d kB\n", hw->IS_size);
    printf("OS Size  : %d kB\n", hw->OS_size);
    printf("CIM Size : %d kB\n", hw->CIM_size);
    // printf("IS Size  : %.2f kB\n", hw->IS_size);
    // printf("OS Size  : %.2f kB\n", hw->OS_size);
    // printf("CIM Size : %.2f kB\n", hw->CIM_size);
}

// 打印Config结构体的内容
void PrintConfig(const Config *config) {
    printf("Config:\n");
    printf("AL: %d,\tPC: %d,\tSCR: %d,\tIS_DEPTH: %d,\tOS_DEPTH: %d,\tBUS_WIDTH: %d\n", config->AL, config->PC, config->SCR, config->IS_DEPTH, config->OS_DEPTH, config->BUS_WIDTH);
    printf("PIPELINE_STAGES: %d,\n", config->PIPELINE_STAGES);
    printf("DATA_WIDTH: %d,\tRESULT_WIDTH: %d\n", config->DATA_WIDTH, config->RESULT_WIDTH);
    printf("WEIGHT_ROW: %d,\tWEIGHT_COL: %d\n", config->WEIGHT_ROW, config->WEIGHT_COL);
    printf("SIN_AL: %d,\tSIN_PC: %d\n", config->SIN_AL, config->SIN_PC);
    printf("MACRO_ROW: %d,\tMACRO_COL: %d\n", config->MACRO_ROW, config->MACRO_COL);
    printf("CIM_ROW: %d,\tCIM_COL: %d\n", config->CIM_ROW, config->CIM_COL);
    printf("CIMs_ROW: %d,\tCIMs_COL: %d\n", config->CIMs_ROW, config->CIMs_COL);
    printf("CIMsComputeWidth: %d,\tCIMsWriteWidth: %d,\tfreq: %d\n", config->CIMsComputeWidth, config->CIMsWriteWidth, config->freq);
}

// 打印hwc结构体的内容
void Printhwc(const hwc *hw) {
    printf("hwc:\n");
    printf("AL: %d, PC: %d, SCR: %d, BusWidth: %d, freq: %d\n", hw->AL, hw->PC, hw->SCR, hw->BusWidth, hw->freq);
    printf("PIPELINE_STAGES: %d,\n", hw->PIPELINE_STAGES);
    printf("CIMsWriteWidth: %d, CIMsComputeWidth: %d, CIMsrows: %d\n", hw->CIMsWriteWidth, hw->CIMsComputeWidth, hw->CIMsrows);
    printf("MACRO_ROW: %d, MACRO_COL: %d, CIMsParaChannel: %d, LocalSwitchrows: %d\n", hw->MACRO_ROW, hw->MACRO_COL, hw->CIMsParaChannel, hw->LocalSwitchrows);
    printf("InputSRAMWidth: %d, InputSRAMDepth: %d, OutputSRAMWidth: %d, OutputSRAMDepth: %d\n", hw->InputSRAMWidth, hw->InputSRAMDepth, hw->OutputSRAMWidth, hw->OutputSRAMDepth);
    // printf("IS_size: %.2f kB, OS_size: %.2f kB, CIM_size: %.2f kB\n", hw->IS_size, hw->OS_size, hw->CIM_size);
    printf("IS_size: %d kB, OS_size: %d kB, CIM_size: %d kB\n", hw->IS_size, hw->OS_size, hw->CIM_size);
}