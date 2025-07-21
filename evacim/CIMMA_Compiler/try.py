from subprocess import run
import numpy as np

# (bus_width, al, pc, scr, is_depth, os_depth)
acc0 = (128, 128, 64, 16, 1024, 2048)
freq = 500

# gli[0]: proj / a2a
# gli[1]: proj: (weight_channel, total_acc_length, input_channel)
#         a2a : (seq_len, hidden_size, head_num)
gli = ("proj",(128,128,128))

# proj: 'is-/ws-' + 'ap/pp'
# a2a : '2ph'/'lhd'
dataflow = 'ispp'


cmd = "./compiler_count "+str(acc0[0])+" "+str(acc0[1])+" "+str(acc0[2])+" "+str(acc0[3])+" "+str(acc0[4])+" "+str(acc0[5])+" "+str(freq)+" \""+gli[0]+"\" "+str(gli[1][0])+" "+str(gli[1][1])+" "+str(gli[1][2])+" \""+dataflow+"\""
print(cmd)


cres = run(cmd, capture_output=True, text=True, shell=True, executable="/bin/bash").stdout.split() # attention the print format in .c

print(cres)

