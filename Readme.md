# CIM-Tuner Repository

This repository consists of:
- **CIMMA-Compiler** (C-based bottom-level compiler)
- **Simulator** (Python-based top-level simulator)

## System Requirements
- **OS**: Ubuntu 22.04
- **Compiler**: gcc 11.4.0
- **Python**: 3.12.4

---

## 1. CIMMA-Compiler Setup

### Compilation Steps
1. Navigate to the compiler directory:
   bash
   cd ./evacim/CIMMA_Compiler

   
2. Compile the C program:
   bash
   make


### Testing & Verification
- Run the test script to validate compilation:
  bash
   python3 try.py


### Instruction Visualization
1. Enable instruction writing in `compiler_count.c`:
   c
   #define WRITE_INST 1  // Enable instruction logging


2. Recompile and run:
   bash
   make && python3 try.py

   
   Compiled instructions will be saved to `./Result/inst.txt`.

> **Note**: For performance during top-level simulations, disable visualization by setting `WRITE_INST` to `0`.

---

## 2. Simulator and Evaluation Setup

### Basic Operation
Return to the root directory:
bash
cd ../..


Run a single accelerator operation:
bash
python3 -m evacim.sim \
    --cim ./cim_config/FPCIM@ISSCC23.cfg \
    --para 25.6 2 2 16 128 64 \
    --operator 256 512 256 \
    --dataflow R_WP_PF


### Parameter Reference
View all parameter options:
bash
python3 -m evacim.sim --help


### Full Model Evaluation
Run an end-to-end evaluation:
bash
python3 -m evacim.sw_func \
    --cim ./cim_config/FPCIM@ISSCC23.cfg \
    --paras 25.6 2 2 16 64 64 \
    --model nn_config/bert_base_sl64.csv \
    --target th


---

## 3. Hardware-Mapping Co-exploration

### Operator-Level Exploration
bash
python3 -m experiments.cim_sa_gli

- **Purpose**: Optimize accelerator architecture (FPCIM@ISSCC23) for fixed operator/dataflow
- **Target**: Maximize throughput with ¡Ü5 mm? area constraint
- **Output**:  
  ![Single Operator SA](./plot/sa_gli.png)

### Network-Level Exploration
bash
python3 -m experiments.cim_sa_model

- **Purpose**: Joint optimization of architecture and mapping strategies for BERT-base
- **Target**: Maximize energy efficiency with ¡Ü5 mm? area constraint
- **Output**:  
  ![Model SA](./plot/sa_model.png)

### Additional Experiments
- View all paper experiments in `./experiments`
- Access result visualizations in `./plot`

---

## Troubleshooting Tips
- If encountering Git push errors (`non-fast-forward`), always pull remote changes first:
  bash
  git pull origin main

- Reset to remote state if needed:
  bash
  git fetch origin
  git reset --hard origin/main