#include "parser.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

static int output_binary = 0; //0 = output is hex, 1 = output bin

static RegDef regs[] = {
    {"R0", 0x00}, {"R1", 0x01}, {"R2", 0x02}, {"R3", 0x03},
    {"R4", 0x04}, {"SP", 0x05}, {"MD", 0x06}, {"MA", 0x07},
    {NULL, 0}
};

static OpDef ops[] = {
    {"NOP",   0b00000, 0},
    {"LOADI", 0b00001, 1},   // operand: immediate
    {"LOADA", 0b00010, 1},   // operand: [addr]
    {"STORE", 0b00011, 1},   // operand: [addr]
    {"MOV",   0b00100, 1},   // operand: register
    {"MOVW",  0b00101, 1},   // operand: register
    {"SET",   0b00001, 1},   // Wreg implied
    {"CLEAR", 0b00001, 1},   // Wreg implied
    {"ADD",   0b01000, 1},   // operand: register
    {"SUB",   0b01001, 1},
    {"AND",   0b01010, 1},
    {"OR",    0b01011, 1},
    {"XOR",   0b01100, 1},
    {"NOT",   0b01101, 0},
    {"INC",   0b01110, 0},
    {"DEC",   0b01111, 0},
    {"JMP",   0b10000, 1},   // operand: [addr]
    {"JZ",    0b10001, 1},
    {"JC",    0b10010, 1},
    {"HLT",   0b10011, 0},
    {"HLT",   0b10100, 0},
    {"OUT",   0b10101, 1}, // operand: immediate
    {NULL, 0, 0}
};

//get register code
static RegDef *find_reg(const char *s) {
    for (int i = 0; regs[i].name; i++)
        if (!strcmp(regs[i].name, s)) return &regs[i];
    return NULL;
}

//find opcode
static OpDef *find_op(const char *s) {
    for (int i = 0; ops[i].name; i++)
        if (!strcmp(ops[i].name, s)) return &ops[i];
    return NULL;
}

void set_output_mode(int binary) {
    output_binary = binary;
}

//parse decimal/hex number
static int parse_number(const char *s) {
    if (s[0] == '0' && s[1] == 'x') return strtol(s, 0, 16);
    return strtol(s, 0, 10);
}

void print_instr_binary(FILE *out, uint16_t instr) {
    uint8_t opcode  = (instr >> 8) & 0x1F;
    uint8_t operand = instr & 0xFF;

    for (int i = 4; i >= 0; i--)
        fputc((opcode & (1 << i)) ? '1' : '0', out);

    fputc(' ', out);

    for (int i = 7; i >= 0; i--)
        fputc((operand & (1 << i)) ? '1' : '0', out);

    fputc('\n', out);
}

void print_instr_hex(FILE *out, uint16_t instr) {
    fprintf(out, "0x%04X\n", instr & 0x1FFF); 
}

void parse_tokens_to_file(const TokenList *list, FILE *out) {
    if (list->count == 0) return;

    OpDef *op = NULL;
    uint8_t operand = 0;

    //parse pseudo-instructions CLEAR and SET
    if (!strcmp(list->tokens[0], "CLEAR")) {
        op = find_op("LOADI"); //internally transform to LOADI
        operand = 0;           //Wreg = 0
    } else if (!strcmp(list->tokens[0], "SET")) {
        op = find_op("LOADI"); //internally transform to LOADI
        operand = 255;         //Wreg = 0xFF
    } else {
        op = find_op(list->tokens[0]);
        if (!op) {
            fprintf(out, "ERROR: Unknown opcode: %s\n", list->tokens[0]);
            return;
        }

        //count operands without Wreg
        int actual_operands = 0;
        for (int i = 1; i < list->count; i++)
            if (strcmp(list->tokens[i], "Wreg") != 0)
                actual_operands++;

        if (actual_operands != op->operands) {
            fprintf(out, "ERROR: %s expects %d operand(s)\n", op->name, op->operands);
            return;
        }

        //parse operand if any
        for (int i = 1; i < list->count; i++) {
            const char *tok = list->tokens[i];
            if (strcmp(tok, "Wreg") == 0) continue;

            if (tok[0] == '[') {
                operand = parse_number(tok + 1);
            } else if (isdigit(tok[0]) || tok[0] == '-') {
                operand = parse_number(tok);
            } else {
                RegDef *r = find_reg(tok);
                if (!r) {
                    fprintf(out, "ERROR: Invalid operand: %s\n", tok);
                    return;
                }
                operand = r->code;
            }
            break;
        }
    }

    //write instruction
    uint16_t instr = (op->opcode << 8) | operand;
    if (output_binary)
        print_instr_binary(out, instr);
    else
        print_instr_hex(out, instr);
}