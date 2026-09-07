// simple_tb.sv - 一个文件搞定全部
module simple_tb;
    logic        clk, rst_n;
    logic [7:0]  a, b, sum;
    logic        valid_in, valid_out;

    // 1. 实例化DUT
    adder dut (.*);

    // 2. 时钟
    always #10 clk = ~clk;

    // 3. 测试逻辑
    initial begin
        // 复位
        rst_n = 0; clk = 0; valid_in = 0;
        #30 rst_n = 1;

        // 发送10个随机测试
        for (int i = 0; i < 10; i++) begin
            @(posedge clk);
            a = $random(); b = $random();
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            // 等待结果并检查
            @(posedge clk);
            while (!valid_out) @(posedge clk);
            if (sum != a + b)
                $display("FAIL: %d + %d = %d, expected %d", a, b, sum, a+b);
            else
                $display("PASS: %d + %d = %d", a, b, sum);
        end

        $display("Test done");
        $finish;
    end

    // 4. 波形
    initial begin
        $dumpfile("simple.vcd");
        $dumpvars(0, simple_tb);
    end
endmodule