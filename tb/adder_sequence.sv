// adder_sequence.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

class adder_sequence extends uvm_sequence #(adder_transaction);
    `uvm_object_utils(adder_sequence)

    function new(string name = "adder_sequence");
        super.new(name);
    endfunction

    // 发送 10 个随机事务
    task body();
        `uvm_info("SEQ_BODY","sequence body enter",UVM_LOW)
        // 这里 repeat 相当于 yield
        // 每次 driver.get_next_item() 就会从这里取一个
        repeat(10) begin
            adder_transaction tr = adder_transaction::type_id::create("tr");
            `uvm_info("SEQ_BODY","new transaction",UVM_LOW)

            // sequence 是生产者，生产transaction给driver
            // 这里等待 driver.get_next_item
            start_item(tr);

            // 随机化事务 -- verilator 不支持 randomize
            // 如果需要randomize，需要 apt install z3
            // z3 主要用于密码逆向，网络安全
            //assert(tr.randomize());
            tr.a = $urandom_range(0,255);
            tr.b = $urandom_range(0,255);
            tr.valid_in = 1'b1;

            `uvm_info("SEQ", $sformatf("Sending: %s", tr.convert2string()), UVM_LOW)

            // 调用后解锁 driver.get_next_item()
            // 调用后阻塞，等待 driver.item_done()
            finish_item(tr);
            `uvm_info("SEQ", $sformatf("Sent: %s", tr.convert2string()), UVM_LOW)

            // 等待1个时钟周期，让DUT有时间处理
            // #20;
        end
        `uvm_info("SEQ_BODY","sequence body leave",UVM_LOW)
    endtask
endclass