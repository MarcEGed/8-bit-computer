`timescale 1ns/1ps

module ALU_tb;

    // Inputs
    reg [7:0] Wreg_w;
    reg [7:0] Rn_w;
    reg [2:0] ALU_OP;

    // Outputs
    wire [7:0] ALUResult_w;
    wire       carryF_w;
    wire       zeroF_w;

    // Instantiate the ALU
    ALU uut (
        .Wreg_w(Wreg_w),
        .Rn_w(Rn_w),
        .ALU_OP(ALU_OP),
        .ALUResult_w(ALUResult_w),
        .carryF_w(carryF_w),
        .zeroF_w(zeroF_w)
    );

    // Expected outputs
    reg [7:0] expected_result;
    reg       expected_carry;
    reg       expected_zero;

    // Task to check ALU output
    task check_outputs;
    begin
        if (ALUResult_w !== expected_result || carryF_w !== expected_carry || zeroF_w !== expected_zero) begin
            $display("ERROR at time %0t: OP=%b Wreg=%d Rn=%d | Got Result=%d Carry=%b Zero=%b | Expected Result=%d Carry=%b Zero=%b",
                      $time, ALU_OP, Wreg_w, Rn_w, ALUResult_w, carryF_w, zeroF_w,
                      expected_result, expected_carry, expected_zero);
        end else begin
            $display("PASS at time %0t: OP=%b Wreg=%d Rn=%d | Result=%d Carry=%b Zero=%b",
                      $time, ALU_OP, Wreg_w, Rn_w, ALUResult_w, carryF_w, zeroF_w);
        end
    end
    endtask

    initial begin
        // ADD
        Wreg_w = 8'd10; Rn_w = 8'd5; ALU_OP = 3'b000;
        expected_result = 15; expected_carry = 0; expected_zero = 0;
        #10 check_outputs();

        Wreg_w = 8'd255; Rn_w = 8'd1; ALU_OP = 3'b000;
        expected_result = 0; expected_carry = 1; expected_zero = 1;
        #10 check_outputs();

        // SUB
        Wreg_w = 8'd10; Rn_w = 8'd5; ALU_OP = 3'b001;
        expected_result = 5; expected_carry = 0; expected_zero = 0;
        #10 check_outputs();

        Wreg_w = 8'd5; Rn_w = 8'd10; ALU_OP = 3'b001;
        expected_result = 251; expected_carry = 1; expected_zero = 0;
        #10 check_outputs();

        // AND
        Wreg_w = 8'b11001100; Rn_w = 8'b10101010; ALU_OP = 3'b010;
        expected_result = 8'b10001000; expected_carry = 0; expected_zero = 0;
        #10 check_outputs();

        // OR
        ALU_OP = 3'b011; 
        expected_result = 8'b11101110; expected_carry = 0; expected_zero = 0;
        #10 check_outputs();

        // XOR
        ALU_OP = 3'b100;
        expected_result = 8'b01100110; expected_carry = 0; expected_zero = 0;
        #10 check_outputs();

        // NOT
        Wreg_w = 8'b11001100; ALU_OP = 3'b101;
        expected_result = 8'b00110011; expected_carry = 0; expected_zero = 0;
        #10 check_outputs();

        // INC
        Wreg_w = 8'd255; ALU_OP = 3'b110;
        expected_result = 0; expected_carry = 1; expected_zero = 1;
        #10 check_outputs();

        // DEC
        Wreg_w = 8'd0; ALU_OP = 3'b111;
        expected_result = 8'd255; expected_carry = 1; expected_zero = 0;
        #10 check_outputs();

        $finish;
    end

endmodule
