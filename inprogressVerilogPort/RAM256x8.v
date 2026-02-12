module RAM256x8 (
    input  wire [7:0] addr,
    input  wire [7:0] dataIn,
    input  wire       readEnable,
    input  wire       writeEnable,
    input  wire       clk,
    output wire [7:0] dataOut
);

    reg [7:0] memory [0:255];

    always @(posedge clk) begin
        if (writeEnable) begin
            memory[addr] <= dataIn;
        end
    end

    assign dataOut = (readEnable) ? memory[addr] : 8'bzzzzzzzz;

endmodule