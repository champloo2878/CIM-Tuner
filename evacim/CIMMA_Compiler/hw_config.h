#ifndef HW_CONFIG_H
#define HW_CONFIG_H

// 定义Config结构体
typedef struct {
    int AL, PC, SCR, IS_DEPTH, OS_DEPTH, BUS_WIDTH;
    int DATA_WIDTH, RESULT_WIDTH;
    int WEIGHT_ROW, WEIGHT_COL;
    int SIN_AL, SIN_PC;
    int PIPELINE_STAGES;
    int MACRO_ROW, MACRO_COL;
    int CIM_ROW, CIM_COL;
    int CIMs_ROW, CIMs_COL;
    int CIMsComputeWidth, CIMsWriteWidth, freq;
} Config;

// 定义hwc结构体
typedef struct {
    int AL, PC, SCR, BusWidth, freq;
    int PIPELINE_STAGES;
    int CIMsWriteWidth, CIMsComputeWidth, CIMsrows;
    int MACRO_ROW, MACRO_COL, CIMsParaChannel, LocalSwitchrows;
    int InputSRAMWidth, InputSRAMDepth, OutputSRAMWidth, OutputSRAMDepth;
    int IS_size, OS_size, CIM_size;
} hwc;

void InitConfig(Config *config, int bus_width, int al, int pc, int scr, int is_depth, int os_depth, int freq);
void Inithwc(hwc *hw, Config config);

void Check(const hwc *hw);

void PrintConfig(const Config *config);
void Printhwc(const hwc *hw);

#endif // CONFIG_H
