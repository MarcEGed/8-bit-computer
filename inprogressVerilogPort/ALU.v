module ALU(
    input wire[7:0] Wreg_w,
    input wire[7:0] Rn_w,
    input wire[2:0] ALU_OP,
    output reg[7:0] ALUResult_w,
    output reg carryF_w,
    output reg zeroF_w
);

reg [8:0] tmp; //to catch carry

always @(*) begin
    case (ALU_OP)
        3'b000: begin                           //ADD
            tmp = Wreg_w + Rn_w;
            ALUResult_w = tmp[7:0];
            carryF_w = tmp[8];
        end
        3'b001: begin                           //SUB
            tmp = {1'b0, Wreg_w} - {1'b0, Rn_w};//concatanaiting a MSB to keep track of borrow
            ALUResult_w = tmp[7:0];
            carryF_w = tmp[8];
        end
        3'b010: begin
            ALUResult_w = Wreg_w & Rn_w;    //AND
            carryF_w = 0;
        end 
        3'b011: begin
            ALUResult_w = Wreg_w | Rn_w;    //OR
            carryF_w = 0;
        end 
        3'b100: begin
            ALUResult_w = Wreg_w ^ Rn_w;    //XOR
            carryF_w = 0;
        end
        3'b101: begin
            ALUResult_w = ~Wreg_w;          //NOT
            carryF_w = 0;
        end 
        3'b110: begin                           //INC
            tmp = Wreg_w + 1;
            ALUResult_w = tmp[7:0];
            carryF_w = tmp[8];
        end
        3'b111: begin                           //DEC
            tmp = {1'b0, Wreg_w} - 1;
            ALUResult_w = tmp[7:0];
            carryF_w = tmp[8];
        end
        default: begin
            ALUResult_w = 8'b0;
            carryF_w = 1'b0;
        end
    endcase

    zeroF_w = (ALUResult_w == 8'b0);
    end
endmodule