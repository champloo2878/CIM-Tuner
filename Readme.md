The CIM-Tuner Repo. is consists of Bottom-level CIMMA-Compiler (C) and Top-level Simulator (Python)
The project is built under Unbuntu 22.04, gcc 11.4.0 and python 3.12.4.
## 1 CIMMA-Compiler Setup
To start CIM-Tuner Compiler, first compile the CIMMA-Compiler: 
```bash
    cd ./evacim/CIMMA_Compiler
```
Then compile the C program:
```bash
    make
```

Then, you can run the try.py in ./evacim/CIMMA_Compiler to check the result.

For instruction visualization, set the 12 th row in compiler_count.c:
```c
    #define WRITE_INST 1
```
Then, make again and run try.py. The complied instructions are wrote to ./Result/inst.txt.
For faster running, it is recommended to set WRITE_INST to 0 when doing top-level simulations.

## 2 Simulator and Evaluation Setup
To start CIM-Tuner Simulator, back to the CIM-Tuner root:
```bash
    cd ../..
```

Then you can run simple operator on accelerator by:
```bash
    python3 -m evacim.sim --cim ./cim_config/FPCIM@ISSCC23.cfg --para 25.6 2 2 16 128 64 --operator 256 512 256 --dataflow R_WP_PF
```
Run this command for the parameters meaning at different position: 
```bash
    python3 -m evacim.sim --help
``` 

Also the whole model evaluation can run by:
```bash
    python3 -m evacim.sw_func --cim ./cim_config/FPCIM@ISSCC23.cfg --paras 25.6 2 2 16 64 64 --model nn_config/bert_base_sl64.csv --target th
```

## 3 Hardware-Mapping Co-exploration
For operator-level exploration, run:
```bash
    python3 -m experiments.cim_sa_gli
```
This script explores the accelerator architecture of FPCIM@ISSCC23 under fixed operator and dataflow. The optimal target is throughput and area constraint is 5 mm^2. The annealing progress is shown: 
![single_operator_sa](./plot/sa_gli.png)

For network-level simulated annealing, run:
```bash
    python3 -m experiments.cim_sa_model
```
This script explores both the architecture and mapping strategies of FPCIM based accelerator on Bert_base. The optimal target is energy efficiency and area constraint is 5 mm^2. For other configurations, directly revise the script. The example annealing is shown:
![model_sa](./plot/sa_model.png)

For other experiments demonstrated in the paper, see ./experiments and ./plot




