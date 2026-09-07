// adder_transaction.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

class adder_transaction extends uvm_sequence_item;
    `uvm_object_utils(adder_transaction)  // 注册到 UVM 工厂

    rand logic [7:0] a, b;      // 随机输入
         logic [7:0] sum;       // 期望输出（DUT输出）
         logic       valid_in;
         logic       valid_out; // 输出有效

    // 约束：让输入随机化
    constraint valid_input {
        a inside {[0:255]};
        b inside {[0:255]};
    }

    function new(string name = "adder_transaction");
        super.new(name);
    endfunction

    // 打印函数（调试用）
    function string convert2string();
        return $sformatf("a=%0d, b=%0d, sum=%0d, valid=%0d", a, b, sum, valid_out);
    endfunction
endclass