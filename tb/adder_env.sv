// adder_env.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

class adder_env extends uvm_env;
    `uvm_component_utils(adder_env)

    adder_agent       agent;
    adder_scoreboard  scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // [1.1] 由 adder_test::build_phase 调用
    //     创建 agent 和 scoreboard
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent      = adder_agent::type_id::create("agent", this);
        scoreboard = adder_scoreboard::type_id::create("scoreboard", this);

        // 控制权交给 UVM-phase 调度器
        // 因为 adder_env 下面多了 agent / scoreboard 节点，所以
        // 继续触发
        // adder_agent::build_phase
        // adder_scoreboard::build_phase
    endfunction

    // [2.1] 由 adder_test::connect_phase 调用
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // 将 Monitor 的输出连接到 Scoreboard
        agent.monitor.ap.connect(scoreboard.imp);
        // 调用 adder_agent::connect_phase
    endfunction
endclass