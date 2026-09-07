// adder_driver.sv
import uvm_pkg::*;
`include "uvm_macros.svh"

class adder_driver extends uvm_driver #(adder_transaction);
    `uvm_component_utils(adder_driver)

    virtual adder_if vif;  // 虚接口

    // 新增：保存sequencer句柄
    // adder_sequencer m_seqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // [1.3] 在 adder_agent::build_phase() 之后调用
    // 从配置数据库获取接口
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Virtual interface not set!")
    endfunction

    // 核心：驱动事务到 DUT
    task run_phase(uvm_phase phase);
        // adder_sequence seq;
        `uvm_info("DRV_RUN","driver run_phase start",UVM_LOW)
        wait(vif.rst_n === 1'b1); //等待复位释放
        `uvm_info("DRV_RUN","rst release, start sequence",UVM_LOW)

        forever begin
            // 从 sequencer 获取事务
            // driver是消费者，消费 sequence 生产的 transaction
            // 这里会解锁 sequence.start_item()
            // 这里会等待 Sequence.finish_item()
            seq_item_port.get_next_item(req);
            `uvm_info("DRV_RUN","get transaction from sequencer",UVM_LOW)

            // // 将事务内容驱动到引脚
            // @(posedge vif.clk);
            // `uvm_info("DRV_RUN","clock posedge 1",UVM_LOW)
            // vif.a        <= req.a;
            // vif.b        <= req.b;
            // vif.valid_in <= 1'b1;

            // @(posedge vif.clk);
            // `uvm_info("DRV_RUN","clock posedge 2",UVM_LOW)
            // vif.valid_in <= 1'b0;  // 只驱动一个周期

            @(vif.driver_cb);
            `uvm_info("DRV_RUN","clock posedge 1",UVM_LOW)
            vif.driver_cb.a        <= req.a;
            vif.driver_cb.b        <= req.b;
            vif.driver_cb.valid_in <= 1'b1;

            @(vif.driver_cb);
            `uvm_info("DRV_RUN","clock posedge 2",UVM_LOW)
            vif.driver_cb.valid_in <= 1'b0;

            // 这里会解锁 sequence.finish_item
            seq_item_port.item_done();  // 通知 sequencer 完成
            `uvm_info("DRV_RUN","run end",UVM_LOW)
        end
    endtask
endclass