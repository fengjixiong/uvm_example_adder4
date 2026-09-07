#/bin/bash
# 20260902 fengjx
# run OK!

make -f Makefile_verilator build
make -f Makefile_verilator run_wave > result.log
python format_uvm_log.py result.log > result_format.log
cat result_format.log

# run in mobarxterm
gtkwave wave.vcd