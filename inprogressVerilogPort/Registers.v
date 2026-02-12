module RegisterFile (
    input  wire [7:0] dataIn,
    input  wire [2:0] writeSelect,
    input  wire       writeEnable,
    input  wire [2:0] readSelect,
    input  wire       clk,
    input  wire       clear,
    output wire [7:0] dataOut
);

    reg [7:0] registers [7:0];

    always @(posedge clk or posedge clear) begin
        if (clear) begin
            //all = 0 if clear == 1
            registers[0] <= 8'b0;   //R0
            registers[1] <= 8'b0;   //R1
            registers[2] <= 8'b0;   //R2
            registers[3] <= 8'b0;   //R3
            registers[4] <= 8'b0;   //R4
            registers[5] <= 8'b0;   //SP
            registers[6] <= 8'b0;   //MD
            registers[7] <= 8'b0;   //MA
        end else if (writeEnable) begin
            registers[writeSelect] <= dataIn;
        end
    end
    assign dataOut = registers[readSelect];

endmodule