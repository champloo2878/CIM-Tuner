The CIM-Tuner Repo. is consists of CIM-Compiler (C) and Top-level Simulator (Python)

To start CIM-Tuner Compiler, first

    cd ./evacim/CIMMA_Compiler

Then compile the C program:

    make

Then, you can run the try.py in CIMMA_Compiler to check the correctness of Compiling.
Linux Shell is recommanded, for other os, the run command in try.py need to be modified, as for the sim.py in evaluator


To start CIM-Tuner Simulator, back to the root path:

    cd ../..

Then you can run simple operator on accelerator by:

    python -m evacim.sim

The hardware and mapping configuration can be seen in the scripts.
Some pre-set experiments can also excuted:
For operator-level simulated annealing, run:

    python -m experiments.cim_sa_gli

For network-level simulated annealing, run:

    pyrhon -m experiments.cim_sa_model

For other experiments demonstrated in the paper, see ./experiments and ./plot

This Repo. is building, more compact and beautiful Readme is on the road.




