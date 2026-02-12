`timescale 1ns/1ps

module tb_ROM;

    reg [7:0] addr;
    wire [12:0] data;

    ROM256 uut (
        .addr(addr),
        .data(data)
    );

    integer i;

    initial begin
        $display("ROM Contents from test.bin.txt:");
        for (i = 0; i < 256; i = i + 1) begin
            addr = i;
            #1;
            $display("Address %0d : Data = %013b", i, data);
        end
        $finish;
    end

endmodule
