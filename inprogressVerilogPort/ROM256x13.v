module ROM256(
    input wire[7:0]  addr,
    output reg[12:0] data
);
    reg[12:0] mem[0:255];
    initial begin
        $readmemh("test.hex.txt", mem);
    end
    always @(*) begin
        data = mem[addr];
    end
endmodule