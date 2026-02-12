module ClockedReg (
    input  wire        clk,
    input  wire        WE,
    input  wire [7:0]  d,
    output reg  [7:0]  q = 8'b0
);

always @(posedge clk) begin
    if (WE)
        q <= d;
    end

endmodule

module PCBlock(
    input wire [7:0] past_addr,
    input wire [7:0] JUMP_addr,
    input wire       pc_load_Flag,
    input wire       halt_Flag,
    input wire       clk,
    output wire[7:0] current_addr,
);

reg  [7:0] adder_result;
reg  [7:0] mux_output;
reg  [7:0] PC_D;
wire [7:0] PC_Q;

always @(*) begin
    adder_result = past_addr + 1;

    if (halt_Flag)
        mux_output = past_addr;
    else
        mux_output = adder_result;

    if (pc_load_Flag)
        PC_D = JUMP_addr;
    else
        PC_D = mux_output;

    ClockedReg PC_reg(
        .clk(clk),
        .WE(1'b1),
        .d(PC_D),
        .q(PC_Q)
    );

    assign current_addr = PC_Q;

endmodule