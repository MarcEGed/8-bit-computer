`timescale 1ns/1ps

module tb_control_unit;

    reg  [7:0] operand;
    reg  [4:0] opcode;
    reg        zeroF;
    reg        carryF;

    wire        WREG_WE;
    wire        WREG_RE;
    wire        REG_WE;
    wire [2:0]  REG_SEL;

    wire        RAM_RE;
    wire        RAM_WE;
    wire        RAM_ADDR_EN;

    wire [3:0]  ALU_OP;
    wire        ALU_EN;

    wire        PC_LOAD;
    wire        PC_EN;

    wire        ROM_TO_DATABUS;
    wire        RN_TO_DATABUS;
    wire        IN_TO_DATABUS;
    wire        OUT_EN;

    wire        HALT;

    control_unit dut (
        .operand(operand),
        .opcode(opcode),
        .zeroF(zeroF),
        .carryF(carryF),

        .WREG_WE(WREG_WE),
        .WREG_RE(WREG_RE),
        .REG_WE(REG_WE),
        .REG_SEL(REG_SEL),

        .RAM_RE(RAM_RE),
        .RAM_WE(RAM_WE),
        .RAM_ADDR_EN(RAM_ADDR_EN),

        .ALU_OP(ALU_OP),
        .ALU_EN(ALU_EN),

        .PC_LOAD(PC_LOAD),
        .PC_EN(PC_EN),

        .ROM_TO_DATABUS(ROM_TO_DATABUS),
        .RN_TO_DATABUS(RN_TO_DATABUS),
        .IN_TO_DATABUS(IN_TO_DATABUS),
        .OUT_EN(OUT_EN),

        .HALT(HALT)
    );

    task check;
        input [127:0] name;
        input exp_WREG_WE, exp_WREG_RE, exp_REG_WE, exp_RAM_RE, exp_RAM_WE, exp_RAM_ADDR_EN;
        input exp_ALU_EN, exp_PC_LOAD, exp_PC_EN, exp_ROM, exp_IN, exp_OUT, exp_HALT;
        begin
            #1;
            if (WREG_WE!==exp_WREG_WE || WREG_RE!==exp_WREG_RE ||
                REG_WE!==exp_REG_WE || RAM_RE!==exp_RAM_RE ||
                RAM_WE!==exp_RAM_WE || RAM_ADDR_EN!==exp_RAM_ADDR_EN ||
                ALU_EN!==exp_ALU_EN || PC_LOAD!==exp_PC_LOAD ||
                PC_EN!==exp_PC_EN || ROM_TO_DATABUS!==exp_ROM ||
                IN_TO_DATABUS!==exp_IN || OUT_EN!==exp_OUT ||
                HALT!==exp_HALT)
            begin
                $display(" FAIL %-10s | WE=%b RE=%b REG_WE=%b RAM_RE=%b RAM_WE=%b PC_LOAD=%b PC_EN=%b HALT=%b",
                         name,WREG_WE,WREG_RE,REG_WE,RAM_RE,RAM_WE,PC_LOAD,PC_EN,HALT);
            end else begin
                $display(" PASS %-10s", name);
            end
        end
    endtask

    initial begin
        $display("=== CONTROL UNIT TEST ===");

        zeroF = 0; carryF = 0; operand = 8'h03;

        opcode = 5'b00000; check("NOP",0,0,0,0,0,0,0,0,1,0,0,0,0);

        opcode = 5'b00001; check("LOADI",1,0,0,0,0,0,0,0,1,1,0,0,0);

        opcode = 5'b00010; check("LOADA",1,0,0,1,0,1,0,0,1,0,0,0,0);

        opcode = 5'b00011; check("STORE",0,1,0,0,1,1,0,0,1,0,0,0,0);

        opcode = 5'b00100; check("MOV",1,0,0,0,0,0,0,0,1,0,0,0,0);

        opcode = 5'b00101; check("MOVW",0,1,1,0,0,0,0,0,1,0,0,0,0);

        opcode = 5'b01000; check("ADD",1,0,0,0,0,0,1,0,1,0,0,0,0);

        opcode = 5'b01001; check("SUB",1,0,0,0,0,0,1,0,1,0,0,0,0);

        opcode = 5'b01101; check("NOT",1,0,0,0,0,0,1,0,1,0,0,0,0);

        opcode = 5'b10000; check("JMP",0,0,0,0,0,0,0,1,0,1,0,0,0);

        zeroF = 1; opcode = 5'b10001; check("JZ(T)",0,0,0,0,0,0,0,1,0,1,0,0,0);

        carryF = 1; opcode = 5'b10010; check("JC(T)",0,0,0,0,0,0,0,1,0,1,0,0,0);

        opcode = 5'b10011; check("HLT",0,0,0,0,0,0,0,0,0,0,0,0,1);

        opcode = 5'b10100; check("IN",1,0,0,0,0,0,0,0,0,0,1,0,0);

        opcode = 5'b10101; check("OUT",0,1,0,0,0,0,0,0,0,0,0,1,0);

        $display("=== TEST COMPLETE ===");
        $finish;
    end

endmodule
