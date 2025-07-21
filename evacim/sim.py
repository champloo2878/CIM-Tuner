from subprocess import run
from evacim import cim_acc_config as ccfg
import numpy as np
import argparse

from evacim import power_modeling
from evacim import area_modeling

# inst_types = [
#         "Lin", # 0
#         "Linp", # 1
#         "Lwt", # 2
#         "Lwtp", # 3
#         "Cmpfis_aor", # 4
#         "Cmpfis_tos", # 5
#         "Cmpfis_aos", # 6
#         "Cmpfis_ptos", # 7
#         "Cmpfis_paos", # 8 
#         "Cmpfgt_aor", # 9   
#         "Cmpfgt_tos", # 10
#         "Cmpfgt_aos", # 11
#         "Cmpfgt_ptos", # 12
#         "Cmpfgt_paos", # 13
#         "Cmpfgtp", # 14
#         "Los", # 15
#         "Nop", # 16
#         "Nop_w_rd", # 17
#         "IS_reward", # 18
#         "L2_reward", # 19
#         "Fussion" # 20
#         ]


def evaluate(acc0, gli, dataflow):

   metrics = {}
   icnt = np.zeros(21)
   energy = np.zeros((19,8))
   
   rv_gli = (gli[0],(gli[1][2],gli[1][1],gli[1][0]))

   # Notation configuration
   # NR_IP_AF => isap
   # NR_IP_PF => ispp
   # NR_WP_AF => wsap
   # NR_WP_PF => wspp
   # R_IP_AF => r_isap
   # R_IP_PF => r_ispp
   # R_WP_AF => r_wsap
   # R_WP_PF => r_wspp
   if dataflow == "NR_IP_AF":
      dataflow = "isap"
   elif dataflow == "NR_IP_PF": 
      dataflow = "ispp"
   elif dataflow == "NR_WP_AF":
      dataflow = "wsap"
   elif dataflow == "NR_WP_PF":
      dataflow = "wspp"
   elif dataflow == "R_IP_AF":
      gli = rv_gli
      dataflow = "isap"
   elif dataflow == "R_IP_PF":
      gli = rv_gli
      dataflow = "ispp"
   elif dataflow == "R_WP_AF":
      gli = rv_gli
      dataflow = "wsap"
   elif dataflow == "R_WP_PF":
      gli = rv_gli
      dataflow = "wspp"
   elif dataflow == "isap" or dataflow == "ispp" or dataflow == "wsap" or dataflow == "wspp":
      pass
   else:
      raise ValueError("Invalid dataflow type. Choose from NR_IP_AF, NR_IP_PF, NR_WP_AF, NR_WP_PF, R_IP_AF, R_IP_PF, R_WP_AF, R_WP_PF, isap, ispp, wsap, wspp.")

   cmd = "./evacim/CIMMA_Compiler/compiler_count "+str(acc0.BUS_WIDTH_for_Compile)+" "+str(acc0.AL)+" "+str(acc0.PC)+" "+str(acc0.SCR)+" "+str(acc0.IS_DEPTH)+" "+str(acc0.OS_DEPTH)+" "+str(acc0.freq)+" \""+gli[0]+"\" "+str(gli[1][0])+" "+str(gli[1][1])+" "+str(gli[1][2])+" \""+dataflow+"\""
   

   cres = run(cmd, capture_output=True, text=True, shell=True, executable='/bin/bash').stdout.split()

   if cres == []: #invalid case
      metrics['ee_L2'] = 0
      metrics['energy_L2'] = 1e8
      metrics['throughput'] = 0
      metrics['area'] = [3e8 for i in range(10)]
      metrics['EDP'] = 0
      metrics['latency'] = 1e8
      metrics['op'] = 0

   elif cres[0] != "ERROR":
      for i in range(21):
         icnt[i] = cres[2*i+1]

      metrics['icnt'] = icnt

      ##### area #####
      metrics['area'] = area_modeling.area_modeling(acc0) # um2

      norm_a = acc0.cim.data_width_input*acc0.AL/acc0.CIMsComputeWidth
      norm_b = acc0.cim.data_width_weight*acc0.AL/acc0.CIMsWriteWidth


      ##### energy_L1 #####
      power = power_modeling.power_modeling(acc0)
      for i in range(18):
         if i == 2 or i == 3:
            energy[i] = power[i] * icnt[i] * 1000.0/float(acc0.freq) * norm_b
         elif i>=4 and i<=14: #Compute Norm.
            energy[i] = power[i] * icnt[i] * 1000.0/float(acc0.freq) * norm_a
         else:
            energy[i] = power[i] * icnt[i] * 1000.0/float(acc0.freq)
         
      energy[18] = np.sum(energy[0:19],axis=0)

      same_is_addr_saving = power[4][0]*icnt[18] * 1000.0/acc0.freq * norm_a
      energy[18,0] = energy[18,0] - same_is_addr_saving
      energy[18,7] = energy[18,7] - same_is_addr_saving
      
      
      metrics['energy'] = energy

      ##### latency #####
      if acc0.cim.pingpong == True:
         compute_cycle = sum(icnt[4:15]) * norm_a
         load_weight_cycle = sum(icnt[2:4]) * norm_b
         metrics['cycle'] = sum(icnt[0:2]) + compute_cycle + load_weight_cycle + sum(icnt[15:17]) - min(compute_cycle, load_weight_cycle)
         metrics['stall cycle'] = metrics['cycle'] - compute_cycle - min(compute_cycle, load_weight_cycle)
      else:
         compute_cycle = sum(icnt[4:15]) * norm_a
         load_weight_cycle = sum(icnt[2:4]) * norm_b
         metrics['cycle'] = sum(icnt[0:2]) + compute_cycle + load_weight_cycle + sum(icnt[15:17])
      metrics['latency'] = float(metrics['cycle']) * (1000.0/float(acc0.freq)) # ns


      ##### operation #####
      if gli[0] == 'proj':
         # metrics['op'] = sum(icnt[4:14])*min(acc0.AL, gli[1][1])*min(acc0.PC, gli[1][0])*2
         metrics['op'] = gli[1][0]*gli[1][1]*gli[1][2]*2
      else:
         #QK phase & PV phase
         metrics['op'] = (sum(icnt[4:14])-icnt[20])*min(acc0.AL, gli[1][1]/gli[1][2])*min(acc0.PC, gli[1][0])*2
         metrics['op'] += (icnt[20])*min(acc0.AL, gli[1][0])*min(acc0.PC, gli[1][1]/gli[1][2])*2

      ##### metrics computation #####
      ## L1 level
      metrics['ee_L1'] = float(metrics['op']) / metrics['energy'][18,7] # TOPS/W
      metrics['throughput'] = float(metrics['op']) / metrics['latency'] # GOPS
      metrics['ae_L1'] = float(metrics['throughput']) / metrics['area'][7] *1000 # TOPS/mm2

      ## GB level
      ## BUS_width: x bit
      metrics['read_bits_L2'] = (sum(icnt[0:4]) + sum(icnt[9:16]) - icnt[19] - icnt[20])*acc0.BUS_WIDTH_real
      metrics['write_bits_L2'] = (sum(icnt[7:9]) + sum(icnt[12:14]) - icnt[20])*acc0.BUS_WIDTH_real
      
      energy_L2 = (metrics['read_bits_L2'] + metrics["write_bits_L2"])*acc0.bit_energy_L2
      metrics['ee_L2'] = metrics['op'] / (metrics['energy'][18,7] + energy_L2)
      metrics['EDP'] = (metrics['energy'][18,7] + energy_L2) * metrics['latency'] / 1e12 # Unit: nJs
      metrics['energy_on_L2'] = energy_L2
      metrics['energy_L2'] = metrics['op']/metrics['ee_L2']

   else:
      pass

   return metrics


