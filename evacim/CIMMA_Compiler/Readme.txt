## CIMMA ISA

### Load Type Instruction
1. **Lin** pos is-addr
Description: Load a input vector from external Bus. The *pos* flag is for the mismatching of internal input data bus and externel BW. The *is-addr* stands for the denstionation address of Input SRAM.

2. **Lwt** pos cim-addr
Description: Load a weight vector from external Bus. The *pos* flag is for the mismatching of internal weight update bus and external BW. The *cim-addr* stands for the CIM address.

3. **Lpenalty**
Description: Load psum from the external Bus, when the Output SRAM is not enough for psum buffering.

### Compute Type
1. Cmpfis is-addr ca ATOS
Description: CIM Compute and the input data is from Input SRAM[is-addr]. *ca* stands for compute address, selecting from *SCR* weights. *ATOS* is control flag for Output SRAM and explained below.

2. Cmpfgt pos ca ATOS
Description: CIM Compute and the input data is from external Bus. *pos* is needed as the same reason of **Lwt**.

### ATOS flag
1. <aor> : Add the psum with data in accumulator register which is generated last cycle.
2. <tos> : Add the psum with data in accumualtor register and send the psum to Output SRAM. Then empty the accumulator register.
3. <aos> os-addr : Add the psum with data in accumulator register and add with the psum read from Output SRAM. The send to the same position and empty the register.
4. <ptos> : Add the psum with data in accumulator register and send the psum to external Bus.
5. <paso> : Add the psum from both register and Output SRAM, and send the psum to external Bus. 




