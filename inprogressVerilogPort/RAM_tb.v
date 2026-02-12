`timescale 1ns / 1ps

module tb_RAM256x8;

    // Testbench signals
    reg [7:0] addr;
    reg [7:0] dataIn;
    reg readEnable;
    reg writeEnable;
    reg clk;
    wire [7:0] dataOut;

    // Instantiate the RAM
    RAM256x8 uut (
        .addr(addr),
        .dataIn(dataIn),
        .readEnable(readEnable),
        .writeEnable(writeEnable),
        .clk(clk),
        .dataOut(dataOut)
    );

    // Clock generation (10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    integer i;
    reg [7:0] expected;
    reg fail;

    initial begin
        // Initialize signals
        addr = 8'd0;
        dataIn = 8'd0;
        readEnable = 0;
        writeEnable = 0;
        fail = 0;

        // Wait for global reset
        #10;

        // --- WRITE PHASE ---
        for (i = 0; i < 256; i = i + 1) begin
            addr = i[7:0];
            dataIn = i[7:0];      // write the same value as address
            writeEnable = 1;
            #10;                  // wait for clock
            writeEnable = 0;
            #1;                   // small delay
        end

        // --- READ & VERIFY PHASE ---
        for (i = 0; i < 256; i = i + 1) begin
            addr = i[7:0];
            expected = i[7:0];
            readEnable = 1;
            #1;   // small delay to let dataOut stabilize

            if (dataOut !== expected) begin
                $display("FAIL: Addr=%h, Read=%h, Expected=%h", addr, dataOut, expected);
                fail = 1;
            end

            readEnable = 0;
            #1;
        end

        if (fail == 0)
            $display("TEST PASSED: All values read correctly!");
        else
            $display("TEST FAILED: Some values did not match!");

        $stop;
    end

endmodule
