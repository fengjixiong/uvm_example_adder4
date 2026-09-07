使用说明

1. 前置条件
Verilator 5.0+：需要支持 --timing 选项和 UVM 所需的高级特性
系统依赖：bison, flex, libfl-dev, help2man, z3, g++, make

bash
# Ubuntu/Debian 安装依赖
sudo apt install -y bison flex libfl-dev help2man z3 git autoconf make g++ perl

2. 安装最新 Verilator
bash
git clone https://github.com/verilator/verilator
cd verilator
autoconf
./configure
make -j $(nproc)
sudo make install

3. 下载UVM代码:
wget https://www.accellera.org/images/downloads/standards/uvm/UVM-1800.2-2020.3.1.tar.gz
tar -xvzf UVM-1800.2-2020.3.1.tar.gz


4. 编译运行
./run.sh

5.清理
make clean



与 VCS 版本的关键区别
方面        VCS Makefile             Verilator Makefile
编译原理    直接编译 SystemVerilog    先翻译为 C++，再编译为可执行文件
UVM 支持    内置 UVM 库              需手动下载 Accellera 开源 UVM 源码
关键宏      -ntb_opts uvm-1.2        +define+UVM_NO_DPI（禁用 DPI）
波形生成    +vcd+vcdpluson           --trace 选项
性能        事件驱动，适合复杂时序    周期驱动，吞吐量高但部分特性受限

注意：Verilator 对 UVM 的支持正在快速发展中。Antmicro 等团队已让 Verilator 5.x 能够无补丁地运行 UVM 2017-1.0。如果您遇到编译问题，建议使用 Verilator 最新主分支版本。此外，Verilator 不支持 covergroup 功能覆盖率结构，需用自定义数组替代。


2026.9.2
编译成功
- V e r i l a t i o n   R e p o r t: Verilator 5.043 devel rev vUNKNOWN-built20251229
- Verilator: Built from 42.836 MB sources in 342 modules, into 16.080 MB in 1340 C++ files needing 30.187 MB
- Verilator: Walltime 158.266 s (elab=0.662, cvt=5.727, bld=145.508); cpu 10.312 s on 12 threads; alloced 1043.617 MB
Build completed! Executable: /mnt/e/code/JLogic/test/UVM/uvm_example_adder4/obj_dir/Vtb_top

编译要点：
复盘下这一路踩过的坑，给你总结一份 Verilator+UVM‑1.2 (chipsalliance 版本) 的避坑清单：
virtual interface 不能在 function/task 内部做局部变量**（VCS/Questa 可以，Verilator5.x 不支持），必须提升为 class 成员变量，或者放在函数开头。
Makefile 不要重复加载源文件，‑f filelist.f和命令行传文件列表不能同时开启，否则大量 class/module 重复定义。
每一个含有 UVM class 的 sv 文件头部都必须写**
import uvm_pkg::*;
include "uvm_macros.svh"
传统仿真器只需要 top 加一次，Verilator 每个文件要独立导入包，否则找不到 uvm 基类。
config_db 存取接口类型统一为`virtual adder_if`，不能直接写 interface 类型。
使用uvm‑verilator(chipsalliance)分支，不要直接用 Accellera 原生 UVM‑1.2；命令行带上UVM_NO_DPI等一组宏关闭 DPI 接口。
tb_top 模块内部同样要 import uvm_pkg，否则`run_test()`识别不到。