if __name__ == "__main__":

   parser = argparse.ArgumentParser()
   parser.add_argument("-c", "--cim", help="Choose the CIM cfg file")
   parser.add_argument("-p", "--paras", nargs='+', type=float, help="Set the parameters of Accelerator: BW, MR, MC, SCR, IS_SIZE, OS_SIZE")
   parser.add_argument("-o", "--operator", nargs='+', type=int , help="Set the operator sizeing: M, K, N")
   parser.add_argument("-d", "--dataflow", help="Choose one dataflow from NR_WP_AF, NR_WP_PF, NR_IP_AF, NR_IP_PF, R_WP_AF, R_WP_PF, R_IP_AF, R_IP_PF")

   args = parser.parse_args()

   cim = ccfg.CIM(args.cim)
   acc0 = ccfg.CIMACC(
      cim = cim,
      bus_width = args.paras[0], 
      macro_row = args.paras[1], 
      macro_col = args.paras[2], 
      scr = args.paras[3], 
      is_size = args.paras[4], 
      os_size = args.paras[5], 
   )


   gli = ("proj",(args.operator[0],args.operator[1],args.operator[2]))

   metrics = evaluate(acc0, gli, args.dataflow)

   print("\n####### Single Operator Evaluation ########")
   print("Total Area (mm^2):", metrics['area'][7])
   print("Total Operations:", metrics['op'])
   print("Throughputs (GOPS):", metrics['throughput'])
   print("Energy Eff. (TOPS/W):", metrics['ee_L2'])

