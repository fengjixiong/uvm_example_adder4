// adder_test.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

class adder_test extends uvm_test;
    `uvm_component_utils(adder_test)

    adder_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // [1.0] 这是 UVM 组件树的构建阶段，从根节点（Test）往下递归创建所有子组件
    // build_phase 调用顺序（递归深度优先）
    // adder_test.build_phase()
    //     │
    //     ├── 创建 env
    //     └── adder_env.build_phase()
    //             │
    //             ├── 创建 agent
    //             └── adder_agent.build_phase()
    //                     │
    //                     ├── 创建 driver
    //                     ├── 创建 sequencer
    //                     └── 创建 monitor
    //                         │
    //                         ├── adder_driver.build_phase() ← 获取 vif
    //                         └── adder_monitor.build_phase() ← 获取 vif
    function void build_phase(uvm_phase phase);
        virtual adder_if vif;
        super.build_phase(phase);
        env = adder_env::type_id::create("env", this);

        // 从顶层模块获取接口并存入配置数据库
        // 不要用 assert，可能会忽略
        // assert(uvm_config_db#(virtual adder_if)::get(null, "", "vif", vif));
        if(!uvm_config_db#(virtual adder_if)::get(null, "", "vif", vif)) begin
            `uvm_fatal("GET_VIF","Can NOT get virtual adder_if with key=vif")
        end
        uvm_config_db#(virtual adder_if)::set(this, "env.agent.*", "vif", vif);

        // 控制权交给 UVM-phase 调度器
        // 因为 adder_test 下面多了一个 env 节点，所以
        // 继续触发 adder_env::build_phase
    endfunction

    // [2.0] UVM Phase 调度器在做完 build_phase 后，来到这里
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // 继续触发 adder_env::connect_phase
    endfunction

    // [3.0] 启动 Sequence，所有组件的run_phase并行执行
    task run_phase(uvm_phase phase);
        adder_sequence seq = adder_sequence::type_id::create("seq");
        virtual adder_if vif;

        `uvm_info("TEST_RUN","Enter run_phase !!!",UVM_LOW)
        phase.raise_objection(this);  // 防止仿真提前结束

        if(!uvm_config_db#(virtual adder_if)::get(null, "", "vif", vif)) begin
            `uvm_fatal("GET_VIF","Can NOT get vif")
        end

        // 轮询查询复位电平，不使用@posedge边沿，规避verilator事件丢失
        while(vif.rst_n !== 1'b1) begin
            #1; // 前进1时间单位，轮询
        end

        // UVM + verilator 这里有bug，不能在这里start
        seq.start(env.agent.sequencer);  // 在 sequencer 上启动序列
        `uvm_info("TEST_RUN","After seq.start()",UVM_LOW)

        #300; // 等待足够时间，让DUT处理完所有10笔激励
        phase.drop_objection(this);
    endtask
endclass