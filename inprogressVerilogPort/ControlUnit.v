module control_unit (
    input  wire [7:0] operand,
    input  wire [4:0] opcode,
    input  wire       zeroF,
    input  wire       carryF,

    output reg        WREG_WE,
    output reg        WREG_RE,
    output reg        REG_WE,
    output reg [2:0]  REG_SEL,

    output reg        RAM_RE,
    output reg        RAM_WE,
    output reg        RAM_ADDR_EN,

    output reg [3:0]  ALU_OP,
    output reg        ALU_EN,

    output reg        PC_LOAD,
    output reg        PC_EN,

    output reg        ROM_TO_DATABUS,
    output reg        RN_TO_DATABUS,
    output reg        IN_TO_DATABUS,
    output reg        OUT_EN,

    output reg        HALT
);

    //"decoder"
    localparam NOP_inst    = 5'b00000;
    localparam LOADI_inst  = 5'b00001;
    localparam LOADA_inst  = 5'b00010;
    localparam STORE_inst  = 5'b00011;
    localparam MOV_inst    = 5'b00100;
    localparam MOVW_inst   = 5'b00101;
    //localparam SET_inst    = 5'b00110;
    //localparam CLEAR_inst  = 5'b00111;

    localparam ADD_inst    = 5'b01000;
    localparam SUB_inst    = 5'b01001;
    localparam AND_inst    = 5'b01010;
    localparam OR_inst     = 5'b01011;
    localparam XOR_inst    = 5'b01100;
    localparam NOT_inst    = 5'b01101;
    localparam INC_inst    = 5'b01110;
    localparam DEC_inst    = 5'b01111;

    localparam JMP_inst    = 5'b10000;
    localparam JZ_inst     = 5'b10001;
    localparam JC_inst     = 5'b10010;
    localparam HLT_inst    = 5'b10011;

    localparam IN_inst     = 5'b10100;
    localparam OUT_inst    = 5'b10101;

    always @(*) begin
        //nop default
        WREG_WE = 0; 
        WREG_RE = 0; 
        REG_WE  = 0; 
        REG_SEL = 0;

        RAM_RE = 0; 
        RAM_WE = 0; 
        RAM_ADDR_EN = 0;

        ALU_OP = 0; 
        ALU_EN = 0;

        PC_LOAD = 0; 
        PC_EN   = 1;

        ROM_TO_DATABUS = 0; 
        RN_TO_DATABUS  = 0; 
        IN_TO_DATABUS  = 0;

        OUT_EN = 0;
        HALT   = 0;

        case (opcode)

            NOP_inst: begin
                //already set by default
            end

            LOADI_inst: begin
                ROM_TO_DATABUS = 1;
                WREG_WE = 1;
            end

            LOADA_inst: begin
                RAM_ADDR_EN = 1;
                RAM_RE = 1;
                WREG_WE = 1;
            end

            STORE_inst: begin
                RAM_ADDR_EN = 1;
                RAM_WE = 1;
                WREG_RE = 1;
            end

            MOV_inst: begin
                WREG_WE = 1;
                REG_SEL = operand;
            end

            MOVW_inst: begin
                WREG_RE = 1;
                REG_WE  = 1;
                REG_SEL = operand;
            end

            /*SET_inst: begin
                ROM_TO_DATABUS = 1; // imm = 0xFF
                WREG_WE = 1;
            end

            CLEAR_inst: begin
                ROM_TO_DATABUS = 1; // imm = 0x00
                WREG_WE = 1;
            end*/

            ADD_inst: begin
                REG_SEL = operand;
                ALU_OP = 3'b000;
                ALU_EN = 1;
                WREG_WE = 1;
            end

            SUB_inst: begin
                REG_SEL = operand;
                ALU_OP = 3'b001;
                ALU_EN = 1;
                WREG_WE = 1;
            end

            AND_inst: begin
                REG_SEL = operand;
                ALU_OP = 3'b010;
                ALU_EN = 1;
                WREG_WE = 1;
            end

            OR_inst: begin
                REG_SEL = operand;
                ALU_OP = 3'b011;
                ALU_EN = 1;
                WREG_WE = 1;
            end

            XOR_inst: begin
                REG_SEL = operand;
                ALU_OP = 3'b100;
                ALU_EN = 1;
                WREG_WE = 1;
            end

            NOT_inst: begin
                ALU_OP = 3'b101;
                ALU_EN = 1;
                WREG_WE = 1;
            end

            INC_inst: begin
                ALU_OP = 3'b110;
                ALU_EN = 1;
                WREG_WE = 1;
            end

            DEC_inst: begin
                ALU_OP = 3'b111;
                ALU_EN = 1;
                WREG_WE = 1;
            end

            JMP_inst: begin
                PC_LOAD = 1;
                PC_EN = 0;
                ROM_TO_DATABUS = 1;
            end

            JZ_inst: begin
                if (zeroF) begin
                    PC_LOAD = 1;
                    PC_EN = 0;
                    ROM_TO_DATABUS = 1;
                end
            end

            JC_inst: begin
                if (carryF) begin
                    PC_LOAD = 1;
                    PC_EN = 0;
                    ROM_TO_DATABUS = 1;
                end
            end

            HLT_inst: begin
                HALT = 1;
                PC_EN = 0;
            end

            IN_inst: begin
                IN_TO_DATABUS = 1;
                PC_EN = 0;
                WREG_WE = 1;
            end

            OUT_inst: begin
                OUT_EN = 1;
                PC_EN = 0;
                WREG_RE = 1;
            end

        endcase
    end

endmodule
