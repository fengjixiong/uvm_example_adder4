// adder_monitor.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)

    virtual adder_if vif;
    uvm_analysis_port #(adder_transaction) ap;  // 发送给 Scoreboard

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    // [1.4] 在 adder_agent::build_phase() 之后调用
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Virtual interface not set!")
    endfunction

    // 采样 DUT 输出
    task run_phase(uvm_phase phase);
        forever begin
            // 使用 clocking block 采样
            @(vif.monitor_cb);

            if (vif.monitor_cb.valid_out === 1'b1) begin
                adder_transaction tr = adder_transaction::type_id::create("tr");
                tr.a         = vif.monitor_cb.a;
                tr.b         = vif.monitor_cb.b;
                tr.sum       = vif.monitor_cb.sum;
                tr.valid_out = vif.monitor_cb.valid_out;

                // 发送到 Scoreboard 进行比对
                ap.write(tr);

                `uvm_info("MON", $sformatf("Monitored: %s", tr.convert2string()), UVM_LOW)
            end
        end
    endtask
endclass