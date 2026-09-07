// tb_top.sv
module tb_top;
    logic        clk;
    logic        rst_n;
    adder_if     vif(clk, rst_n);  // 实例化接口

    // 实例化 DUT
    adder dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .a        (vif.a),
        .b        (vif.b),
        .valid_in (vif.valid_in),
        .sum      (vif.sum),
        .valid_out(vif.valid_out)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // 复位
    initial begin
        rst_n = 0;
        #30 rst_n = 1;
    end

    // 将接口放入配置数据库
    initial begin
        uvm_config_db#(virtual adder_if)::set(null, "*", "vif", vif);

        // 这里不能等待，UVM要求 run_test 必须在 #0 时刻调用
        // #40; // 等待复位释放，rst_n在#30变成1，这里#40确保复位已经完成
        run_test("adder_test");  // [0] 启动 UVM 测试 -- 测试入口点
        //接下来发生
        //步骤   动作  说明
        //0.1 run_test("adder_test") 被调用，是UVM 静态方法，启动整个仿真。参数 "adder_test" 指定要运行的测试用例名。
        //0.2 UVM 内部通过工厂机制（Factory） 创建 adder_test 实例  根据字符串名"adder_test"，查找已注册的类，实例化。
        //0.3 adder_test 的构造函数 new() 执行   执行 super.new(name, parent)，初始化父类。
        //0.4 进入 adder_test::build_phase  正式开始 Phase 流程。
    end

    // 波形导出
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_top);
    end
endmodule