// adder_scoreboard.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

class adder_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(adder_scoreboard)

    uvm_analysis_imp #(adder_transaction, adder_scoreboard) imp;

    // 用于统计
    int pass_count = 0;
    int fail_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
    endfunction

    // 接收 Monitor 发来的事务并比对
    function void write(adder_transaction tr);
        logic [7:0] expected_sum = tr.a + tr.b;  // 参考模型计算期望值

        if (tr.sum == expected_sum && tr.valid_out == 1) begin
            pass_count++;
            `uvm_info("SCORE", $sformatf("PASS: %s, expected=%0d",
                      tr.convert2string(), expected_sum), UVM_LOW)
        end else begin
            fail_count++;
            `uvm_error("SCORE", $sformatf("FAIL: %s, expected=%0d",
                       tr.convert2string(), expected_sum))
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCORE", $sformatf("Final: PASS=%0d, FAIL=%0d", pass_count, fail_count), UVM_LOW)
    endfunction
endclass