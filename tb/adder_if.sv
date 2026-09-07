// adder_if.sv
interface adder_if (input logic clk, input logic rst_n);
    logic [7:0] a, b;
    logic       valid_in;
    logic [7:0] sum;
    logic       valid_out;

    // 驱动时钟块
    clocking driver_cb @(posedge clk);
        default input #1step output #1;
        output a, b, valid_in;
        input  sum, valid_out;
    endclocking

    // 监控时钟块
    clocking monitor_cb @(posedge clk);
        default input #1step output #1;
        input  a, b, valid_in, sum, valid_out;
    endclocking

    // 时钟驱动块（用于 Driver）
    modport DRIVER (
        clocking driver_cb,
        input  clk, rst_n
    );

    // 监视块（用于 Monitor）
    modport MONITOR (
        clocking monitor_cb,
        input clk, rst_n
    );

endinterface