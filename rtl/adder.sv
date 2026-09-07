// adder.sv - 一个简单的 8 位加法器
module adder (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  a, b,
    input  logic        valid_in,
    output logic [7:0]  sum,
    output logic        valid_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            sum <= a + b;
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end
endmodule