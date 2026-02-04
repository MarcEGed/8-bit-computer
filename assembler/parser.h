#ifndef PARSER_H
#define PARSER_H

#include "tokenizer.h"
#include <stdint.h>
#include <stdio.h>

typedef struct {
    const char *name;
    uint8_t code;
} RegDef;

typedef struct {
    const char *name;
    uint8_t opcode;
    int operands;   //how many operands
} OpDef;

void parse_tokens_to_file(const TokenList *list, FILE *out);
void set_output_mode(int binary);

#endif