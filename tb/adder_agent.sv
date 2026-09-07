// adder_agent.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

class adder_agent extends uvm_agent;
    `uvm_component_utils(adder_agent)

    adder_driver      driver;
    adder_sequencer   sequencer;
    adder_monitor     monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // [1.2] 在 adder_env::build_phase 之后调用
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver    = adder_driver::type_id::create("driver", this);
        sequencer = adder_sequencer::type_id::create("sequencer", this);
        monitor   = adder_monitor::type_id::create("monitor", this);

        // 控制权交给 UVM-phase 调度器
        // 因为 adder_agent 下面多了 driver/sequencer/monitor 节点，所以
        // 继续触发
        // adder_driver::build_phase
        // adder_sequencer::build_phase
        // adder_monitor::build_phase
        // 完成后，转到 adder_test::connect_phase
    endfunction

    // [2.2] 由 adder_env::connect_phase 调用
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass